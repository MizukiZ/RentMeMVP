//
//  HomeController.m
//  RentMeMVP
//
//  Created by Mizuki Zenta on 9/4/19.
//  Copyright © 2019 Mizuki Zenta. All rights reserved.
//

#import "HomeController.h"
#import "PostDetailController.h"
#import "AppDelegate.h"
@import Firebase;

@interface HomeController ()
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, atomic) NSMutableArray *postObjectArray;

-(void)updateListWithCategory:(NSString *)category;
@end

@implementation HomeController
- (IBAction)menuBtn:(id)sender {
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    [app.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)updateListWithCategory:(NSString *)category{
    // initialize object array
    self.postObjectArray = [NSMutableArray array];
    self.ref = [[FIRDatabase database] reference];
    
    if(category == @"All"){
        [[self.ref child:@"Post"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSDictionary *dict = snapshot.value;
            
            NSArray *keys = [dict allKeys];
            for (int i = 0; i < keys.count; i++)
            {
                id key = keys[i];
                // get each attirbutes
                NSDictionary *value = dict[key];
                
                // add posts to post object array
                [self.postObjectArray addObject:value];
            }
            
            // reload the table view with fetched data
            [self.table reloadData];
        }withCancelBlock:^(NSError * _Nonnull error) {
            NSLog(@"%@", error.localizedDescription);
        }];
    }else{
        [[[[self.ref child:@"Post"] queryOrderedByChild:@"category"] queryEqualToValue:category] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSDictionary *dict = snapshot.value;
            
            NSArray *keys = [dict allKeys];
            for (int i = 0; i < keys.count; i++)
            {
                id key = keys[i];
                // get each attirbutes
                NSDictionary *value = dict[key];
                
                // add posts to post object array
                [self.postObjectArray addObject:value];
            }
            
            // reload the table view with fetched data
            [self.table reloadData];
        }withCancelBlock:^(NSError * _Nonnull error) {
            NSLog(@"%@", error.localizedDescription);
        }];
    }
    
}

- (IBAction)categorySportsBtn:(id)sender {
    [self updateListWithCategory:@"Sport"];
}
- (IBAction)categoryAppliancesBtn:(id)sender {
     [self updateListWithCategory:@"Appliance"];
}
- (IBAction)categoryInstrumentsBtn:(id)sender {
     [self updateListWithCategory:@"Instrument"];
}
- (IBAction)categoryClothesBtn:(id)sender {
     [self updateListWithCategory:@"Clothe"];
}
- (IBAction)categoryToolsBtn:(id)sender {
     [self updateListWithCategory:@"Tool"];
}
- (IBAction)categoryRideBtn:(id)sender {
     [self updateListWithCategory:@"Ride"];
}
- (IBAction)resetCategoryBtn:(id)sender {
    [self updateListWithCategory:@"All"];
}

- (IBAction)LogoutBtn:(id)sender {
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self updateListWithCategory:@"All"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.postObjectArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //where indexPath.row is the selected cell
    NSLog(@"Clicked item title: %@", self.postObjectArray[indexPath.section][@"title"]);
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}


// set event for segue to pass post object
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        // get index path
        NSIndexPath *selectedIndexPath = [self.table indexPathForSelectedRow];
        
        PostDetailController *nextVC = [segue destinationViewController];
        
        // path selected sections object to post detail view
        nextVC.postObject = self.postObjectArray[selectedIndexPath.section];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"tableCell";

    
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // add border and color
    cell.backgroundColor = UIColor.whiteColor;
    cell.layer.borderWidth = 1;
    cell.layer.cornerRadius = 3;
    cell.clipsToBounds = true;
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:3];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.postObjectArray[indexPath.section][@"image"]]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            imageView.image = [UIImage imageWithData: data];
        });
    });
    
    // set title to a label
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    titleLabel.text = self.postObjectArray[indexPath.section][@"title"];
    
    
    // set cost to a label
    id cost = self.postObjectArray[indexPath.section][@"cost"];
    UILabel *costLabel = (UILabel *)[cell viewWithTag:2];
    NSString *costS = [NSString stringWithFormat:@"%@", cost];
    NSString *dollar = @"$/night";
    NSString *costSentence = [costS stringByAppendingString:dollar];
    costLabel.text = costSentence;
   
    return cell;
}
@end
