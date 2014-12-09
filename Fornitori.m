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
#import "DBmanager.h"
#import "DettaglioFornitori.h"

@interface Fornitori ()
@property (strong,nonatomic) DBmanager *dbManager;
@end

@implementation Fornitori{
    ANACLI *anacli;
    //NSArray *searchResults;
   BOOL finecaricamento;
    
    IBOutlet UINavigationItem *navitem;

}
-(void)viewDidAppear:(BOOL)animated{
    
    _SearchBar.delegate = self;
     navitem.titleView=_SearchBar;
     self.edgesForExtendedLayout = UIRectEdgeNone;
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
       
        if ([_tablesource count]==0) {
            if (mainDelegate.OnlineId.boolValue==1) {
                NSString *SQLState=@"SELECT ANCODICE, ANDESCRI,ANINDIRI,ANLOCALI,AN___CAP,ANPROVIN,ANTELEFO,AN_EMAIL,ANCODPAG FROM dbo.S2010CONTI where ANTIPCON='F' order by ANDESCRI";
                [self EstrapolaDati:SQLState];
                
            }
            else {
                
                self.dbManager = [[DBmanager alloc] initWithDatabaseFilename:@"AHR.sqlite"];
                NSString *query = @"select ANTIPCON,ANCODICE,ANDESCRI,ANDESCR2,ANINDIRI,ANINDIRI2,AN___CAP,ANLOCALI,ANPROVIN,ANNAZION,ANTELEFO,ANTELFAX,ANNUMCEL,ANCODFIS,ANPARIVA,ANCATCON,ANCODPAG,AN__NOTE,ANINDWEB,AN_EMAIL from CONTI where ANTIPCON='F'";
                
                // Get the results.
                
                self.tablesource = nil;
                
                self.tablesource = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
                
                if ([self.tablesource count]==0) {
                    
                    NSLog(@"%@",@"nessun record visualizzabile");
                }
                else {
                    [self.tableView reloadData];
                    finecaricamento=true;
                }

            }
            
            
            // Uncomment the following line to preserve selection between presentations.
            // self.clearsSelectionOnViewWillAppear = NO;
            
            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
            // self.navigationItem.rightBarButtonItem = self.editButtonItem;
            
            
        }
        
        NSLog(@"%i",finecaricamento);

   
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
  }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [_tablesource count];

}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
 static NSString *ZoomFornitori=@"ZoomFornitori";
 ZoomFor *cell =(ZoomFor *)[tableView dequeueReusableCellWithIdentifier:ZoomFornitori forIndexPath:indexPath];
 
 
 /*UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZoomClienti forIndexPath:indexPath];*/

// Configure the cell...
if(cell==nil) {
    cell=[[ZoomFor alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZoomFornitori];
}
     if (mainDelegate.OnlineId.boolValue==1) {
         ANACLI *clienti= [self.tablesource objectAtIndex:indexPath.row];
         
         cell.codice.text=clienti.codice;
         cell.ragsoc.text=clienti.ragsoc;
         cell.indiri.text=clienti.paese;
     } else {
         
         
         NSInteger indexOfcodice = [self.dbManager.arrColumnNames indexOfObject:@"ANCODICE"];
         NSLog(@"@%ld",(long)indexOfcodice);
         NSInteger indexOfragsoc = 2;
         NSInteger indexOfpaese = 4;
         
         // Set the loaded data to the appropriate cell labels.
         cell.codice.text = [NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:indexPath.row] objectAtIndex:indexOfcodice]];
         NSLog(@"%@",[[self.tablesource objectAtIndex:indexPath.row] objectAtIndex:3]);
         cell.ragsoc.text = [NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:indexPath.row] objectAtIndex:indexOfragsoc]];
         cell.indiri.text = [NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:indexPath.row] objectAtIndex:indexOfpaese]];
         
         
         
         
         
         
         
     }
     
     
     

     
return cell;
}

