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
#import "Reachability.h"
@interface Clienti ()
@property (strong,nonatomic) DBmanager *dbManager;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;

@end

@implementation Clienti{
    //ANACLI *anacli;
    //BOOL primasincro;
    BOOL finecaricamento;
    IBOutlet UINavigationItem *navitem;
      }
-(void)viewDidAppear:(BOOL)animated{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    _SearchBar.delegate=self;
    navitem.titleView=_SearchBar;
    //self.tableView.frame = CGRectMake(0,navbar.frame.size.height, 320, self.view.frame.size.height-navbar.frame.size.height);
   //   _SearchBar.backgroundColor=[UIColor blueColor];

   //self.parentViewController.navigationItem.titleView=_SearchBar;
    
  //  navigation.titleView=_SearchBar;
       self.edgesForExtendedLayout = UIRectEdgeNone;
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
  //  NSLog(@"%@",mainDelegate.OnlineId);
    
#if TARGET_IPHONE_SIMULATOR
    // where are you?
    NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
#endif
       // Initialize the dbManager object.
           
        if ([_tablesource count]==0) {
            NSLog(@"%@",@"nessun record");
            if (mainDelegate.OnlineId.boolValue==1) {
                if(![self checkConnection]){
                    UIAlertView *Errore=[[UIAlertView alloc]initWithTitle:@"Attenzione" message:@"Nessuna connessione disponibile" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil ];
                    [Errore show];
                    
                }
                else {
                    
                    NSString *SQLState=[NSString stringWithFormat:@"%@%@%@%@",@"SELECT ANCODICE, ANDESCRI,ANINDIRI,ANLOCALI,AN___CAP,ANPROVIN,ANTELEFO,AN_EMAIL,ANCODPAG FROM dbo.",mainDelegate.AziendaId,@"CONTI ",@"where ANTIPCON='C' order by ANDESCRI"];
                    [self EstrapolaDati:SQLState];

                    
                }
                
            }
            else {
                NSLog(@"%@",@"DBmanager");

                self.dbManager = [[DBmanager alloc] initWithDatabaseFilename:@"AHR.sqlite"];
                NSString *query = @"select ANTIPCON,ANCODICE,ANDESCRI,ANDESCR2,ANINDIRI,ANINDIRI2,AN___CAP,ANLOCALI,ANPROVIN,ANNAZION,ANTELEFO,ANTELFAX,ANNUMCEL,ANCODFIS,ANPARIVA,ANCATCON,ANCODPAG,AN__NOTE,ANINDWEB,AN_EMAIL from CONTI where ANTIPCON='C'";
                
                // Get the results.
                
                self.tablesource = nil;
                
                self.tablesource = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
                
                if ([self.tablesource count]==0) {
                    
                    NSLog(@"%@",@"Non trovo record");
                }
                else {
                    [self.tableView reloadData];
                    finecaricamento=true;
                }
                
            }
            
        }

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
       return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
   
         return [self.tablesource count];
   
    }
   
   

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    static NSString *ZoomClienti=@"ZoomClienti";
    ZoomCli *cell =(ZoomCli *)[tableView dequeueReusableCellWithIdentifier:ZoomClienti forIndexPath:indexPath];
    
    if(cell==nil) {;
        cell=[[ZoomCli alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZoomClienti];
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



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"DettaglioClienti" sender:nil];

}

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
            if(![self checkConnection]){
                UIAlertView *Errore=[[UIAlertView alloc]initWithTitle:@"Attenzione" message:@"Nessuna connessione disponibile" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil ];
                [Errore show];
                
            }
            else {
                
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
            }

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
            NSString *SQLState=[NSString stringWithFormat:@"%@%@%@%@",@"SELECT ANTIPCON,ANCODICE, ANDESCRI,ANDESCR2,ANINDIRI,ANINDIR2,AN___CAP,ANLOCALI,ANPROVIN,ANNAZION,ANTELEFO,ANTELFAX,ANNUMCEL,ANCODFIS,ANPARIVA,ANCATCON,ANCODPAG,AN__NOTE,ANINDWEB,AN_EMAIL FROM dbo.",mainDelegate.AziendaId,@"CONTI ",@"where ANTIPCON='C' order by ANDESCRI"];
            // NSLog(@"%@",SQLState);
            [self EstrapolaDati:SQLState];
            [searchBar resignFirstResponder];

        }
       
       
}
    else {
        if (finecaricamento==true) {
            finecaricamento=false;
            NSString *query = @"select ANTIPCON,ANCODICE,ANDESCRI,ANDESCR2,ANINDIRI,ANINDIRI2,AN___CAP,ANLOCALI,ANPROVIN,ANNAZION,ANTELEFO,ANTELFAX,ANNUMCEL,ANCODFIS,ANPARIVA,ANCATCON,ANCODPAG,AN__NOTE,ANINDWEB,AN_EMAIL from CONTI where ANTIPCON='C'";
            
            // Get the results.
            
            self.tablesource = nil;
            
            self.tablesource = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
            
            
        }
        
        [self.tableView reloadData];
        [searchBar resignFirstResponder];
        finecaricamento=true;
        }
        

}

