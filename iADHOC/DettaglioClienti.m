//
//  DettaglioClienti.m
//  iADHOC
//
//  Created by Mirko Totera on 07/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import "DettaglioClienti.h"
#import "ANACLI.h"
@interface DettaglioClienti ()
- (IBAction)Indietro:(id)sender;
@property (strong, nonatomic) IBOutlet UINavigationBar *Navigazione;

@end

@implementation DettaglioClienti

- (void)viewDidLoad {
    [super viewDidLoad];
    _CodiceCliente.text=_pCodiceCliente;
    _RagioneSociale.text=_pRagsoc;
       NSString *SQLState=[NSString stringWithFormat:@"%@%@%@",@"SELECT ANINDIRI,ANLOCALI,AN___CAP,ANPROVIN,ANTELEFO,AN_EMAIL,ANCODPAG FROM dbo.S2010CONTI where ANTIPCON='C' and ANCODICE='",_pCodiceCliente,@"'"];
    
    NSLog(@" %@",SQLState);
    [self CaricaDettaglioDB:SQLState];
     _Navigazione.topItem.title=@"Dettaglio";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)CaricaDettaglioDB: (NSString*)SQLstring{
    SQLClient* client = [SQLClient sharedInstance];
    client.delegate = self;
    [client connect:@"81.174.32.50:1433" username:@"sa" password:@"Soft2%milA" database:@"AHR70" completion:^(BOOL success) {
        if (success)
        {
            [client execute:SQLstring completion:^(NSArray* results) {
                [self AssegnaValori:results];
               // NSLog(@" %@",results);
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
                _Indirizzo.text=ANAGRAFICA.indirizzo;
                _Cap.text=ANAGRAFICA.cap;
                _Paese.text=ANAGRAFICA.paese;
                _Provincia.text=ANAGRAFICA.provincia;
                _Telefono.text=ANAGRAFICA.telefono;
                _EMAIL.text=ANAGRAFICA.email;
               
            }
            
        }
    

    
}


#pragma mark - Navigation
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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


- (IBAction)Indietro:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
@end
