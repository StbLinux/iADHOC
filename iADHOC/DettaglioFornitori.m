//
//  DettaglioFornitori.m
//  iADHOC
//
//  Created by Mirko Totera on 06/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import "DettaglioFornitori.h"
#import "SQLClient.h"
@interface DettaglioFornitori ()
- (IBAction)Torna:(id)sender;

@end

@implementation DettaglioFornitori
- (void)viewDidLoad {
    [super viewDidLoad];
       _ANCODICE.text=_pCodiceFornitore;
       _ANRAGSOC.text=_pRagsoc;
    NSLog(@" %@",_pCodiceFornitore);
    NSString *SQLState=[NSString stringWithFormat:@"%@%@%@",@"SELECT ANCODPAG FROM dbo.S2010CONTI where ANTIPCON='F' and ANCODICE='",_pCodiceFornitore,@"'"];
    
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
    
    ClientiElenco=[[NSMutableDictionary alloc] init];
    
    //NSMutableString* results = [[NSMutableString alloc] init];
    for (NSArray* table in data)
        for (NSDictionary* row in table){
            for (NSString* column in row){
                _CodPag.text=row[column];
                //NSLog(@"%@",row[column]);
                
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
