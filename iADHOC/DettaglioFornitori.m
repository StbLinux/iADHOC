//
//  DettaglioFornitori.m
//  iADHOC
//
//  Created by Mirko Totera on 06/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import "DettaglioFornitori.h"
#import "SQLClient.h"
#import "ANACLI.h"
@interface DettaglioFornitori ()
- (IBAction)Torna:(id)sender;

@end

@implementation DettaglioFornitori
- (void)viewDidLoad {
    [super viewDidLoad];
       _codice.text=_pCodiceFornitore;
       _ragsoc.text=_pRagsoc;
    NSLog(@" %@",_pCodiceFornitore);
    NSString *SQLState=[NSString stringWithFormat:@"%@%@%@",@"SELECT ANINDIRI,ANLOCALI,AN___CAP,ANPROVIN,ANTELEFO,AN_EMAIL,ANCODPAG FROM dbo.S2010CONTI where ANTIPCON='F' and ANCODICE='",_pCodiceFornitore,@"'"];

    
    NSLog(@" %@",SQLState);
    [self CaricaDettaglioDB:SQLState];
 
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
-(void)CaricaDettaglioDB: (NSString*)SQLstring{
    SQLClient* client = [SQLClient sharedInstance];
    client.delegate = self;
    [client connect:@"81.174.32.50:1433" username:@"sa" password:@"Soft2%milA" database:@"AHR70" completion:^(BOOL success) {
        if (success)
        {
            [client execute:SQLstring completion:^(NSArray* results) {
                [self AssegnaValori:results];
               //NSLog(@" %@",results);
                [client disconnect];
            }];
        }
        
    }];
 
    
}
-(void) AssegnaValori:(NSArray *)data{
    
    
    for (NSArray* table in data)
        for (NSDictionary* row in table){
            ANACLI *ANAGRAFICA=[[ANACLI alloc]init];
            
            for (NSString* column in row){
                if ([column isEqual:@"ANINDIRI"]) {
                    ANAGRAFICA.indirizzo=row[column];
                    
                }
                if ([column isEqual:@"AN___CAP"]) {
                    ANAGRAFICA.cap=row[column];
                    
                }
                if ([column isEqual:@"ANLOCALI"]) {
                    ANAGRAFICA.paese=row[column];
                    
                }
                if ([column isEqual:@"ANPROVIN"]) {
                    ANAGRAFICA.provincia=row[column];
                    
                }
                if ([column isEqual:@"ANTELEFO"]) {
                    ANAGRAFICA.telefono=row[column];
                }
                if ([column isEqual:@"AN_EMAIL"]) {
                    ANAGRAFICA.email=row[column];
                }
                
                //NSLog(@"%@",row[column]);
                _indirizzo.text=ANAGRAFICA.indirizzo;
                _cap.text=ANAGRAFICA.cap;
                _paese.text=ANAGRAFICA.paese;
                _provincia.text=ANAGRAFICA.provincia;
                _telefono.text=ANAGRAFICA.telefono;
                _email.text=ANAGRAFICA.email;
                
            }
            
        }
    


}

#pragma mark - SQLClientDelegate

//Required

- (void)error:(NSString*)error code:(int)code severity:(int)severity
{
    NSLog(@"Error #%d: %@ (Severity %d)", code, error, severity);
    [[[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

//Optional
- (void)message:(NSString*)message
{
    NSLog(@"Message: %@", message);
}

@end
