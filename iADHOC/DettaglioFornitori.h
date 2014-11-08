//
//  DettaglioFornitori.h
//  iADHOC
//
//  Created by Mirko Totera on 06/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLClient.h"
@interface DettaglioFornitori : UIViewController <SQLClientDelegate>{
    
    NSMutableDictionary *ClientiElenco;
    NSArray *keyArray;
    NSArray *valueArray;
    NSString *ragione;
    // NSArray *elements;

    
}
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
-(void)CaricaDettaglioDB: (NSString*)SQLstring;
@end
