//
//  Fornitori.m
//  iADHOC
//
//  Created by Mirko Totera on 06/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import "Fornitori.h"
#import "SQLClient.h"
#import "ZoomFor.h"
#import "ANACLI.h"
#import "DettaglioFornitori.h"

@interface Fornitori ()

@end

@implementation Fornitori{
    ANACLI *anacli;
    NSArray *searchResults;
}


- (void)viewDidLoad {
    [super viewDidLoad];
     NSString *SQLState=@"SELECT ANCODICE, ANDESCRI,ANINDIRI,ANLOCALI,AN___CAP,ANPROVIN,ANTELEFO,AN_EMAIL,ANCODPAG FROM dbo.S2010CONTI where ANTIPCON='C' order by ANDESCRI";
    [self EstrapolaDati:SQLState];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [tablesource count];

}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *ZoomFornitori=@"ZoomFornitori";
 ZoomFor *cell =(ZoomFor *)[tableView dequeueReusableCellWithIdentifier:ZoomFornitori forIndexPath:indexPath];
 
 
 /*UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZoomClienti forIndexPath:indexPath];*/

// Configure the cell...
if(cell==nil) {
    cell=[[ZoomFor alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZoomFornitori];
}
     
     ANACLI *clienti = [tablesource objectAtIndex:indexPath.row];
     cell.codice.text=clienti.codice;
     cell.ragsoc.text=clienti.ragsoc;
     cell.indiri.text=clienti.paese;
     
return cell;
}

/*- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"DettaglioFornitori" sender:nil];
}*/
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"DettaglioFornitori" sender:nil];
    
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


// Override to support conditional rearranging of the table view.
/*- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}*/

#pragma mark - Navigation

 //In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ANACLI *cliente_stru=[[ANACLI alloc]init];
    if ([segue.identifier isEqualToString:@"DettaglioFornitori"])
        
    {
        
        DettaglioFornitori *DetFor = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        cliente_stru=[tablesource objectAtIndex:selectedIndexPath.row];

        //NSLog(@"%@",[keyArray objectAtIndex:selectedIndexPath.row]);
        DetFor.pCodiceFornitore=cliente_stru.codice;
        DetFor.pRagsoc=cliente_stru.ragsoc;
        DetFor.pPaese=cliente_stru.paese;
        DetFor.pCap=cliente_stru.cap;
        DetFor.pProvincia=cliente_stru.provincia;
        DetFor.pTelefono=cliente_stru.telefono;
        DetFor.pIndirizzo=cliente_stru.indirizzo;
        DetFor.pEMAIL=cliente_stru.email;
        DetFor.pcodpag=cliente_stru.codpag;

    }
    
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)EstrapolaDati:(NSString*) SQLState;{
    SQLClient* client = [SQLClient sharedInstance];
    client.delegate = self;
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    [client connect:[NSString stringWithFormat:@"%@%@%@",mainDelegate.ServerId,@":",mainDelegate.PortaId] username:[NSString stringWithFormat:@"%@",mainDelegate.UtenteId]  password:[NSString stringWithFormat:@"%@",mainDelegate.PasswordId]  database:[NSString stringWithFormat:@"%@",mainDelegate.DBId]   completion:^(BOOL success) {
        if (success)
        {
            [client execute:SQLState completion:^(NSArray* results) {
                [self PopolaTabella:results];
                [client disconnect];
            }];
        }
        
    }];
    
    
}
-(void)PopolaTabella:(NSArray*)data{
    
    NSMutableArray* tbsource=[[NSMutableArray alloc]init];
    
    for (NSArray* table in data)
        for (NSDictionary* row in table){
            ANACLI *ANAGRAFICA=[[ANACLI alloc]init];
            for (NSString* column in row){
                
                //NSLog(@"%@",row[column]);
                
                if ([column isEqual:@"ANLOCALI"]) {
                    
                    ANAGRAFICA.paese=row[column];
                }
                if ([column isEqual:@"ANDESCRI"]) {
                    
                    ANAGRAFICA.ragsoc=row[column] ;
                }
                if ([column isEqual:@"ANINDIRI"]) {
                    
                    ANAGRAFICA.indirizzo=row[column] ;
                }
                if ([column isEqual:@"ANCODICE"]) {
                    
                    ANAGRAFICA.codice=row[column] ;
                }
                if ([column isEqual:@"ANTELEFO"]) {
                    
                    ANAGRAFICA.telefono=row[column] ;
                }
                if ([column isEqual:@"ANPROVINCIA"]) {
                    
                    ANAGRAFICA.provincia=row[column] ;
                }
                if ([column isEqual:@"AN___CAP"]) {
                    
                    ANAGRAFICA.cap=row[column] ;
                }
                if ([column isEqual:@"AN_EMAIL"]) {
                    
                    ANAGRAFICA.email=row[column] ;
                }
                if ([column isEqual:@"ANCODPAG"]) {
                    
                    ANAGRAFICA.codpag=row[column] ;
                }
            }
            
            
            
            
            // NSLog(@"%@",ANAGRAFICA.codice );
            [tbsource   addObject:ANAGRAFICA];
            
        }
    
    
    tablesource=tbsource;
    
    
    
    [self.tableView reloadData];

    
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
