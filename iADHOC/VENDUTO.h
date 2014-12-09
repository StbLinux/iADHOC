//
//  VENDUTO.h
//  iADHOC
//
//  Created by Mirko Totera on 25/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import <Foundation/Foundation.h>
//as SLCODESE,MAX(SIT_FIDI.FIDATELA) as FIDATELA,MAX(SIT_FIDI.FIIMPPAP) as FIIMPPAP,MAX(SIT_FIDI.FIIMPESC) as FIIMPESC,MAX(SIT_FIDI.FIIMPESO) as FIIMPESO,MAX(SIT_FIDI.FIIMPORD) as FIIMPORD,MAX(SIT_FIDI.FIIMPDDT) as FIIMPDDT,MAX(SIT_FIDI.FIIMPFAT) as FIIMPFAT,MAX(SALDICON.SLDARPER-SALDICON.SLAVEPER) as SALDOC
@interface VENDUTO : NSObject
@property (nonatomic, strong) NSString *GLOBALE;
@property (nonatomic, strong) NSString *ODIERNO;
@property (nonatomic, strong) NSString *SALDOCON;
@property (nonatomic, strong) NSString *DATELA;
@property (nonatomic, strong) NSString *PARTITEAPERTE;
@property (nonatomic, strong) NSString *FIIMPESC;
@property (nonatomic, strong) NSString *FIIMPESO;
@property (nonatomic, strong) NSString *FIIMPORD;
@property (nonatomic, strong) NSString *FIIMPDDT;
@property (nonatomic, strong) NSString *FIIMPFAT;






@end
