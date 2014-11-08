//
//  DettaglioFornitori.m
//  iADHOC
//
//  Created by Mirko Totera on 06/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import "DettaglioFornitori.h"
@interface DettaglioFornitori ()
- (IBAction)Torna:(id)sender;

@end

@implementation DettaglioFornitori
- (void)viewDidLoad {
    [super viewDidLoad];
       _codice.text=_pCodiceFornitore;
       _ragsoc.text=_pRagsoc;
    _indirizzo.text=_pIndirizzo;
    _cap.text=_pCap;
    _paese.text=_pPaese;
    _email.text=_pEMAIL;
    _provincia.text=_pProvincia;
    _telefono.text=_pTelefono;

   
 
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

- (IBAction)Torna:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
