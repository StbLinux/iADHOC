//
//  DettaglioClienti.m
//  iADHOC
//
//  Created by Mirko Totera on 07/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import "DettaglioClienti.h"
@interface DettaglioClienti () <MKMapViewDelegate,CLLocationManagerDelegate> {
    MKPolyline *_routeOverlay;
    MKRoute *_currentRoute;
}

- (IBAction)Indietro:(id)sender;
@property (strong, nonatomic) IBOutlet UINavigationBar *Navigazione;

@end

@implementation DettaglioClienti
-(void) viewWillAppear:(BOOL)animated{
    _locationmanager = [CLLocationManager new]; // initializing locationManager
    _locationmanager.delegate = self;
    _locationmanager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    [_locationmanager requestWhenInUseAuthorization];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   /* UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(Chiama:)];
    
    // Specify that the gesture must be a single tap
    tapRecognizer.numberOfTapsRequired = 1;
    
    // Add the tap gesture recognizer to the view
       [self.view addGestureRecognizer:tapRecognizer];*/
    _CodiceCliente.text=_pCodiceCliente;
    _RagioneSociale.text=_pRagsoc;
    _Indirizzo.text=_pIndirizzo;
   
    _Cap.text=_pCap;
    _Paese.text=_pPaese;
    _EMAIL.text=_pEMAIL;
    _Provincia.text=_pProvincia;
    _Telefono.text=_pTelefono;
    _mappa.delegate=self;
   
    [_mappa setShowsUserLocation:YES];
    [self percorso];
    
    
    
          }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"%@",@"updateuserlocation");
    MKCoordinateRegion mapRegion;
    mapRegion.center = _mappa.userLocation.coordinate;
    mapRegion.span = MKCoordinateSpanMake(0.1, 0.15);
    [_mappa setRegion:mapRegion animated: YES];
}

#pragma mark - Navigation
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Indietro:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
-(void)percorso {
   
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
            }];
            NSLog(@"%@",@"pippO");
          // .location.coordinate.latitude; //will returns latitude
            //             placemark.location.coordinate.longitude; will returns longitude
        }
    }];
    
    // Make the destination
    

}
- (void)plotRouteOnMap:(MKRoute *)route
{
    if(_routeOverlay) {
        [self.mappa removeOverlay:_routeOverlay];
    }
    
    // Update the ivar
    _routeOverlay = route.polyline;
    
    // Add it to the map
    [self.mappa addOverlay:_routeOverlay];
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
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"tel://",self.Telefono.text]]];
}
- (IBAction)SendEmail:(UITapGestureRecognizer *)sender {
    //Mail, la vostra applicazione si chiuderà passando tutti i parametri ed eventuali allegati a mail
    NSLog(@"%@",@"ECCOMI");

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",@"mailto:",self.EMAIL.text,@"?"]]];

                                                
                                                
    

}

@end
/*_locationmanager = [[CLLocationManager alloc]init]; // initializing locationManager
 _locationmanager.delegate = self;
 _mappa.delegate=self;
 _locationmanager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
 [_locationmanager requestWhenInUseAuthorization]; // iOS 8 MUST
 [_locationmanager startUpdatingLocation];  //requesting location updates
 [ self.locationmanager requestWhenInUseAuthorization];
 self.mappa.showsUserLocation=YES;*/

