//
//  HomeController.m
//  RentMeMVP
//
//  Created by Mizuki Zenta on 9/4/19.
//  Copyright © 2019 Mizuki Zenta. All rights reserved.
//

#import "HomeController.h"
@import Firebase;

@interface HomeController ()
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, atomic) NSMutableArray *postObjectArray;
@end

@implementation HomeController

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
    self.postObjectArray = [NSMutableArray array];
    
    
    self.ref = [[FIRDatabase database] reference];
    
    [[self.ref child:@"Post"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *dict = snapshot.value;
        
        NSArray *keys = [dict allKeys];
        for (int i = 0; i < keys.count; i++)
        {
            id key = keys[i];
            
            // get each attirbutes
            NSDictionary *value = dict[key];
            NSString *title =value[@"title"];
            NSString *category =value[@"category"];
            NSString *image =value[@"image"];
            NSString *description =value[@"description"];
            NSString *userId = value[@"user_id"];
            id cost = value[@"cost"];
            Boolean rented = value[@"rented"];
            NSDate *createAt = [NSDate dateWithTimeIntervalSince1970:([value[@"created_at"] floatValue] / 1000.0)];
            
            // add posts to post object array
            [self.postObjectArray addObject:value];
        }
        NSLog(@"array length: %d", [self.postObjectArray count]);
        // reload the table view with fetched data
        [self.table reloadData];
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
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