-(void)cerca:(UISearchBar *)searchBar {
    if (finecaricamento==true) {
        AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        if (mainDelegate.OnlineId.boolValue==1) {
            finecaricamento=false;
            NSString *SQLState=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"SELECT ANTIPCON,ANCODICE, ANDESCRI,ANDESCR2,ANINDIRI,ANINDIR2,AN___CAP,ANLOCALI,ANPROVIN,ANNAZION,ANTELEFO,ANTELFAX,ANNUMCEL,ANCODFIS,ANPARIVA,ANCATCON,ANCODPAG,AN__NOTE,ANINDWEB,AN_EMAIL FROM dbo.",mainDelegate.AziendaId,@"CONTI ",@"where ANTIPCON='C' and ANDESCRI LIKE '%",searchBar.text,@"%' ",@"order by ANDESCRI"];
            // NSLog(@"%@",SQLState);
            [self EstrapolaDati:SQLState];
            [searchBar resignFirstResponder];
        }
        else {
            finecaricamento=false;
            NSString *query =[NSString stringWithFormat:@"%@%@%@",@"select ANTIPCON,ANCODICE,ANDESCRI,ANDESCR2,ANINDIRI,ANINDIRI2,AN___CAP,ANLOCALI,ANPROVIN,ANNAZION,ANTELEFO,ANTELFAX,ANNUMCEL,ANCODFIS,ANPARIVA,ANCATCON,ANCODPAG,AN__NOTE,ANINDWEB,AN_EMAIL from CONTI where ANTIPCON='C' and ANDESCRI LIKE '%",searchBar.text,@"%'"];
            
            // Get the results.
            
            self.tablesource = nil;
            
            self.tablesource = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        }
        [searchBar resignFirstResponder];
        [self.tableView reloadData];
        finecaricamento=true;


    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
}
/*- (BOOL)prefersStatusBarHidden
{
    return YES;
}*/
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
                    [self Cancella_archivio:@"CONTI" condizione:@"ANTIPCON='C'"];
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
                    
                    
                        SQLState=[NSString stringWithFormat:@"%@%@%@%@",@"SELECT ANTIPCON,ANCODICE, ANDESCRI,ANDESCR2,ANINDIRI,ANINDIR2,AN___CAP,ANLOCALI,ANPROVIN,ANNAZION,ANTELEFO,ANTELFAX,ANNUMCEL,ANCODFIS,ANPARIVA,ANCATCON,ANCODPAG,AN__NOTE,ANINDWEB,AN_EMAIL FROM dbo.",mainDelegate.AziendaId,@"CONTI ",@"where ANTIPCON='C' order by ANDESCRI"];
                        
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
        
                tipoconto=@"C";
        
            
            
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
    
   
    [self salvalocalesqlite:@"Clienti"];
    
    //[self.tableView reloadData];
    finecaricamento=true;
   
    
}
/*-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // get the table and search bar bounds
    CGRect tableBounds = self.tableView.bounds;
    CGRect searchBarFrame = self.SearchBar.frame;
    // make sure the search bar stays at the table's original x and y as the content moves
    self.SearchBar.frame = CGRectMake(tableBounds.origin.x+72,
                                      tableBounds.origin.y,
                                      searchBarFrame.size.width,
                                      searchBarFrame.size.height
                                      );
    
}*/
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if (reachability == self.hostReachability)
    {
        NSLog(@"%@",@"connessone");
        // [self configureTextField:self.remoteHostStatusField imageView:self.remoteHostImageView reachability:reachability];
        NetworkStatus netStatus = [reachability currentReachabilityStatus];
        NSLog(@"%ld",netStatus);
        //ReachableViaWWAN
        if (netStatus == NotReachable) {
            NSLog(@"%@",@"Nessuna connessione");
            
            
        }
        else {
            NSLog(@"%@",@"pingabile");
          
            
        }
        // BOOL connectionRequired = [reachability connectionRequired];
        
        //  self.summaryLabel.hidden = (netStatus != ReachableViaWWAN);
        // NSString* baseLabelText = @"";
        
        /* if (connectionRequired)
         {
         baseLabelText = NSLocalizedString(@"Cellular data network is available.\nInternet traffic will be routed through it after a connection is established.", @"Reachability text if a connection is required");
         }
         else
         {
         baseLabelText = NSLocalizedString(@"Cellular data network is active.\nInternet traffic will be routed through it.", @"Reachability text if a connection is not required");
         }
         self.summaryLabel.text = baseLabelText;*/
    }
    
    if (reachability == self.internetReachability)
    {
        //[self configureTextField:self.internetConnectionStatusField imageView:self.internetConnectionImageView reachability:reachability];
    }
    
    if (reachability == self.wifiReachability)
    {
        //[self configureTextField:self.localWiFiConnectionStatusField imageView:self.localWiFiConnectionImageView reachability:reachability];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

- (BOOL)checkConnection  {
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *remoteHostName = mainDelegate.ServerId;
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    NetworkStatus netStatus = [self.hostReachability currentReachabilityStatus];
    NSLog(@"%ld",netStatus);
    //ReachableViaWWAN
    if (netStatus == NotReachable) {
        NSLog(@"%@",@"Nessuna connessione");
        
        return NO;
        
    }
    else {
        NSLog(@"%@",@"pingabile");
        return YES;
        
    }
    
    return NO;
}

@end
