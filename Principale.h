//
//  Principale.h
//  iADHOC
//
//  Created by Mirko Totera on 27/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLClient.h"
#import"AppDelegate.h"
@interface Principale : UIViewController <UIActionSheetDelegate,SQLClientDelegate>
@property (strong, nonatomic) IBOutlet UILabel *attendere;

@property (nonatomic,strong) UIActivityIndicatorView *spinner;
@property (nonatomic) NSArray *tablesource;
@property (strong, nonatomic) IBOutlet UISwitch *OnOffline;

@end
