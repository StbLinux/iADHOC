//
//  VendutoCliente.m
//  iADHOC
//
//  Created by Mirko Totera on 25/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//
//select SALDICON.SLCODICE,MAX(SALDICON.SLCODESE) as SLCODESE,MAX(SIT_FIDI.FIDATELA) as FIDATELA,MAX(SIT_FIDI.FIIMPPAP) as FIIMPPAP,MAX(SIT_FIDI.FIIMPESC) as FIIMPESC,MAX(SIT_FIDI.FIIMPESO) as FIIMPESO,MAX(SIT_FIDI.FIIMPORD) as FIIMPORD,MAX(SIT_FIDI.FIIMPDDT) as FIIMPDDT,MAX(SIT_FIDI.FIIMPFAT) as FIIMPFAT,MAX(SALDICON.SLDARPER-SALDICON.SLAVEPER) as SALDOC from (ALESALDICON SALDICON Left outer Join ALESIT_FIDI SIT_FIDI on SALDICON.SLCODICE=SIT_FIDI.FICODCLI) where (SIT_FIDI.FICODCLI = '0000001')  group by SALDICON.SLCODICE   order by  1 , 2

#import "VendutoCliente.h"
#import "SQLClient.h"
#import "DBmanager.h"
#import "VENDUTO.h"
#import "Reachability.h"
@interface VendutoCliente ()
- (IBAction)Indietro:(id)sender;
@property (nonatomic) Reachability *hostReachability;
@property (nonatomic) Reachability *internetReachability;
@property (nonatomic) Reachability *wifiReachability;
@property (nonatomic) BOOL NOCONNECTION;
@end

@implementation VendutoCliente

