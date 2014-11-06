//
//  Fornitori.h
//  iADHOC
//
//  Created by Mirko Totera on 06/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLClient.h"
@interface Fornitori : UITableViewController <SQLClientDelegate>
{
    
    NSMutableDictionary *ClientiElenco;
    NSArray *keyArray;
    NSArray *valueArray;
    NSString *ragione;
    // NSArray *elements;
}
-(void)EstrapolaDati;


@end
