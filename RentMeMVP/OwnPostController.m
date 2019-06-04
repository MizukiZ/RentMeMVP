//
//  OwnPostController.m
//  RentMeMVP
//
//  Created by Mizuki Zenta on 10/5/19.
//  Copyright © 2019 Mizuki Zenta. All rights reserved.
//

#import "OwnPostController.h"
#import "PostDetailController.h"
@import Firebase;


@interface OwnPostController ()
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, atomic) NSMutableArray *postObjectArray;
@end

@implementation OwnPostController
- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.table.estimatedRowHeight = 80;
    self.table.rowHeight = UITableViewAutomaticDimension;
    
    self.ref = [[FIRDatabase database] reference];
    self.postObjectArray = [NSMutableArray array];
    
    [[[[self.ref child:@"Post"]queryOrderedByChild:@"user_id"] queryEqualToValue:[FIRAuth auth].currentUser.uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
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
        
         NSLog(@"post array %@", self.postObjectArray);
        // reload the table view with fetched data
        [self.table reloadData];
    }withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}

- (BOOL)allowsHeaderViewsToFloat{
    return NO;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.postObjectArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height = 80.0f;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"tableCell";
    
    
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:3];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.postObjectArray[indexPath.row][@"image"]]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            imageView.image = [UIImage imageWithData: data];
        });
    });
    
    // set title to a label
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    titleLabel.text = self.postObjectArray[indexPath.row][@"title"];
    
    
    // set cost to a label
    id cost = self.postObjectArray[indexPath.row][@"cost"];
    UILabel *costLabel = (UILabel *)[cell viewWithTag:2];
    NSString *costS = [NSString stringWithFormat:@"%@", cost];
    NSString *dollar = @"$/night";
    NSString *costSentence = [costS stringByAppendingString:dollar];
    costLabel.text = costSentence;
    
    return cell;
}

@end
