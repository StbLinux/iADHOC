//
//  Clienti.m
//  iADHOC
//
//  Created by Mirko Totera on 05/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import "Clienti.h"
#import "SQLClient.h"
#import "ZoomCli.h"
#import "ANACLI.h"
#import "DettaglioClienti.h"

@interface Clienti ()
@property (strong, nonatomic) IBOutlet UISearchBar *CercaBar;

@end

@implementation Clienti{
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
    //return 0;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
   // return [elements count];
    return [tablesource count];
    //return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ZoomClienti=@"ZoomClienti";
    ZoomCli *cell =(ZoomCli *)[tableView dequeueReusableCellWithIdentifier:ZoomClienti forIndexPath:indexPath];


    /*UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZoomClienti forIndexPath:indexPath];*/
    
    // Configure the cell...
    if(cell==nil) {;
        cell=[[ZoomCli alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZoomClienti];
    }
    //[cell.codice setText:[keyArray objectAtIndex:indexPath.row]];
  //  NSLog(@"%@",[keyArray objectAtIndex:indexPath.row]);
    //[cell.textLabel setText:@"pippo"];
    //ragione=[valueArray objectAtIndex:indexPath.row];
   //[cell.ragsoc setText:[ragione substringToIndex:[ragione rangeOfString:@"-"].location-1]];
    ANACLI *clienti = [tablesource objectAtIndex:indexPath.row];
    cell.codice.text=clienti.codice;
    cell.ragsoc.text=clienti.ragsoc;
    cell.indiri.text=clienti.paese;
   // [cell.indiri setText:[ragione substringFromIndex:[ragione rangeOfString:@"-"].location+2]];
   // [cell.ragsoc setText:[valueArray ob]];
    //cell.textLabel.text = [elements objectAtIndex:indexPath.row];
       return cell;
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

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"DettaglioClienti" sender:nil];
    
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ANACLI *cliente_stru=[[ANACLI alloc]init];
    if ([segue.identifier isEqualToString:@"DettaglioClienti"])
        
    {
        
        DettaglioClienti *DetCli = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        cliente_stru=[tablesource objectAtIndex:selectedIndexPath.row];
        //NSLog(@"%@",[keyArray objectAtIndex:selectedIndexPath.row]);
        DetCli.pCodiceCliente=cliente_stru.codice;
        DetCli.pRagsoc=cliente_stru.ragsoc;
        DetCli.pPaese=cliente_stru.paese;
        DetCli.pCap=cliente_stru.cap;
        DetCli.pProvincia=cliente_stru.provincia;
        DetCli.pTelefono=cliente_stru.telefono;
        DetCli.pIndirizzo=cliente_stru.indirizzo;
        DetCli.pEMAIL=cliente_stru.email;
        DetCli.pcodpag=cliente_stru.codpag;
    }
    

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)EstrapolaDati:(NSString*)SQLstring{
    SQLClient* client = [SQLClient sharedInstance];
    client.delegate = self;
    [client connect:@"81.174.32.50:1433" username:@"sa" password:@"Soft2%milA" database:@"AHR70" completion:^(BOOL success) {
        if (success)
        {
            [client execute:SQLstring completion:^(NSArray* results) {
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
/*- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    searchResults = [recipes filteredArrayUsingPredicate:resultPredicate];
}*/
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
