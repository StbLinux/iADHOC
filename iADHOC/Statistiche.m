//
//  Statistiche.m
//  iADHOC
//
//  Created by Mirko Totera on 03/12/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import "Statistiche.h"

@interface Statistiche ()

@end

@implementation Statistiche

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)Indietro:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