/*- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"DettaglioFornitori" sender:nil];
}*/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"DettaglioFornitori" sender:nil];
    
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
   
    
    
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
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    ANACLI *cliente_stru=[[ANACLI alloc]init];
    if ([segue.identifier isEqualToString:@"DettaglioFornitori"])
        
    {
        
        DettaglioFornitori *DetFor = [segue destinationViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        if (mainDelegate.OnlineId.boolValue==1) {
        cliente_stru=[_tablesource objectAtIndex:selectedIndexPath.row];

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
        else {
            // NSLog(@"%@",self.tablesource);
            NSInteger indexOfcodice =1;
            NSInteger indexOfragsoc =2;
            NSInteger indexOfindiri =4;
            NSInteger indexOfcap = 6;
            NSInteger indexOfpaese =7;
            NSInteger indexOfprovincia =8;
            NSInteger indexOftelefono =10;
            NSInteger indexOfemail =19;
            DetFor.pCodiceFornitore=[NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:selectedIndexPath.row] objectAtIndex:indexOfcodice]];
            DetFor.pRagsoc=[NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:selectedIndexPath.row] objectAtIndex:indexOfragsoc]];
            DetFor.pIndirizzo=[NSString stringWithFormat:@"%@",[[self.tablesource objectAtIndex:selectedIndexPath.row] objectAtIndex:indexOfcodice]];
            //   NSLog(@"%@",[NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:selectedIndexPath.row] objectAtIndex:indexOfpaese]]);
            DetFor.pPaese=[NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:selectedIndexPath.row] objectAtIndex:indexOfpaese]];
            DetFor.pCap=[NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:selectedIndexPath.row] objectAtIndex:indexOfcap]];
            
            DetFor.pProvincia=[NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:selectedIndexPath.row] objectAtIndex:indexOfprovincia]];
            DetFor.pTelefono=[NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:selectedIndexPath.row] objectAtIndex:indexOftelefono]];
            //   NSLog(@"%@",[self.tablesource objectAtIndex:selectedIndexPath.row]);
            
           // NSLog(@"%@",self.dbManager.arrResults);
            DetFor.pIndirizzo=[NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:selectedIndexPath.row] objectAtIndex:indexOfindiri]];
            DetFor.pEMAIL=[NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:selectedIndexPath.row] objectAtIndex:indexOfemail]];
            
        }
    }
    
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)EstrapolaDati:(NSString*) SQLState;{
    SQLClient* client = [SQLClient sharedInstance];
    client.delegate = self;
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    finecaricamento=false;
    
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
/*- (BOOL)prefersStatusBarHidden
{
    return YES;
}*/

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
   

    finecaricamento=true;
    
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
    
  //  NSLog(@"%@",@"sono qui");
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSString *SQLState=[NSString stringWithFormat:@"%@%@%@%@",@"SELECT ANTIPCON,ANCODICE, ANDESCRI,ANDESCR2,ANINDIRI,ANINDIR2,AN___CAP,ANLOCALI,ANPROVIN,ANNAZION,ANTELEFO,ANTELFAX,ANNUMCEL,ANCODFIS,ANPARIVA,ANCATCON,ANCODPAG,AN__NOTE,ANINDWEB,AN_EMAIL FROM dbo.",mainDelegate.AziendaId,@"CONTI ",@"where ANTIPCON='F' order by ANDESCRI"];
    [self EstrapolaDati:SQLState];
    
    
    
    
    [self.tableView reloadData];
    finecaricamento=true;
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self cerca:searchBar];
}
/*- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self cerca:searchBar];
}*/
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (mainDelegate.OnlineId.boolValue==1) {
        if (finecaricamento==true) {
            finecaricamento=false;
            NSString *SQLState=[NSString stringWithFormat:@"%@%@%@%@",@"SELECT ANTIPCON,ANCODICE, ANDESCRI,ANDESCR2,ANINDIRI,ANINDIR2,AN___CAP,ANLOCALI,ANPROVIN,ANNAZION,ANTELEFO,ANTELFAX,ANNUMCEL,ANCODFIS,ANPARIVA,ANCATCON,ANCODPAG,AN__NOTE,ANINDWEB,AN_EMAIL FROM dbo.",mainDelegate.AziendaId,@"CONTI ",@"where ANTIPCON='F' order by ANDESCRI"];
            // NSLog(@"%@",SQLState);
            [self EstrapolaDati:SQLState];
            
            

        }
        
        
    }
    else {
        if (finecaricamento==true) {
            finecaricamento=false;
            NSString *query = @"select ANTIPCON,ANCODICE,ANDESCRI,ANDESCR2,ANINDIRI,ANINDIRI2,AN___CAP,ANLOCALI,ANPROVIN,ANNAZION,ANTELEFO,ANTELFAX,ANNUMCEL,ANCODFIS,ANPARIVA,ANCATCON,ANCODPAG,AN__NOTE,ANINDWEB,AN_EMAIL from CONTI where ANTIPCON='F'";
            
            // Get the results.
            
            self.tablesource = nil;
            
            self.tablesource = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
            
            
        }
        
        [self.tableView reloadData];
        
        finecaricamento=true;

        }
        [searchBar resignFirstResponder];
}

