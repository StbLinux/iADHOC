//
//  ANACLI.h
//  iADHOC
//
//  Created by Mirko Totera on 08/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANACLI : NSObject{
    NSString *codice; // codice cliente
    NSString *ragsoc; // ragione sociale
    NSString *paese; // Paese
    NSString *indirizzo; //
     NSString *cap; //
    NSString *provincia; //
    NSString *telefono; //
  NSString *email; //
NSString *codpag; //
    
}

@property (nonatomic, strong) NSString *codice; // codice cliente
@property (nonatomic, strong) NSString *ragsoc; // ragione sociale
@property (nonatomic, strong) NSString *paese; // Paese
@property (nonatomic, strong) NSString *indirizzo; //
@property (nonatomic, strong) NSString *cap; //
@property (nonatomic, strong) NSString *provincia; //
@property (nonatomic, strong) NSString *telefono; //
@property (nonatomic, strong) NSString *email; //
@property (nonatomic, strong) NSString *codpag; //
@end
