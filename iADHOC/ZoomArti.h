//
//  ZoomArti.h
//  iADHOC
//
//  Created by Mirko Totera on 21/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomArti : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *codice;
@property (strong, nonatomic) IBOutlet UILabel *descrizione;
@property (strong, nonatomic) IBOutlet UILabel *supplementare;
@property (strong, nonatomic) IBOutlet UILabel *unimis;

@property (strong, nonatomic) IBOutlet UILabel *armoltip;

@end