-(void)viewDidAppear:(BOOL)animated{
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
 
    
}
- (void)viewDidLoad {
    
   
    if(![self checkConnection]){
             UIAlertView *Errore=[[UIAlertView alloc]initWithTitle:@"Attenzione" message:@"Nessuna connessione disponibile" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil ];
        [Errore show];
        
    }
    else {
        [super viewDidLoad];

      
        AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSString *label=@"GLOBALE";
        NSString *SQLState=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"select DOC_MAST.MVCODCON,SUM(DOC_DETT.MVVALRIG) as IMPONIBILE from ( dbo.",mainDelegate.AziendaId,@"DOC_MAST DOC_MAST Left outer Join ",mainDelegate.AziendaId,@"DOC_DETT DOC_DETT on DOC_MAST.MVSERIAL=DOC_DETT.MVSERIAL) where (DOC_MAST.MVFLVEAC='V' and DOC_MAST.MVCLADOC='FA' AND DOC_MAST.MVCODCON='",_pCodiceCliente,@"') group by DOC_MAST.MVCODCON"];
        // NSLog(@"%@",SQLState);
        [self EstrapolaDati:SQLState LABEL:label];
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
        
    }

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
    NSNumber *numero=[NSNumber alloc];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumIntegerDigits = 8;
    formatter.minimumFractionDigits = 2;
    formatter.maximumFractionDigits = 2;
    formatter.usesSignificantDigits = NO;
    formatter.usesGroupingSeparator = YES;
    formatter.groupingSeparator = @".";
    formatter.decimalSeparator = @",";
    for (NSArray* table in data)
        for (NSDictionary* row in table){
            
            for (NSString* column in row){
                
               
                
                if ([column isEqual:@"IMPONIBILE"]) {
                    self.venduto.GLOBALE=row[column];
                   // NSLog(@"%@%@",@"venduto entro:",self.venduto.IMPONIBILE);
                   

                }
                
                if ([column isEqual:@"SALDOC"]) {
                    self.venduto.SALDOCON=row[column];
                    
                    
                }

               
                if ([column isEqual:@"FIDATELA"]) {
                    self.venduto.DATELA=row[column];
                   // NSLog(@"%@%@",@"venduto entro:",self.venduto.SALDOCON);
                    
                    
                }
                if ([column isEqual:@"FIIMPPAP"]) {
                    self.venduto.PARTITEAPERTE=row[column];
                    // NSLog(@"%@%@",@"venduto entro:",self.venduto.SALDOCON);
                    
                    
                }
                if ([column isEqual:@"FIIMPESC"]) {
                    self.venduto.FIIMPESC=row[column];
                    // NSLog(@"%@%@",@"venduto entro:",self.venduto.SALDOCON);
                    
                    
                }
                if ([column isEqual:@"FIIMPESO"]) {
                    self.venduto.FIIMPESO=row[column];
                    // NSLog(@"%@%@",@"venduto entro:",self.venduto.SALDOCON);
                    
                    
                }
                if ([column isEqual:@"FIIMPORD"]) {
                    self.venduto.FIIMPORD=row[column];
                    // NSLog(@"%@%@",@"venduto entro:",self.venduto.SALDOCON);
                    
                    
                }
                if ([column isEqual:@"FIFIIMPDDT"]) {
                    self.venduto.FIIMPDDT=row[column];
                    // NSLog(@"%@%@",@"venduto entro:",self.venduto.SALDOCON);
                    
                    
                }
                if ([column isEqual:@"FIIMPFAT"]) {
                    self.venduto.FIIMPFAT=row[column];
                    // NSLog(@"%@%@",@"venduto entro:",self.venduto.SALDOCON);
                    
                    
                }
                            }
            
            //as SLCODESE,MAX(SIT_FIDI.FIDATELA) as FIDATELA,MAX(SIT_FIDI.FIIMPPAP) as FIIMPPAP,MAX(SIT_FIDI.FIIMPESC) as FIIMPESC,MAX(SIT_FIDI.FIIMPESO) as FIIMPESO,MAX(SIT_FIDI.FIIMPORD) as FIIMPORD,MAX(SIT_FIDI.FIIMPDDT) as FIIMPDDT,MAX(SIT_FIDI.FIIMPFAT) as FIIMPFAT,MAX(SALDICON.SLDARPER-SALDICON.SLAVEPER) as SALDOC
            

            if ([label isEqualToString:@"GLOBALE"] ) {
                NSNumber *vendutoglobale=[NSNumber numberWithDouble:[self.venduto.GLOBALE doubleValue]];
                NSString *vendutog = [formatter stringFromNumber:vendutoglobale];
                _Imponibile.textColor=[UIColor blueColor];
               _Imponibile.text=vendutog;
              // NSLog(@"%@%@",@"venduto:",_venduto.IMPONIBILE);
          
            }
            
            if ([label isEqualToString:@"SALDOC"] ) {
                             //  _SaldoContabile.text=self.venduto.SALDOCON;
              numero=[NSNumber numberWithDouble:[self.venduto.SALDOCON doubleValue]];
                NSString *Saldocon = [formatter stringFromNumber:numero];
                _SaldoContabile.textColor=[UIColor blueColor];
                _SaldoContabile.text=Saldocon;

                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
                [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                NSString *oggi = [dateFormatter stringFromDate:[NSDate date]];
                                   NSLog(@"%@%@",@"numero:",numero);
                NSLog(@"%@%@",@"venduto:",_venduto.SALDOCON);
               _Labelsaldo.text =[NSString stringWithFormat:@"%@%@",@"Saldo contabile al ",oggi];
                numero=[NSNumber numberWithDouble:[self.venduto.PARTITEAPERTE doubleValue]];
                NSString *partiteaperte = [formatter stringFromNumber:numero];
                _PARTITE.textColor=[UIColor blueColor];
                _PARTITE.text=partiteaperte;
                numero=[NSNumber numberWithDouble:[self.venduto.FIIMPORD doubleValue]];
                NSString *ORDINI = [formatter stringFromNumber:numero];
                _ORDINI.textColor=[UIColor blueColor];
                _ORDINI.text=ORDINI;
                numero=[NSNumber numberWithDouble:[self.venduto.FIIMPFAT doubleValue]];
                NSString *fatture = [formatter stringFromNumber:numero];
                _FATTURE.textColor=[UIColor blueColor];
                _FATTURE.text=fatture;
                numero=[NSNumber numberWithDouble:[self.venduto.FIIMPDDT doubleValue]];
                NSString *ddt = [formatter stringFromNumber:numero];
                _DDT.textColor=[UIColor blueColor];
                _DDT.text=ddt;
                
                
                
                
                
                
                
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

- (IBAction)Indietro:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)SYNC:(id)sender {
    if(![self checkConnection]){
        //  NSLog(@"%@",@"NON ESISTE");
        UIAlertView *Errore=[[UIAlertView alloc]initWithTitle:@"Attenzione" message:@"Nessuna connessione disponibile" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil ];
        [Errore show];
        
    }
    else {
        //NSLog(@"%@",string);
        AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        // NSInteger day = [components day];
        // NSInteger month = [components month];
        NSInteger year = [components year];
        NSString * anno = [NSString stringWithFormat:@"%0.0d", (int)year];
        //  NSLog(@"%ld",(long)year);
        NSLog(@"%@",anno);
        NSString *SQL1=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"select SALDICON.SLCODICE,MAX(SALDICON.SLCODESE) as SLCODESE,MAX(SIT_FIDI.FIDATELA) as FIDATELA,MAX(SIT_FIDI.FIIMPPAP) as FIIMPPAP,MAX(SIT_FIDI.FIIMPESC) as FIIMPESC,MAX(SIT_FIDI.FIIMPESO) as FIIMPESO,MAX(SIT_FIDI.FIIMPORD) as FIIMPORD,MAX(SIT_FIDI.FIIMPDDT) as FIIMPDDT,MAX(SIT_FIDI.FIIMPFAT) as FIIMPFAT,MAX(SALDICON.SLDARPER-SALDICON.SLAVEPER) as SALDOC from (dbo.",mainDelegate.AziendaId,@"SALDICON SALDICON Left outer Join ",mainDelegate.AziendaId,@"SIT_FIDI SIT_FIDI on SALDICON.SLCODICE=SIT_FIDI.FICODCLI) where (SIT_FIDI.FICODCLI = '",_pCodiceCliente,@"')  group by SALDICON.SLCODICE   order by  1 , 2"];
        // NSString *SQL1=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"select SLCODICE,(SLDARINI-SLAVEINI) as SALDOC from dbo.",mainDelegate.AziendaId,@"SALDICON where (SLTIPCON = 'C' and SLCODICE='",_pCodiceCliente,@"' and SLCODESE='",anno,@"')"];
        // NSString *SQL1=[NSString stringWithFormat:@"%@%@%@%@%@",@"select SLCODICE,(SLDARINI-SLAVEINI) as SALDOC from dbo.",mainDelegate.AziendaId,@"SALDICON where (SLTIPCON = 'C' and SLCODICE='",_pCodiceCliente,@"' and SLCODESE='2014')"];
        
        NSLog(@"%@",SQL1);
        
        [self EstrapolaDati:SQL1 LABEL:@"SALDOC"];

        // NSLog(@"%@",@" ESISTE");
      
        
    }
   
    
}
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
          
            _NOCONNECTION=true;

        }
        else {
            NSLog(@"%@",@"pingabile");
          _NOCONNECTION=false;
            
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