-(void)cerca:(UISearchBar *)searchBar {
    if (finecaricamento==true) {
        AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        if (mainDelegate.OnlineId.boolValue==1) {
            finecaricamento=false;
            NSString *SQLState=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"SELECT ANTIPCON,ANCODICE, ANDESCRI,ANDESCR2,ANINDIRI,ANINDIR2,AN___CAP,ANLOCALI,ANPROVIN,ANNAZION,ANTELEFO,ANTELFAX,ANNUMCEL,ANCODFIS,ANPARIVA,ANCATCON,ANCODPAG,AN__NOTE,ANINDWEB,AN_EMAIL FROM dbo.",mainDelegate.AziendaId,@"CONTI ",@"where ANTIPCON='F' and ANDESCRI LIKE '%",searchBar.text,@"%' ",@"order by ANDESCRI"];
            // NSLog(@"%@",SQLState);
            [self EstrapolaDati:SQLState];
                        
        }
        else {
            finecaricamento=false;
            NSString *query =[NSString stringWithFormat:@"%@%@%@",@"select ANTIPCON,ANCODICE,ANDESCRI,ANDESCR2,ANINDIRI,ANINDIRI2,AN___CAP,ANLOCALI,ANPROVIN,ANNAZION,ANTELEFO,ANTELFAX,ANNUMCEL,ANCODFIS,ANPARIVA,ANCATCON,ANCODPAG,AN__NOTE,ANINDWEB,AN_EMAIL from CONTI where ANTIPCON='F' and ANDESCRI LIKE '%",searchBar.text,@"%'"];
            
            // Get the results.
            
            self.tablesource = nil;
            
            self.tablesource = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        }
       
        [self.tableView reloadData];
         finecaricamento=true;
        
    }
     [searchBar resignFirstResponder];
}
- (IBAction)Indietro:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)sincronizza:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sincronizzazioni"
                                                             delegate:self
                                                    cancelButtonTitle:@"Annulla"
                                               destructiveButtonTitle:@"Completa"
                                                    otherButtonTitles:@"Aggiornamenti",nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // In this case the device is an iPad.
        [actionSheet showFromRect:[(UIButton *)sender frame] inView:self.view animated:YES];
    }
    else{
        // In this case the device is an iPhone/iPod Touch.
        [actionSheet showInView:self.view];
    }
    
    actionSheet.tag = 100;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        
        //   NSLog(@"Index = %ld - Title = %@", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
        if (buttonIndex==0) {
            NSLog(@"%@",@"Sono in sincronizza");
            [self Cancella_archivio:@"CONTI" condizione:@"ANTIPCON='F'"];
            _tablesource=nil;
            [self.tableView reloadData];
            
            //   _attendere.hidden=false;
            
            
            _spinner = [[UIActivityIndicatorView alloc]
                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            _spinner.center = CGPointMake(160, 240);
            _spinner.hidesWhenStopped = YES;
            
            
            [self.view addSubview:_spinner];
            
            [_spinner startAnimating];
            
            NSString *SQLState;
            AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
            
            //CLIENTI
            
            
            SQLState=[NSString stringWithFormat:@"%@%@%@%@",@"SELECT ANTIPCON,ANCODICE, ANDESCRI,ANDESCR2,ANINDIRI,ANINDIR2,AN___CAP,ANLOCALI,ANPROVIN,ANNAZION,ANTELEFO,ANTELFAX,ANNUMCEL,ANCODFIS,ANPARIVA,ANCATCON,ANCODPAG,AN__NOTE,ANINDWEB,AN_EMAIL FROM dbo.",mainDelegate.AziendaId,@"CONTI ",@"where ANTIPCON='F' order by ANDESCRI"];
            
            [self SincroDati:SQLState];
            
        }
        
    }
}
- (void)Cancella_archivio:(NSString*)archivio condizione:(NSString*)condizione{
    self.dbManager = [[DBmanager alloc] initWithDatabaseFilename:@"AHR.sqlite"];
    NSString *query =[NSString stringWithFormat:@"%@%@%@%@", @"DELETE from ",archivio,@" where ",condizione ];
    [self.dbManager executeQuery:query];
    
}

