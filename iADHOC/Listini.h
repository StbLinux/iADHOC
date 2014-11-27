//
//  Listini.h
//  iADHOC
//
//  Created by Mirko Totera on 24/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLClient.h"
#import"AppDelegate.h"

@interface Listini : UITableViewController <SQLClientDelegate,UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UINavigationItem *titolo;

@property (nonatomic) NSArray *tablesource;

@property (retain,nonatomic) NSString *pCodiceArticolo;
@property (nonatomic,strong) UIActivityIndicatorView *spinner;
-(void)EstrapolaDati:(NSString*) SQLstring;
-(void)loadData;

@end
