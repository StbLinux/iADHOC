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
@interface Clienti : UITableViewController <SQLClientDelegate>

@property (nonatomic,strong) NSArray *tablesource;
   // NSArray *elements;
@property (nonatomic,strong)   NSMutableArray *searchResults;
   
-(void)EstrapolaDati:(NSString*) SQLstring;
-(void)loadData;
@end
