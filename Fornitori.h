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
    NSArray *tablesource;
    // NSArray *elements;

}
-(void)EstrapolaDati:(NSString*) SQLstring;;


@end
