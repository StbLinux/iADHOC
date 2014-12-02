//
//  DettaglioFornitori.m
//  iADHOC
//
//  Created by Mirko Totera on 06/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import "DettaglioFornitori.h"
@interface DettaglioFornitori ()<MKMapViewDelegate,CLLocationManagerDelegate>{
    MKPolyline *_routeOverlay;
    MKRoute *_currentRoute;
    MKMapView *mappa;

}
- (IBAction)Torna:(id)sender;

@end

@implementation DettaglioFornitori
-(void) viewWillAppear:(BOOL)animated{
    
    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
    NSLog(@"%@",iOSVersion);
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
           _locationmanager = [CLLocationManager new]; // initializing locationManager
        _locationmanager.delegate = self;
        _locationmanager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    if (![mainDelegate.iPhone isEqualToString:@"iPhone 4"]) {
        [_locationmanager requestWhenInUseAuthorization];
        
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    _codice.text=_pCodiceFornitore;
       _ragsoc.text=_pRagsoc;
    _indirizzo.text=_pIndirizzo;
    _cap.text=_pCap;
    _paese.text=_pPaese;
    _email.text=_pEMAIL;
    _provincia.text=_pProvincia;
    _telefono.text=_pTelefono;
        if ([mainDelegate.iPhone isEqualToString:@"iPhone 4"] ) {
        mappa= [[MKMapView alloc]initWithFrame:
                CGRectMake(10, 300, 300, 280)];
        
    }
    else {
        mappa= [[MKMapView alloc]initWithFrame:
                CGRectMake(10, 280, 350, 360)];
    }
    
    mappa.delegate = self;
    [self.view addSubview:mappa];
    [mappa setShowsUserLocation:YES];
   
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"%@",@"updateuserlocation");
    MKCoordinateRegion mapRegion;
    mapRegion.center = mappa.userLocation.coordinate;
    mapRegion.span = MKCoordinateSpanMake(0.1, 0.15);
    [mappa setRegion:mapRegion animated: YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Torna:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)percorso {
   // NSLog(@"%@", @"percorso");
    
    // NSString *location = @"some address, state, and zip";
    NSString *location = [NSString stringWithFormat:@"%@%@%@%@%@",_paese.text,@",",_indirizzo.text,@",",_cap.text];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            MKDirectionsRequest *directionsRequest = [MKDirectionsRequest new];
            MKMapItem *source = [MKMapItem mapItemForCurrentLocation];
            CLLocationCoordinate2D destinationCoords = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);
            MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
            MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
            // Set the source and destination on the request
            [directionsRequest setSource:source];
            [directionsRequest setDestination:destination];
            MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
            [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
                // Now handle the result
                if (error) {
                    NSLog(@"There was an error getting your directions");
                    return;
                }
                
                // So there wasn't an error - let's plot those routes
                _currentRoute = [response.routes firstObject];
                [self plotRouteOnMap:_currentRoute];
                NSLog(@"%f",_currentRoute.polyline.coordinate.latitude);
            }];
            // NSLog(@"%@",@"pippO");
            // .location.coordinate.latitude; //will returns latitude
            //             placemark.location.coordinate.longitude; will returns longitude
        }
    }];
    
    // Make the destination
    // [_mappa setShowsUserLocation:NO];
    
}

- (void)plotRouteOnMap:(MKRoute *)route
{
    if(_routeOverlay) {
        [mappa removeOverlay:_routeOverlay];
    }
    
    // Update the ivar
    _routeOverlay = route.polyline;
    
    // Add it to the map
    [mappa addOverlay:_routeOverlay];
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 4.0;
    return  renderer;
}
- (IBAction)Chiama:(UITapGestureRecognizer *)sender {
    //Telefono, la vostra applicazione andrà in background per lasciare spazio al telefono
    NSLog(@"%@",@"ECCOMI");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"tel://",self.telefono.text]]];
}
- (IBAction)SendEmail:(UITapGestureRecognizer *)sender {
    //Mail, la vostra applicazione si chiuderà passando tutti i parametri ed eventuali allegati a mail
    NSLog(@"%@",@"ECCOMI");
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",@"mailto:",self.email.text,@"?"]]];
    
    
    
    
    
}
-(void)AvviaNavigazione {
    NSString *indirizzo=[NSString stringWithFormat:@"%@%@%@%@%@",_paese.text,@",",_indirizzo.text,@",",_cap.text];
    // MKMapItem *mapItemClass=[[MKMapItem alloc]init];
    
    // NSLog(@"%s","ENTRO NAVIGAZIONE");
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:indirizzo
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     
                     // Convert the CLPlacemark to an MKPlacemark
                     // Note: There's no error checking for a failed geocode
                     CLPlacemark *geocodedPlacemark = [placemarks objectAtIndex:0];
                     MKPlacemark *placemark = [[MKPlacemark alloc]
                                               initWithCoordinate:geocodedPlacemark.location.coordinate
                                               addressDictionary:geocodedPlacemark.addressDictionary];
                     
                     // Create a map item for the geocoded address to pass to Maps app
                     MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
                     [mapItem setName:geocodedPlacemark.name];
                     
                     // Set the directions mode to "Driving"
                     // Can use MKLaunchOptionsDirectionsModeWalking instead
                     NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
                     
                     // Get the "Current User Location" MKMapItem
                     MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
                     
                     // Pass the current location and destination map items to the Maps app
                     // Set the direction mode in the launchOptions dictionary
                     [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem] launchOptions:launchOptions];
                     
                 }];
    
    
}

- (IBAction)Naviga:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Navigazione"
                                                             delegate:self
                                                    cancelButtonTitle:@"Annulla"
                                               destructiveButtonTitle:@"Visualizza percorso"
                                                    otherButtonTitles:@"Avvia navigazione",nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // In this case the device is an iPad.
        [actionSheet showFromRect:[(UIButton *)sender frame] inView:self.view animated:YES];
    }
    else{
        // In this case the device is an iPhone/iPod Touch.
        [actionSheet showInView:self.view];
    }
    
    actionSheet.tag = 100;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        
        //   NSLog(@"Index = %ld - Title = %@", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
        if (buttonIndex==0) {
            
            [self percorso];
        }
        
        if (buttonIndex==1) {
            
            [self AvviaNavigazione];
        }
        
        
        
    }
}


@end
