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
       NSString *SQLState=[NSString stringWithFormat:@"%@%@%@",@"SELECT ANINDIRI,ANLOCALI,AN___CAP,ANPROVIN,ANTELEFO,AN_EMAIL FROM dbo.S2010CONTI where ANTIPCON='C' and ANCODICE='",_pCodiceCliente,@"'"];
    
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
    
    ClientiElenco=[[NSMutableDictionary alloc] init];
    
    //NSMutableString* results = [[NSMutableString alloc] init];
    for (NSArray* table in data)
        for (NSDictionary* row in table){
            for (NSString* column in row){
                if ([column isEqual:@"ANINDIRI"]) {
                    _Indirizzo.text=[row[column]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

                }
                if ([column isEqual:@"AN___CAP"]) {
                    _Cap.text=row[column];
                    
                }
                if ([column isEqual:@"ANLOCALI"]) {
                    _Paese.text=[row[column] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    
                }
                if ([column isEqual:@"ANPROVIN"]) {
                    _Provincia.text=[NSString stringWithFormat:@"%@%@%@",@"(",row[column],@")"];
                    
                }
                if ([column isEqual:@"ANTELEFO"]) {
                    _Telefono.text=[NSString stringWithFormat:@"%@%@",@"Telefono: ",row[column]];
                    
                }
                if ([column isEqual:@"AN_EMAIL"]) {
                    _EMAIL.text=[NSString stringWithFormat:@"%@%@",@"Email :",row[column]];
                    
                }

                               //NSLog(@"%@",row[column]);
                
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