-(void) salvalocalesqlite:(NSString*)archivio{
    self.dbManager = [[DBmanager alloc] initWithDatabaseFilename:@"AHR.sqlite"];
    NSInteger nrecord=[_tablesource count];
    //NSLog(@"%li%@",_tablesource.count,@"nrecord");
    // NSLog(@"%@",_tablesource);
    NSInteger i=0;
    NSString *tipoconto;
    NSString *query;
    NSLog(@"%li",(long)nrecord);
    while (i<nrecord) {
        //Clienti o fornitori
        
        
        ANACLI *tabella;
        
        tabella=[[ANACLI alloc]init];
        
        tipoconto=@"F";
        
        
        
        tabella=[_tablesource objectAtIndex:i];
        NSString *locali=tabella.paese;
        locali=[locali stringByReplacingOccurrencesOfString:@"'" withString:@" "];
        NSString *ragionesociale=tabella.ragsoc;
        ragionesociale = [ragionesociale stringByReplacingOccurrencesOfString:@"'"
                                                                   withString:@" "];
        query = [NSString stringWithFormat:@"insert into conti values('%@','%@','%@','%@', '%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", tipoconto,tabella.codice,ragionesociale,@"",tabella.indirizzo,@"",tabella.cap,locali,@"BS",@"IT",tabella.telefono,@"",@"",@"",@"",@"",tabella.codpag,@"",@"",tabella.email];
        NSLog(@"%@",query);
        
        
        
        
        
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // If the query was successfully executed then pop the view controller.
        if (self.dbManager.affectedRows != 0) {
            NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
            
            // Pop the view controller.
            
        }
        else {
            NSLog(@"PROBLEM Affected rows = %d", self.dbManager.affectedRows);
        }
        i+=1;
    }
    
    
    [_spinner stopAnimating];
    //_attendere.hidden=true;
    UIAlertView *messaggio=[[UIAlertView alloc]initWithTitle:@"SINCRONIZZAZIONE COMPLETA" message:@"Terminata con sucesso" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [messaggio show];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
-(void)SincroDati:(NSString*)SQLstring{
    SQLClient* client = [SQLClient sharedInstance];
    client.delegate = self;
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    [client connect:[NSString stringWithFormat:@"%@%@%@",mainDelegate.ServerId,@":",mainDelegate.PortaId] username:[NSString stringWithFormat:@"%@",mainDelegate.UtenteId]  password:[NSString stringWithFormat:@"%@",mainDelegate.PasswordId]  database:[NSString stringWithFormat:@"%@",mainDelegate.DBId]   completion:^(BOOL success) {
        if (success)
        {
            [client execute:SQLstring completion:^(NSArray* results) {
                [self PopolaSincro:results];
                [client disconnect];
            }];
        }
        
    }];
    
    
}
-(void)PopolaSincro:(NSArray*)data{
    
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
    
    
    [self salvalocalesqlite:@"Fornitori"];
    
    //[self.tableView reloadData];
    finecaricamento=true;
    
    
}



@end
