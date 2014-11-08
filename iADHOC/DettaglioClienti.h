//
//  DettaglioClienti.h
//  iADHOC
//
//  Created by Mirko Totera on 07/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface DettaglioClienti : UIViewController


@property (retain,nonatomic) NSString *pCodiceCliente;
@property (retain,nonatomic) NSString *pRagsoc;
@property (retain, nonatomic) NSString *pIndirizzo;
@property (retain, nonatomic) NSString *pCap;
@property (retain, nonatomic) NSString *pPaese;
@property (retain, nonatomic) NSString *pProvincia;
@property (retain, nonatomic) NSString *pTelefono;
@property (retain, nonatomic) NSString *pEMAIL;
@property (retain,nonatomic) NSString *pcodpag;

@property (strong, nonatomic) IBOutlet UILabel *CodiceCliente;
@property (strong, nonatomic) IBOutlet UILabel *RagioneSociale;
@property (strong, nonatomic) IBOutlet UILabel *Indirizzo;
@property (strong, nonatomic) IBOutlet UILabel *Cap;
@property (strong, nonatomic) IBOutlet UILabel *Paese;
@property (strong, nonatomic) IBOutlet UILabel *Provincia;
@property (strong, nonatomic) IBOutlet UILabel *Telefono;
@property (strong, nonatomic) IBOutlet UILabel *EMAIL;





@end
