//
//  Listini.m
//  iADHOC
//
//  Created by Mirko Totera on 24/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import "Listini.h"
#import "SQLClient.h"
#import "DBmanager.h"
#import "ANALIS.h"
#import "ZoomLis.h"

@interface Listini ()
@property (strong,nonatomic) DBmanager *dbManager;

@end

@implementation Listini{
   
    BOOL primasincro;
    BOOL finecaricamento;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    finecaricamento=false;
    self.titolo.title=[NSString stringWithFormat:@"%@%@",@"Listini articolo: ",_pCodiceArticolo];
    //self.SearchBar.delegate = self;
    // Initialize the dbManager object.
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (mainDelegate.OnlineId.boolValue==1) {
      //  NSLog(@"%@","@ENTROOOOOOO");
        NSString *SQLState=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",@" select LICODLIS ,LIS_TINI.LICODART,CPROWNUM,SUBSTRING(SUBSTRING('00' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(DAY,LIS_TINI.LIDATATT)) )),COALESCE(DATALENGTH('00' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(DAY,LIS_TINI.LIDATATT)) ))),0)-2+1,2)+'-'+SUBSTRING('00' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(MONTH,LIS_TINI.LIDATATT)) )),COALESCE(DATALENGTH('00' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(MONTH,LIS_TINI.LIDATATT)) ))),0)-2+1,2)+'-'+SUBSTRING('0000' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(YEAR,LIS_TINI.LIDATATT)) )),COALESCE(DATALENGTH('0000' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(YEAR,LIS_TINI.LIDATATT)) ))),0)-4+1,4),1,10) as LIDATATT,SUBSTRING(SUBSTRING('00' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(DAY,LIS_TINI.LIDATDIS)) )),COALESCE(DATALENGTH('00' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(DAY,LIS_TINI.LIDATDIS)) ))),0)-2+1,2)+'-'+SUBSTRING('00' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(MONTH,LIS_TINI.LIDATDIS)) )),COALESCE(DATALENGTH('00' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(MONTH,LIS_TINI.LIDATDIS)) ))),0)-2+1,2)+'-'+SUBSTRING('0000' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(YEAR,LIS_TINI.LIDATDIS)) )),COALESCE(DATALENGTH('0000' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(YEAR,LIS_TINI.LIDATDIS)) ))),0)-4+1,4),1,10) as LIDATDIS,LIS_SCAG.LIPREZZO, LIS_SCAG.LISCONT1,LIS_SCAG.LISCONT2,LIS_SCAG.LISCONT3,LIS_SCAG.LISCONT4 from (",mainDelegate.AziendaId,@"LIS_TINI   LIS_TINI Left outer Join ",mainDelegate.AziendaId,@"LIS_SCAG LIS_SCAG on LIS_TINI.LICODART=LIS_SCAG.LICODART and LIS_TINI.CPROWNUM=LIS_SCAG.LIROWNUM) where (LIS_TINI.LICODART='",_pCodiceArticolo,@"') order by 3 desc"];
        [self EstrapolaDati:SQLState];
        
    }
    else {
        
        self.dbManager = [[DBmanager alloc] initWithDatabaseFilename:@"AHR.sqlite"];
       NSString *query =[NSString stringWithFormat:@"%@%@%@", @"select codlis,codart,nriga,dtinizio,dtfine,prezzo,sc1,sc2,sc3,sc4 from listini where codart='",_pCodiceArticolo,@"'"];
        
        // Get the results.
        
        self.tablesource = nil;
        
        self.tablesource = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        
        if ([self.tablesource count]==0) {
            primasincro=true;
            _spinner = [[UIActivityIndicatorView alloc]
                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            _spinner.center = CGPointMake(160, 240);
            _spinner.hidesWhenStopped = YES;
            
            
            [self.view addSubview:_spinner];
            
            [_spinner startAnimating];
            [self loadData];
            
            
        }
        
    }
    
    

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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.tablesource count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    static NSString *ZoomListini=@"ZoomListini";
    ZoomLis *cell =(ZoomLis *)[tableView dequeueReusableCellWithIdentifier:ZoomListini forIndexPath:indexPath];
    
    if(cell==nil) {;
        cell=[[ZoomLis alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZoomListini];
    }
    self.title=[NSString stringWithFormat:@"%@%@",@"Articolo: ",_pCodiceArticolo];
    if (mainDelegate.OnlineId.boolValue==1) {
        ANALIS *listini= [self.tablesource objectAtIndex:indexPath.row];
        NSLog(@"%@",listini.codice);
        cell.codice.text=listini.codice;
        cell.dtinizio.text=listini.dtinizio;
        cell.dtfine.text=listini.dtfine;
        cell.prezzo.text=listini.prezzo;
        cell.sc1.text=listini.sc1;
        cell.sc2.text=listini.sc2;
        cell.sc3.text=listini.sc3;
        cell.sc4.text=listini.sc4;
    } else {
        
        
        NSInteger indexOfcodice = [self.dbManager.arrColumnNames indexOfObject:@"codlis"];
        
        NSLog(@"@%ld",(long)indexOfcodice);
        NSInteger indexOfdtinizio = 3;
        NSInteger indexOfdtfine = 4;
        NSInteger indexOfprezzo = 4;
        NSInteger indexOfsc1 = 5;
        NSInteger indexOfsc2 = 6;
        NSInteger indexOfsc3 = 7;
        NSInteger indexOfsc4 = 8;





        
        // Set the loaded data to the appropriate cell labels.
        cell.codice.text = [NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:indexPath.row] objectAtIndex:indexOfcodice]];
        NSLog(@"%@",[[self.tablesource objectAtIndex:indexPath.row] objectAtIndex:3]);
        cell.dtinizio.text = [NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:indexPath.row] objectAtIndex:indexOfdtinizio]];
        cell.dtfine.text = [NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:indexPath.row] objectAtIndex:indexOfdtfine]];
        
         cell.prezzo.text = [NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:indexPath.row] objectAtIndex:indexOfprezzo]];
         cell.sc1.text = [NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:indexPath.row] objectAtIndex:indexOfsc1]];
        
        cell.sc2.text = [NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:indexPath.row] objectAtIndex:indexOfsc2]];
        cell.sc3.text = [NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:indexPath.row] objectAtIndex:indexOfsc3]];
        cell.sc4.text = [NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:indexPath.row] objectAtIndex:indexOfsc4]];


        
        
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)EstrapolaDati:(NSString*)SQLstring{
    SQLClient* client = [SQLClient sharedInstance];
    client.delegate = self;
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
    [client connect:[NSString stringWithFormat:@"%@%@%@",mainDelegate.ServerId,@":",mainDelegate.PortaId] username:[NSString stringWithFormat:@"%@",mainDelegate.UtenteId]  password:[NSString stringWithFormat:@"%@",mainDelegate.PasswordId]  database:[NSString stringWithFormat:@"%@",mainDelegate.DBId]   completion:^(BOOL success) {
        if (success)
        {
            [client execute:SQLstring completion:^(NSArray* results) {
                NSLog(@"%@",results);
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
            ANALIS *LISTINI=[[ANALIS alloc]init];
            for (NSString* column in row){
                
                //NSLog(@"%@",row[column]);
                NSLog(@"%@",column);
                if ([column isEqual:@"LICODLIS"]) {
                    
                    LISTINI.codice=row[column];
                }
                if ([column isEqual:@"LICODART"]) {
                    
                    LISTINI.codart=row[column] ;
                }
                if ([column isEqual:@"CPROWNUM"]) {
                    
                    LISTINI.nriga=row[column] ;
                }
                if ([column isEqual:@"LIDATATT"]) {
                    
                    LISTINI.dtinizio=row[column] ;
                }
                if ([column isEqual:@"LIDATDIS"]) {
                    
                    LISTINI.dtfine=row[column] ;
                }
                if ([column isEqual:@"LIPREZZO"]) {
                    
                   LISTINI.prezzo=row[column] ;
                }
                if ([column isEqual:@"LISCONT1"]) {
                    
                   LISTINI.sc1=row[column] ;
                }
                if ([column isEqual:@"LISCONT2"]) {
                    
                     LISTINI.sc2=row[column] ;
                }
                if ([column isEqual:@"LISCONT3"]) {
                    
                     LISTINI.sc3=row[column] ;
                }
                if ([column isEqual:@"LISCONT4"]) {
                    
                     LISTINI.sc4=row[column] ;
                }

            }
            
            
            
            
            // NSLog(@"%@",ANAGRAFICA.codice );
            [tbsource   addObject:LISTINI];
            
        }
    
    
    self.tablesource=tbsource;
    if (primasincro==true) {
        [self salvaclientisqlite];
    }
    else {
        NSLog(@"%@",_tablesource);
        [self.tableView reloadData];
    }
    
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
    
    // NSLog(@"%@",@"sono qui");
    if (primasincro==true) {
        AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        NSString *SQLState=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",@" select LICODLIS ,LIS_TINI.LICODART,CPROWNUM,SUBSTRING(SUBSTRING('00' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(DAY,LIS_TINI.LIDATATT)) )),COALESCE(DATALENGTH('00' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(DAY,LIS_TINI.LIDATATT)) ))),0)-2+1,2)+'-'+SUBSTRING('00' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(MONTH,LIS_TINI.LIDATATT)) )),COALESCE(DATALENGTH('00' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(MONTH,LIS_TINI.LIDATATT)) ))),0)-2+1,2)+'-'+SUBSTRING('0000' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(YEAR,LIS_TINI.LIDATATT)) )),COALESCE(DATALENGTH('0000' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(YEAR,LIS_TINI.LIDATATT)) ))),0)-4+1,4),1,10) as LIDATATT,SUBSTRING(SUBSTRING('00' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(DAY,LIS_TINI.LIDATDIS)) )),COALESCE(DATALENGTH('00' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(DAY,LIS_TINI.LIDATDIS)) ))),0)-2+1,2)+'-'+SUBSTRING('00' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(MONTH,LIS_TINI.LIDATDIS)) )),COALESCE(DATALENGTH('00' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(MONTH,LIS_TINI.LIDATDIS)) ))),0)-2+1,2)+'-'+SUBSTRING('0000' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(YEAR,LIS_TINI.LIDATDIS)) )),COALESCE(DATALENGTH('0000' + LTRIM(RTRIM( CONVERT(CHAR,DATEPART(YEAR,LIS_TINI.LIDATDIS)) ))),0)-4+1,4),1,10) as LIDATDIS,LIS_SCAG.LIPREZZO, LIS_SCAG.LISCONT1,LIS_SCAG.LISCONT2,LIS_SCAG.LISCONT3,LIS_SCAG.LISCONT4 from (",mainDelegate.AziendaId,@"LIS_TINI   LIS_TINI Left outer Join ",mainDelegate.AziendaId,@"LIS_SCAG LIS_SCAG on LIS_TINI.LICODART=LIS_SCAG.LICODART and LIS_TINI.CPROWNUM=LIS_SCAG.LIROWNUM) where (LIS_TINI.LICODART='",_pCodiceArticolo,@"') order by 3 desc"];

        NSLog(@"%@",SQLState);
        [self EstrapolaDati:SQLState];
        
        
        
        
        [self.tableView reloadData];
        
    }
    else {
        [self.tableView reloadData];
        
        
    }
    finecaricamento=true;
    
}


