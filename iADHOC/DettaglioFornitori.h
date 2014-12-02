//
//  DettaglioFornitori.h
//  iADHOC
//
//  Created by Mirko Totera on 06/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@import MapKit;

@interface DettaglioFornitori : UIViewController <UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UILabel *codice;
@property (strong, nonatomic) IBOutlet UILabel *ragsoc;
@property (strong, nonatomic) IBOutlet UILabel *indirizzo;
@property (strong, nonatomic) IBOutlet UILabel *cap;
@property (strong, nonatomic) IBOutlet UILabel *paese;
@property (strong, nonatomic) IBOutlet UILabel *provincia;
@property (strong, nonatomic) IBOutlet UILabel *telefono;
@property (strong, nonatomic) IBOutlet UILabel *email;

@property (strong, nonatomic) IBOutlet UILabel *CodPag;


@property (retain,nonatomic) NSString *pCodiceFornitore;
@property (retain,nonatomic) NSString *pRagsoc;
@property (retain, nonatomic) NSString *pIndirizzo;
@property (retain, nonatomic) NSString *pCap;
@property (retain, nonatomic) NSString *pPaese;
@property (retain, nonatomic) NSString *pProvincia;
@property (retain, nonatomic) NSString *pTelefono;
@property (retain, nonatomic) NSString *pEMAIL;
@property (retain,nonatomic) NSString *pcodpag;

@property (strong,nonatomic)  CLLocationManager    *locationmanager;
- (IBAction)Naviga:(id)sender;

@end
