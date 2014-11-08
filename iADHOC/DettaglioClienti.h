//
//  DettaglioClienti.h
//  iADHOC
//
//  Created by Mirko Totera on 07/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLClient.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface DettaglioClienti : UIViewController <SQLClientDelegate>{
    NSArray *tablesource;
    
}


@property (retain,nonatomic) NSString *pCodiceCliente;
@property (retain,nonatomic) NSString *pRagsoc;
@property (strong, nonatomic) IBOutlet UILabel *CodiceCliente;
@property (strong, nonatomic) IBOutlet UILabel *RagioneSociale;
@property (strong, nonatomic) IBOutlet UILabel *Indirizzo;
@property (strong, nonatomic) IBOutlet UILabel *Cap;
@property (strong, nonatomic) IBOutlet UILabel *Paese;
@property (strong, nonatomic) IBOutlet UILabel *Provincia;
@property (strong, nonatomic) IBOutlet UILabel *Telefono;
@property (strong, nonatomic) IBOutlet UILabel *EMAIL;





-(void)CaricaDettaglioDB: (NSString*)SQLstring;

@end
