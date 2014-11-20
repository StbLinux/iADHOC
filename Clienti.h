//
//  Clienti.h
//  iADHOC
//
//  Created by Mirko Totera on 05/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLClient.h"
#import"AppDelegate.h"
@interface Clienti : UITableViewController <SQLClientDelegate,UISearchBarDelegate>

@property (nonatomic) NSArray *tablesource;

// NSArray *elements;
@property (strong, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (nonatomic,strong) UIActivityIndicatorView *spinner;

-(void)EstrapolaDati:(NSString*) SQLstring;
-(void)loadData;
@end