-(void) salvaclientisqlite{
    
    NSInteger nrecord=[_tablesource count];
    NSLog(@"%li%@",_tablesource.count,@"nrecord");
    NSLog(@"%@",_tablesource);
    NSInteger i=0;
   
    while (i<nrecord) {
        
        ANALIS *listini=[[ANALIS alloc]init];
        listini=[_tablesource objectAtIndex:i];
        NSLog(@"%@",listini.codice);
        
        
        NSString *query = [NSString stringWithFormat:@"insert into listini values('%@','%@','%@','%@', '%@','%@','%@','%@','%@','%@')", listini.codice,listini.codart,listini.nriga,listini.dtinizio,listini.dtfine,listini.prezzo,listini.sc1,listini.sc2,listini.sc3,listini.sc4];
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
    NSString *query =[NSString stringWithFormat:@"%@%@%@", @"select codlis,codart,nriga,dtinizio,dtfine,prezzo,sc1,sc2,sc3,sc4 where codart='",_pCodiceArticolo,@"'"];
    
    // Get the results.
    self.tablesource = nil;
    
    self.tablesource = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    [self.tableView reloadData];
    primasincro=false;
    [_spinner stopAnimating];
    
}
- (IBAction)indietro:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (BOOL)prefersStatusBarHidden
 {
 return YES;
 }
@end
