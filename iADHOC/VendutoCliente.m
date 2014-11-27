//
//  VendutoCliente.m
//  iADHOC
//
//  Created by Mirko Totera on 25/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import "VendutoCliente.h"
#import "SQLClient.h"
#import "DBmanager.h"
#import "VENDUTO.h"
@interface VendutoCliente ()
- (IBAction)Indietro:(id)sender;

@end

@implementation VendutoCliente -(void)viewDidAppear:(BOOL)animated{
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *label=@"GLOBALE";
    NSString *SQLState=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"select DOC_MAST.MVCODCON,SUM(DOC_DETT.MVVALRIG) as IMPONIBILE from ( dbo.",mainDelegate.AziendaId,@"DOC_MAST DOC_MAST Left outer Join ",mainDelegate.AziendaId,@"DOC_DETT DOC_DETT on DOC_MAST.MVSERIAL=DOC_DETT.MVSERIAL) where (DOC_MAST.MVFLVEAC='V' and DOC_MAST.MVCLADOC='FA' AND DOC_MAST.MVCODCON='",_pCodiceCliente,@"') group by DOC_MAST.MVCODCON"];
    // NSLog(@"%@",SQLState);
    [self EstrapolaDati:SQLState LABEL:label];
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

-(void)EstrapolaDati:(NSString*)SQLstring LABEL:(NSString *)label {
    SQLClient* client = [SQLClient sharedInstance];
    client.delegate = self;
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    [client connect:[NSString stringWithFormat:@"%@%@%@",mainDelegate.ServerId,@":",mainDelegate.PortaId] username:[NSString stringWithFormat:@"%@",mainDelegate.UtenteId]  password:[NSString stringWithFormat:@"%@",mainDelegate.PasswordId]  database:[NSString stringWithFormat:@"%@",mainDelegate.DBId]   completion:^(BOOL success) {
        if (success)
        {
            [client execute:SQLstring completion:^(NSArray* results) {
                [self PopolaTabella:results LABEL:label];
                [client disconnect];
            }];
        }
        
    }];
    
    
}
-(void)PopolaTabella:(NSArray*)data LABEL:(NSString*)label{
 _venduto=[[VENDUTO alloc]init];
    for (NSArray* table in data)
        for (NSDictionary* row in table){
            
            for (NSString* column in row){
                
               
                
                if ([column isEqual:@"IMPONIBILE"]) {
                                       self.venduto.IMPONIBILE=row[column];
                   // NSLog(@"%@%@",@"venduto entro:",self.venduto.IMPONIBILE);
                   

                }
                            }
            
            
            if ([label isEqualToString:@"GLOBALE"] ) {
                _Imponibile.text=self.venduto.IMPONIBILE;
            }
            
            
            
        }
    
       NSLog(@"%@%@",@"venbduto:",_venduto.IMPONIBILE);
    

    
}


#pragma mark - SQLClientDelegate

//Required
- (void)error:(NSString*)error code:(int)code severity:(int)severity
{
    NSLog(@"Error #%d: %@ (Severity %d)", code, error, severity);
    [[[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

- (IBAction)Indietro:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
