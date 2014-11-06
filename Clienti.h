//
//  Clienti.h
//  iADHOC
//
//  Created by Mirko Totera on 05/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLClient.h"
@interface Clienti : UITableViewController <SQLClientDelegate>
{
    
    NSMutableDictionary *ClientiElenco;
    NSArray *keyArray;
    NSArray *valueArray;
    NSString *ragione;
   // NSArray *elements;
}
-(void)EstrapolaDati;

@end
