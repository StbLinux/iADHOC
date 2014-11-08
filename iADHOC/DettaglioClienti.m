//
//  DettaglioClienti.m
//  iADHOC
//
//  Created by Mirko Totera on 07/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import "DettaglioClienti.h"

@interface DettaglioClienti ()
- (IBAction)Indietro:(id)sender;
@property (strong, nonatomic) IBOutlet UINavigationBar *Navigazione;

@end

@implementation DettaglioClienti

- (void)viewDidLoad {
    [super viewDidLoad];
    _CodiceCliente.text=_pCodiceCliente;
    _RagioneSociale.text=_pRagsoc;
    _Indirizzo.text=_pIndirizzo;
    _Cap.text=_pCap;
    _Paese.text=_pPaese;
    _EMAIL.text=_pEMAIL;
    _Provincia.text=_pProvincia;
    _Telefono.text=_pTelefono;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)Indietro:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
