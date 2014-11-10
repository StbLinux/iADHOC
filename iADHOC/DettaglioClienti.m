//
//  DettaglioClienti.m
//  iADHOC
//
//  Created by Mirko Totera on 07/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import "DettaglioClienti.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface DettaglioClienti ()
- (IBAction)Indietro:(id)sender;
@property (strong, nonatomic) IBOutlet UINavigationBar *Navigazione;


@end

@implementation DettaglioClienti

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _CodiceCliente.text=_pCodiceCliente;
    _RagioneSociale.text=_pRagsoc;
    _Indirizzo.text=_pIndirizzo;
    _Cap.text=_pCap;
    _Paese.text=_pPaese;
    _EMAIL.text=_pEMAIL;
    _Provincia.text=_pProvincia;
    _Telefono.text=_pTelefono;
    _locationmanager = [[CLLocationManager alloc]init]; // initializing locationManager
    _locationmanager.delegate = self;
    _mappa.delegate=self;
    _locationmanager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    [_locationmanager requestWhenInUseAuthorization]; // iOS 8 MUST
    [_locationmanager startUpdatingLocation];  //requesting location updates
   [ self.locationmanager requestWhenInUseAuthorization];
   self.mappa.showsUserLocation=YES;
   
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
    
}
@end
