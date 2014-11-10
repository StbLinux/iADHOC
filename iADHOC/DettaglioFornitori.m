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
}
- (IBAction)Torna:(id)sender;

@end

@implementation DettaglioFornitori
- (void)viewDidLoad {
    [super viewDidLoad];
       _codice.text=_pCodiceFornitore;
       _ragsoc.text=_pRagsoc;
    _indirizzo.text=_pIndirizzo;
    _cap.text=_pCap;
    _paese.text=_pPaese;
    _email.text=_pEMAIL;
    _provincia.text=_pProvincia;
    _telefono.text=_pTelefono;

    _mappa.delegate=self;
    CLLocationManager    *locationmanager = [CLLocationManager new]; // initializing locationManager
    locationmanager.delegate = self;
    locationmanager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    [locationmanager requestAlwaysAuthorization];
    [_mappa setShowsUserLocation:YES];
    [self percorso];

 
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion mapRegion;
    mapRegion.center = _mappa.userLocation.coordinate;
    mapRegion.span = MKCoordinateSpanMake(0.4, 0.4);
    [_mappa setRegion:mapRegion animated: YES];
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


@end
