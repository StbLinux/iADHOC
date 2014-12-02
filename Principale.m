//
//  Principale.m
//  iADHOC
//
//  Created by Mirko Totera on 27/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import "Principale.h"
#import "SQLClient.h"
#import "ANACLI.h"
#import "ANAART.h"
#import "DBmanager.h"

@interface Principale ()
@property (strong,nonatomic) DBmanager *dbManager;

@end

@implementation Principale
-(void) viewDidAppear:(BOOL)animated {
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (mainDelegate.OnlineId.boolValue==true) {
        _OnOffline.on=true;
    }
    else {
        _OnOffline.on=false;
        
    }

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

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
- (IBAction)Sincronizza:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sincronizzazioni"
                                                             delegate:self
                                                    cancelButtonTitle:@"Annulla"
                                               destructiveButtonTitle:@"Elimina Tutto"
                                                    otherButtonTitles:@"Sinc.Clienti", @"Sic.Fornitori", @"Sinc.Articoli", nil];
    
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
        if (buttonIndex==0) {
            NSLog(@"The Normal action sheet.");
            [self Cancella_archivio:@"CONTI" condizione:@"ANTIPCON='C'"];
            [self Cancella_archivio:@"CONTI" condizione:@"ANTIPCON='F'"];
            [self Cancella_archivio:@"ARTICOLI" condizione:@"1=1"];
            UIAlertView *messaggio=[[UIAlertView alloc]initWithTitle:@"AD ELABORAZIONE TERMINATA" message:@"RIAVVIARE iADHOC" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [messaggio show];
        }
        if (buttonIndex==1) {
            _attendere.hidden=false;
            

            _spinner = [[UIActivityIndicatorView alloc]
                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            _spinner.center = CGPointMake(160, 240);
            _spinner.hidesWhenStopped = YES;
            
            
            [self.view addSubview:_spinner];
            
            [_spinner startAnimating];
            
            [self loadData:@"clienti"];

        }
        if (buttonIndex==2) {
            _attendere.hidden=false;

            _spinner = [[UIActivityIndicatorView alloc]
                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            _spinner.center = CGPointMake(160, 240);
            _spinner.hidesWhenStopped = YES;
            [self.view addSubview:_spinner];
            [_spinner startAnimating];
            [self loadData:@"fornitori"];

        }
        
        if (buttonIndex==3) {
            _attendere.hidden=false;
            
            _spinner = [[UIActivityIndicatorView alloc]
                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            _spinner.center = CGPointMake(160, 240);
            _spinner.hidesWhenStopped = YES;
            [self.view addSubview:_spinner];
            [_spinner startAnimating];
            [self loadData:@"articoli"];
            
        }


    }
    
    NSLog(@"Index = %ld - Title = %@", (long)buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
}
- (void)Cancella_archivio:(NSString*)archivio condizione:(NSString*)condizione{
     self.dbManager = [[DBmanager alloc] initWithDatabaseFilename:@"AHR.sqlite"];
     NSString *query =[NSString stringWithFormat:@"%@%@%@%@", @"DELETE from ",archivio,@" where ",condizione ];
    [self.dbManager executeQuery:query];
    
}
-(void)EstrapolaDati:(NSString*)SQLstring ARCHIVIO:(NSString*)archivio{
    SQLClient* client = [SQLClient sharedInstance];
    client.delegate = self;
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    [client connect:[NSString stringWithFormat:@"%@%@%@",mainDelegate.ServerId,@":",mainDelegate.PortaId] username:[NSString stringWithFormat:@"%@",mainDelegate.UtenteId]  password:[NSString stringWithFormat:@"%@",mainDelegate.PasswordId]  database:[NSString stringWithFormat:@"%@",mainDelegate.DBId]   completion:^(BOOL success) {
        if (success)
        {
            [client execute:SQLstring completion:^(NSArray* results) {
                [self PopolaTabella:results ARCHIVIO:archivio];
                [client disconnect];
            }];
        }
        
    }];
    
    
}
-(void)PopolaTabella:(NSArray*)data ARCHIVIO:(NSString*)archivio{
 
    NSMutableArray* tbsource=[[NSMutableArray alloc]init];
    
    //Clienti e fornitori
     if ([archivio isEqualToString:@"clienti"]||[archivio isEqualToString:@"fornitori"]) {
         ANACLI *ANAGRAFICA;
    for (NSArray* table in data)
        for (NSDictionary* row in table){
           
                ANAGRAFICA=[[ANACLI alloc]init];
                for (NSString* column in row){
 
                    //NSLog(@"%@",row[column]);
                    if ([column isEqual:@"ANCODICE"]) {
 
                        ANAGRAFICA.codice=row[column] ;
                    }
                    
                    if ([column isEqual:@"ANLOCALI"]) {
                        
                        ANAGRAFICA.paese=row[column];
                    }
                    if ([column isEqual:@"ANDESCRI"]) {
                        
                        ANAGRAFICA.ragsoc=row[column] ;
                    }
                    if ([column isEqual:@"ANINDIRI"]) {
                        
                        ANAGRAFICA.indirizzo=row[column] ;
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
     }
    
    //Articoli di magazzino
    if ([archivio isEqualToString:@"articoli"]){
        ANAART *ANAGRAFICA;
        for (NSArray* table in data)
            for (NSDictionary* row in table){
                ANAGRAFICA=[[ANAART alloc]init];
                for (NSString* column in row){
                    
                    //NSLog(@"%@",row[column]);
                    
                    if ([column isEqual:@"ARCODART"]) {
                        
                        ANAGRAFICA.arcodice=row[column];
                    }
                    if ([column isEqual:@"ARDESART"]) {
                        
                        ANAGRAFICA.ardescri=row[column] ;
                        NSLog(@"%@",ANAGRAFICA.ardescri);
                    }
                    if ([column isEqual:@"ARDESSUP"]) {
                        
                        ANAGRAFICA.ardessup=row[column] ;
                    }
                    if ([column isEqual:@"ARUNMIS1"]) {
                        
                        ANAGRAFICA.arunmis1=row[column] ;
                    }
                    if ([column isEqual:@"ARMOLTIP"]) {
                        
                        ANAGRAFICA.armoltip=row[column] ;
                    }
                    
                    if ([column isEqual:@"ARGRUMER"]) {
                        
                        ANAGRAFICA.argrumer=row[column] ;
                    }
                    if ([column isEqual:@"ARCODFAM"]) {
                        
                        ANAGRAFICA.arcodfam=row[column] ;
                    }
                    if ([column isEqual:@"ARTIPART"]) {
                        
                        ANAGRAFICA.artipart=row[column] ;
                    }
                    
                    
                }
                
                
                
                
                // NSLog(@"%@",ANAGRAFICA.codice );
                [tbsource   addObject:ANAGRAFICA];
                
            }
        
    }
    
    self.tablesource=tbsource;
    NSLog(@"%@",archivio);
           [self salvalocalesqlite:archivio];
   
    
    
}

#pragma mark - SQLClientDelegate

//Required
- (void)error:(NSString*)error code:(int)code severity:(int)severity
{
    [_spinner stopAnimating];
    UIAlertView *messaggio=[[UIAlertView alloc]initWithTitle:@"ERRORE DI CONNESSIONE" message:@"CONTROLLARE LA CONNESSIONE" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [messaggio show];

    NSLog(@"Error #%d: %@ (Severity %d)", code, error, severity);
    
}

//Optional
- (void)message:(NSString*)message
{
    NSLog(@"Message: %@", message);
}
-(void) salvalocalesqlite:(NSString*)archivio{
     self.dbManager = [[DBmanager alloc] initWithDatabaseFilename:@"AHR.sqlite"];
    NSInteger nrecord=[_tablesource count];
    //NSLog(@"%li%@",_tablesource.count,@"nrecord");
    // NSLog(@"%@",_tablesource);
    NSInteger i=0;
    NSString *tipoconto;
    NSString *query;
    
    while (i<nrecord) {
        //Clienti o fornitori
        if ([archivio isEqualToString:@"clienti"]||[archivio isEqualToString:@"fornitori"]) {

        ANACLI *tabella;
       
             tabella=[[ANACLI alloc]init];
            if ([archivio isEqualToString:@"clienti"]) {
                tipoconto=@"C";
            }
            
            if ([archivio isEqualToString:@"fornitori"]) {
                tipoconto=@"F";
                
            }
            tabella=[_tablesource objectAtIndex:i];
            NSString *locali=tabella.paese;
            locali=[locali stringByReplacingOccurrencesOfString:@"'" withString:@" "];
            NSString *ragionesociale=tabella.ragsoc;
            ragionesociale = [ragionesociale stringByReplacingOccurrencesOfString:@"'"
                                                                       withString:@" "];
          query = [NSString stringWithFormat:@"insert into conti values('%@','%@','%@','%@', '%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')", tipoconto,tabella.codice,ragionesociale,@"",tabella.indirizzo,@"",tabella.cap,locali,@"BS",@"IT",tabella.telefono,@"",@"",@"",@"",@"",tabella.codpag,@"",@"",tabella.email];
            NSLog(@"%@",query);

        }
       
            //ARTICOLI
        
         if ([archivio isEqualToString:@"articoli"]) {
             ANAART *tabella=[[ANAART alloc]init];
             tabella=[_tablesource objectAtIndex:i];
             
             query = [NSString stringWithFormat:@"insert into articoli values('%@','%@','%@','%@', '%@','%@','%@','%@')",tabella.arcodice,tabella.ardescri,tabella.ardessup,tabella.arunmis1,tabella.armoltip,tabella.argrumer,tabella.arcodfam,tabella.artipart ];
             
             
         }
        
        
        
        
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
      _attendere.hidden=true;
    UIAlertView *messaggio=[[UIAlertView alloc]initWithTitle:@"SINCRONIZZAZIONE TERMINATA" message:@"RIAVVIARE L'APPLICAZIONE" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [messaggio show];
}

-(void)loadData :(NSString*)archivio{
    
    // NSLog(@"%@",@"sono qui");
    NSString *SQLState;
        AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //CLIENTI
   
    if ([archivio isEqualToString:@"clienti"]) {
        
       SQLState=[NSString stringWithFormat:@"%@%@%@%@",@"SELECT ANTIPCON,ANCODICE, ANDESCRI,ANDESCR2,ANINDIRI,ANINDIR2,AN___CAP,ANLOCALI,ANPROVIN,ANNAZION,ANTELEFO,ANTELFAX,ANNUMCEL,ANCODFIS,ANPARIVA,ANCATCON,ANCODPAG,AN__NOTE,ANINDWEB,AN_EMAIL FROM dbo.",mainDelegate.AziendaId,@"CONTI ",@"where ANTIPCON='C' order by ANDESCRI"];

    }
   
    //FORNITORI
  
    if ([archivio isEqualToString:@"fornitori"]) {
       
        SQLState=[NSString stringWithFormat:@"%@%@%@%@",@"SELECT ANTIPCON,ANCODICE, ANDESCRI,ANDESCR2,ANINDIRI,ANINDIR2,AN___CAP,ANLOCALI,ANPROVIN,ANNAZION,ANTELEFO,ANTELFAX,ANNUMCEL,ANCODFIS,ANPARIVA,ANCATCON,ANCODPAG,AN__NOTE,ANINDWEB,AN_EMAIL FROM dbo.",mainDelegate.AziendaId,@"CONTI ",@"where ANTIPCON='F' order by ANDESCRI"];
        
    }
   
    //ARTICOLI
    
    if ([archivio isEqualToString:@"articoli"]) {
   SQLState=[NSString stringWithFormat:@"%@%@%@%@",@"SELECT ARCODART,ARDESART, ARDESSUP,ARUNMIS1,ARMOLTIP,ARGRUMER,ARCODFAM,ARTIPART FROM dbo.",mainDelegate.AziendaId,@"ART_ICOL where ARTIPART='PF'",@"order by ARCODART"];
        
        
    }

                [self EstrapolaDati:SQLState ARCHIVIO:archivio];
        
        
        
    
}

- (IBAction) toggleOnForOnline: (id) sender {
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (_OnOffline.on) {
        [mainDelegate setValue:@"1" forKey:@"OnlineId"];
        NSLog(@"%@",mainDelegate.OnlineId);

    }
    else {
        [mainDelegate setValue:@"0" forKey:@"OnlineId"];
        NSLog(@"%@",mainDelegate.OnlineId);

        
    }
   }
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)Indietro:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
