//
//  PostDetailController.m
//  RentMeMVP
//
//  Created by Mizuki Zenta on 13/4/19.
//  Copyright © 2019 Mizuki Zenta. All rights reserved.
//

#import "PostDetailController.h"
#import "PostMapController.h"
@import Firebase;


@interface PostDetailController()
@property (weak, nonatomic) IBOutlet UILabel *postTitleView;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *postCreatedAtView;
@property (weak, nonatomic) IBOutlet UITextView *postDescriptionView;
@property (weak, nonatomic) IBOutlet UILabel *postCostView;
@property (weak, nonatomic) IBOutlet UIImageView *postUserImage;
@property (weak, nonatomic) IBOutlet UILabel *postUserName;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSDictionary *postUser;
@end

@implementation PostDetailController

- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad{
    
    // gte user information based on the passed post user id
     self.ref = [[FIRDatabase database] reference];
    
    [[[self.ref child:@"Users"] child:self.postObject[@"user_id"]] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        self.postUser = snapshot.value;
        
        // set post user details
        // set image
        
        // fist set place holder and if there is a user image then overwrite
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.postUser[@"image"]]];
            if ( data == nil )
                return;
            dispatch_async(dispatch_get_main_queue(), ^{
                // WARNING: is the cell still using the same data by this point??
                self.postUserImage.image = [UIImage imageWithData: data];
            });
        });
        // set name
        self.postUserName.text = self.postUser[@"userName"];
        
        
    }withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
    
    // set passed object value to each field
    // set title
    self.postTitleView.text = self.postObject[@"title"];
    
    // set image
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.postObject[@"image"]]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            self.postImageView.image = [UIImage imageWithData: data];
        });
    });
    
    // set posted date
    NSDate *createAt = [NSDate dateWithTimeIntervalSince1970:([self.postObject[@"created_at"] floatValue] / 1000.0)];
    // set custom format for NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd-MM-yyyy";
    NSString *dateString = [dateFormatter stringFromDate:createAt];
    
    self.postCreatedAtView.text = dateString;
    
    // set description
    self.postDescriptionView.text = self.postObject[@"description"];
    
    // set cost
    id cost = self.postObject[@"cost"];
    NSString *costS = [NSString stringWithFormat:@"%@", cost];
    NSString *dollar = @"$/night";
    NSString *costSentence = [costS stringByAppendingString:dollar];
    self.postCostView.text = costSentence;
}

// set event for segue to pass post object
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"postMap"]) {
        PostMapController *mapVC = [segue destinationViewController];

        // path selected sections object to post detail view
        mapVC.locationObject = self.postObject[@"location"];
    }
}
@end
