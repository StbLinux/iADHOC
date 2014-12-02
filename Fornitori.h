//
//  Fornitori.h
//  iADHOC
//
//  Created by Mirko Totera on 06/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLClient.h"
#import "AppDelegate.h"
@interface Fornitori : UITableViewController <SQLClientDelegate,UISearchBarDelegate,UIActionSheetDelegate>

@property (nonatomic) NSArray *tablesource;

@property (strong, nonatomic) IBOutlet UISearchBar *SearchBar;
@property (nonatomic,strong) UIActivityIndicatorView *spinner;
-(void)EstrapolaDati:(NSString*) SQLstring;;


@end
