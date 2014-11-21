//
//  Articoli.h
//  iADHOC
//
//  Created by Mirko Totera on 21/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLClient.h"
#import"AppDelegate.h"
@interface Articoli : UITableViewController <SQLClientDelegate,UISearchBarDelegate>

@property (nonatomic) NSArray *tablesource;

@property (nonatomic,strong) UIActivityIndicatorView *spinner;
-(void)EstrapolaDati:(NSString*) SQLstring;
-(void)loadData;
@end
