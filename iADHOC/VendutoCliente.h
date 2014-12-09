//
//  VendutoCliente.h
//  iADHOC
//
//  Created by Mirko Totera on 25/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLClient.h"
#import"AppDelegate.h"
#import "VENDUTO.h"
@import MapKit;
@interface VendutoCliente : UIViewController <SQLClientDelegate,UISearchBarDelegate>
@property (retain,nonatomic) NSString *pCodiceCliente;
@property (strong, nonatomic) IBOutlet UILabel *Imponibile;
@property (strong, nonatomic) IBOutlet UILabel *SaldoContabile;
@property (nonatomic) VENDUTO *venduto;
@property (strong, nonatomic) IBOutlet UILabel *Labelsaldo;
@property (strong, nonatomic) IBOutlet UILabel *PARTITE;
@property (strong, nonatomic) IBOutlet UILabel *DDT;
@property (strong, nonatomic) IBOutlet UILabel *FATTURE;

@property (strong, nonatomic) IBOutlet UILabel *ORDINI;
- (BOOL)checkConnection;

-(void)EstrapolaDati:(NSString*) SQLstring LABEL:(NSString*)label;

@end
