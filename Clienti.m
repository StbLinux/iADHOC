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
#import "DBmanager.h"
#import "DettaglioClienti.h"

@interface Clienti ()<UISearchDisplayDelegate,UISearchControllerDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *CercaBar;
@property (strong,nonatomic) DBmanager *dbManager;
@end

@implementation Clienti{
    ANACLI *anacli;
    
    
    
   }

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize the dbManager object.
        AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (mainDelegate.OnlineId.boolValue==1) {
        NSString *SQLState=[NSString stringWithFormat:@"%@%@%@%@",@"SELECT ANCODICE, ANDESCRI,ANINDIRI,ANLOCALI,AN___CAP,ANPROVIN,ANTELEFO,AN_EMAIL,ANCODPAG FROM dbo.",mainDelegate.AziendaId,@"CONTI ",@"where ANTIPCON='C' order by ANDESCRI"];
        [self EstrapolaDati:SQLState];

    }
    else {
        self.dbManager = [[DBmanager alloc] initWithDatabaseFilename:@"AHR.sqlite"];
        [self loadData];
    }
        
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.searchResults = [NSMutableArray arrayWithCapacity:[self.tablesource count]];
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
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.searchResults count];
    }
    else
    {
        return [self.tablesource count];
    }
    // Return the number of rows in the section.
   // return [elements count];
    //return [tablesource count];
    //return 4;
}
/*
 
 
 
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    static NSString *ZoomClienti=@"ZoomClienti";
    ZoomCli *cell =(ZoomCli *)[tableView dequeueReusableCellWithIdentifier:ZoomClienti forIndexPath:indexPath];

    if(cell==nil) {;
        cell=[[ZoomCli alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZoomClienti];
    }
    if (mainDelegate.OnlineId.boolValue==1) {
        ANACLI *clienti = [self.tablesource objectAtIndex:indexPath.row];
        cell.codice.text=clienti.codice;
        cell.ragsoc.text=clienti.ragsoc;
        cell.indiri.text=clienti.paese;
    } else {
        
        NSInteger indexOfcodice = [self.dbManager.arrColumnNames indexOfObject:@"ANCODICE"];
        NSLog(@"@%ld",(long)indexOfcodice);
        NSInteger indexOfragsoc = [self.dbManager.arrColumnNames indexOfObject:@"ANDESCRI"];
        NSInteger indexOfpaese = [self.dbManager.arrColumnNames indexOfObject:@"ANLOCALI"];
        
        // Set the loaded data to the appropriate cell labels.
        
        
        cell.codice.text = [NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:indexPath.row] objectAtIndex:indexOfcodice]];
        cell.ragsoc.text = [NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:indexPath.row] objectAtIndex:indexOfragsoc]];
        cell.indiri.text = [NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:indexPath.row] objectAtIndex:indexOfpaese]];
    }
    



    
    
    
    
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
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        if ([segue.identifier isEqualToString:@"DettaglioClienti"])
        
    {
        DettaglioClienti *DetCli = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];

        if (mainDelegate.OnlineId.boolValue==1) {
                        ANACLI *cliente_stru=[[ANACLI alloc]init];
            cliente_stru=[self.tablesource objectAtIndex:selectedIndexPath.row];
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
        } else {
           // NSLog(@"%@",self.tablesource);
            NSInteger indexOfcodice =1;
            NSInteger indexOfragsoc =2;
            NSInteger indexOfindiri =3;
            NSInteger indexOfcap = 4;
            NSInteger indexOfpaese =5;
            NSInteger indexOfprovincia =6;
            NSInteger indexOftelefono =8;
            NSInteger indexOfemail =10;
           //   NSInteger indexOfpagamento =
             DetCli.pCodiceCliente=[NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:selectedIndexPath.row] objectAtIndex:indexOfcodice]];
           DetCli.pRagsoc=[NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:selectedIndexPath.row] objectAtIndex:indexOfragsoc]];
              DetCli.pIndirizzo=[NSString stringWithFormat:@"%@",[[self.tablesource objectAtIndex:selectedIndexPath.row] objectAtIndex:indexOfcodice]];
         //   NSLog(@"%@",[NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:selectedIndexPath.row] objectAtIndex:indexOfpaese]]);
            DetCli.pPaese=[NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:selectedIndexPath.row] objectAtIndex:indexOfpaese]];
            DetCli.pCap=[NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:selectedIndexPath.row] objectAtIndex:indexOfcap]];
          
           DetCli.pProvincia=[NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:selectedIndexPath.row] objectAtIndex:indexOfprovincia]];
           DetCli.pTelefono=[NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:selectedIndexPath.row] objectAtIndex:indexOftelefono]];
         //   NSLog(@"%@",[self.tablesource objectAtIndex:selectedIndexPath.row]);
           
                        NSLog(@"%@",self.dbManager.arrResults);
            DetCli.pIndirizzo=[NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:selectedIndexPath.row] objectAtIndex:indexOfindiri]];
            DetCli.pEMAIL=[NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:selectedIndexPath.row] objectAtIndex:indexOfemail]];
           // DetCli.pcodpag=[NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:selectedIndexPath.row] objectAtIndex:indexOfpagamento]];

        }
        

        
      
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
}

/*-(void)EstrapolaDati:(NSString*)SQLstring{
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
 
    
}*/
-(void)EstrapolaDati:(NSString*)SQLstring{
    SQLClient* client = [SQLClient sharedInstance];
    client.delegate = self;
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
   
  
    [client connect:[NSString stringWithFormat:@"%@%@%@",mainDelegate.ServerId,@":",mainDelegate.PortaId] username:[NSString stringWithFormat:@"%@",mainDelegate.UtenteId]  password:[NSString stringWithFormat:@"%@",mainDelegate.PasswordId]  database:[NSString stringWithFormat:@"%@",mainDelegate.DBId]   completion:^(BOOL success) {
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
    
            
    self.tablesource=tbsource;
    
    
  
    [self.tableView reloadData];
    
}
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.searchResults removeAllObjects];
    NSLog(@"%@",searchText);
    NSPredicate *resultPredicate = [NSPredicate
            predicateWithFormat:@"codice == %@", searchText];
    
    self.searchResults = [NSMutableArray arrayWithArray: [self.tablesource filteredArrayUsingPredicate:resultPredicate]];
    NSLog(@"%@",self.searchResults);
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
-(void)loadData{
    // Form the query.
    NSString *query = @"select * from CONTI";
    
    // Get the results.
    if (self.tablesource != nil) {
        self.tablesource = nil;
    }
    self.tablesource = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tableView reloadData];
}

@end
