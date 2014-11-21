//
//  Articoli.m
//  iADHOC
//
//  Created by Mirko Totera on 21/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import "Articoli.h"
#import "SQLClient.h"
#import "ANAART.h"
#import "ZoomArti.h"
#import "DBmanager.h"


@interface Articoli ()
@property (strong,nonatomic) DBmanager *dbManager;
@end

@implementation Articoli {
    
    BOOL primasincro;
    BOOL finecaricamento;

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
     finecaricamento=false;
    AppDelegate *mainDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];

    if (mainDelegate.OnlineId.boolValue==1) {
        NSString *SQLState=[NSString stringWithFormat:@"%@%@%@%@",@"SELECT ARCODART, ARDESART,ARDESSUP,ARUNMIS1, ARMOLTIP, ARGRUMER, ARCODFAM, ARTIPART FROM dbo.",mainDelegate.AziendaId,@"ART_ICOL ",@"where ARTIPART='PF' order by ARCODART"];
        [self EstrapolaDati:SQLState];
        
    }
    else {
        
        self.dbManager = [[DBmanager alloc] initWithDatabaseFilename:@"AHR.sqlite"];
        NSString *query = @"select ARCODART, ARDESART,ARDESSUP,ARUNMIS1,ARMOLTIP, ARGRUMER, ARCODFAM, ARTIPART from articoli where ARTIPART='PF' ";
        
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
    
    static NSString *ZoomArticoli=@"ZoomArticoli";
    ZoomArti *cell =(ZoomArti *)[tableView dequeueReusableCellWithIdentifier:ZoomArticoli forIndexPath:indexPath];
    
    if(cell==nil) {;
        cell=[[ZoomArti alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ZoomArticoli];
    }
    if (mainDelegate.OnlineId.boolValue==1) {
        ANAART *articoli= [self.tablesource objectAtIndex:indexPath.row];
        
        cell.codice.text=articoli.arcodice;
        cell.descrizione.text=articoli.ardescri;
        cell.supplementare.text=articoli.ardessup;
        cell.unimis.text=articoli.arunmis1;
        cell.armoltip.text=articoli.armoltip;
    } else {
        
        
        NSInteger indexOfcodice = [self.dbManager.arrColumnNames indexOfObject:@"ARCODART"];
       // NSLog(@"@%ld",(long)indexOfcodice);
        NSInteger indexOfdesart = 1;
        NSInteger indexOfdessup = 2;
        NSInteger indexOfunimis = 3;
        NSInteger indexOfmoltip=4;
        // Set the loaded data to the appropriate cell labels.
        cell.codice.text = [NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:indexPath.row] objectAtIndex:indexOfcodice]];
       // NSLog(@"%@",[[self.tablesource objectAtIndex:indexPath.row] objectAtIndex:3]);
        cell.descrizione.text = [NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:indexPath.row] objectAtIndex:indexOfdesart]];
        cell.supplementare.text = [NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:indexPath.row] objectAtIndex:indexOfdessup]];
        
        cell.unimis.text = [NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:indexPath.row] objectAtIndex:indexOfunimis]];
        
        cell.armoltip.text = [NSString stringWithFormat:@"%@", [[self.tablesource objectAtIndex:indexPath.row] objectAtIndex:indexOfmoltip]];

        
        
        
        
        
        
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
            ANAART *ANAGRAFICA=[[ANAART alloc]init];
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
    
    
    self.tablesource=tbsource;
    if (primasincro==true) {
        [self salvaclientisqlite];
    }
    else {
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
        
        NSString *SQLState=[NSString stringWithFormat:@"%@%@%@%@",@"SELECT ARCODART,ARDESART, ARDESSUP,ARUNMIS1,ARMOLTIP,ARGRUMER,ARCODFAM,ARTIPART FROM dbo.",mainDelegate.AziendaId,@"ART_ICOL where ARTIPART='PF'",@"order by ARCODART"];
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
        
        ANAART *articoli=[[ANAART alloc]init];
        articoli=[_tablesource objectAtIndex:i];
        
        NSString *query = [NSString stringWithFormat:@"insert into articoli values('%@','%@','%@','%@', '%@','%@','%@','%@')",articoli.arcodice,articoli.ardescri,articoli.ardessup,articoli.arunmis1,articoli.armoltip,articoli.argrumer,articoli.arcodfam,articoli.artipart ];
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
    NSString *query = @"select ARCODART,ARDESART,ARDESSUP,ARUNMIS1,ARMOLTIP,ARGRUMER,ARCODFAM,ARTIPART from articoli where ARTIPART='PF'";
    
    // Get the results.
    self.tablesource = nil;
    
    self.tablesource = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    [self.tableView reloadData];
    primasincro=false;
    [_spinner stopAnimating];
    
}

@end
