//
//  DettaglioClienti.m
//  iADHOC
//
//  Created by Mirko Totera on 07/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import "DettaglioClienti.h"
#import "VendutoCliente.h"

@interface DettaglioClienti () <MKMapViewDelegate,CLLocationManagerDelegate> {
    MKPolyline *_routeOverlay;
    MKRoute *_currentRoute;
    MKMapView *mappa;
    
}

- (IBAction)Indietro:(id)sender;
@property (strong, nonatomic) IBOutlet UINavigationBar *Navigazione;

@end

@implementation DettaglioClienti

-(void) viewWillAppear:(BOOL)animated{
    
   // NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
   // NSLog(@"%@",iOSVersion);
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
      _CodiceCliente.text=_pCodiceCliente;
    _RagioneSociale.text=_pRagsoc;
    _Indirizzo.text=_pIndirizzo;
   
    _Cap.text=_pCap;
    _Paese.text=_pPaese;
    _EMAIL.text=_pEMAIL;
    _Provincia.text=_pProvincia;
    _Telefono.text=_pTelefono;
    //mappa.delegate=self;
  
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

       
   
            }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
     //  NSLog(@"%@",@"updateuserlocation");
    
    MKCoordinateRegion mapRegion;
            mapRegion.center = mappa.userLocation.coordinate;
        mapRegion.span = MKCoordinateSpanMake(0.1, 0.15);
        [mappa setRegion:mapRegion animated: YES];
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"VENDUTO"])
        {
    
            VendutoCliente *VenCli = [segue destinationViewController];
            VenCli.pCodiceCliente=_CodiceCliente.text;

    }

}


- (IBAction)Indietro:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
-(IBAction)percorso:(id)sender {
    NSLog(@"%@", @"percorso");

   // NSString *location = @"some address, state, and zip";
    NSString *location = [NSString stringWithFormat:@"%@%@%@%@%@",_Paese.text,@",",_Indirizzo.text,@",",_Cap.text];
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
        _routeOverlay = route.polyline;
        // Add it to the map
        [mappa addOverlay:_routeOverlay];

    
    
    
}
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor greenColor];
    renderer.lineWidth = 6.0;
    return  renderer;
}
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mappa dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}
- (IBAction)Chiama:(UITapGestureRecognizer *)sender {
    //Telefono, la vostra applicazione andrà in background per lasciare spazio al telefono
    NSLog(@"%@",@"ECCOMI");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"tel://",self.Telefono.text]]];
}
- (IBAction)SendEmail:(UITapGestureRecognizer *)sender {
    //Mail, la vostra applicazione si chiuderà passando tutti i parametri ed eventuali allegati a mail
    NSLog(@"%@",@"ECCOMI");

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",@"mailto:",self.EMAIL.text,@"?"]]];

                                                
                                                
    

}


@end
