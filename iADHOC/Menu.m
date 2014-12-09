//
//  Menu.m
//  iADHOC
//
//  Created by Mirko Totera on 29/11/14.
//  Copyright (c) 2014 Mirko Totera. All rights reserved.
//

#import "Menu.h"
#import "StrutturaMenu.h"
#import "CellaMenu.h"
#import "Clienti.h"
@interface Menu ()

@end

@implementation Menu {
    NSArray *vocimenu;
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    StrutturaMenu *voce1 = [StrutturaMenu new];
    voce1.voce = @"Clienti";
    StrutturaMenu *voce2 = [StrutturaMenu new];
    voce2.voce = @"Fornitori";
    StrutturaMenu *voce3 = [StrutturaMenu new];
    voce3.voce = @"Articoli";
    StrutturaMenu *voce4 = [StrutturaMenu new];
    voce4.voce = @"Statistiche";
    StrutturaMenu *voce5 = [StrutturaMenu new];
    voce5.voce = @"Sincronizzazoni";
    
    vocimenu = [NSArray arrayWithObjects:voce1, voce2,voce3,voce4,voce5, nil];
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
    return [vocimenu count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ElencoMenu=@"ElencoMenu";
    CellaMenu *cell =(CellaMenu *)[tableView dequeueReusableCellWithIdentifier:ElencoMenu forIndexPath:indexPath];

    
    if(cell==nil) {;
        cell=[[CellaMenu alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ElencoMenu];
    }
    
        StrutturaMenu *menu= [vocimenu objectAtIndex:indexPath.row];
        
        cell.voce.text=menu.voce;
    if ([menu.voce isEqualToString:@"Clienti"]) {
        cell.thumbnailImageView.image = [UIImage imageNamed:@"clienti.png"];

    }
    if ([menu.voce isEqualToString:@"Fornitori"]) {
        cell.thumbnailImageView.image = [UIImage imageNamed:@"fornitori.png"];
    }
    
    if ([menu.voce isEqualToString:@"Articoli"]) {
        cell.thumbnailImageView.image = [UIImage imageNamed:@"Articoli.jpg"];
        
    }
    
    if ([menu.voce isEqualToString:@"Sincronizzazoni"]) {
        cell.thumbnailImageView.image = [UIImage imageNamed:@"Sincro.png"];
        
    }
    
    if ([menu.voce isEqualToString:@"Statistiche"]) {
        cell.thumbnailImageView.image = [UIImage imageNamed:@"statistiche.jpg"];
        
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
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    NSLog(@"%ld",(long)indexPath.row);
    switch (indexPath.row) {
        case 0: [self performSegueWithIdentifier:@"Clienti" sender:self];
            break;
        case 1: [self performSegueWithIdentifier:@"Fornitori" sender:self];
            break;
        case 2: [self performSegueWithIdentifier:@"Articoli" sender:self];
            break;
        case 3: [self performSegueWithIdentifier:@"Statistiche" sender:self];
            break;
        case 4: [self performSegueWithIdentifier:@"Sincro" sender:self];
            break;
        default: break;
    }
   

    }

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    Clienti *Cli=[segue destinationViewController];
 
       

}*/
/*- (BOOL)prefersStatusBarHidden
{
    return YES;
}*/

@end
