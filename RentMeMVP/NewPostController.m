//
//  NewPostController.m
//  RentMeMVP
//
//  Created by Mizuki Zenta on 13/4/19.
//  Copyright © 2019 Mizuki Zenta. All rights reserved.
//

#import "NewPostController.h"
@import Firebase;

@interface NewPostController()
@property (weak, nonatomic) IBOutlet UITextField *postTitleField;
@property (weak, nonatomic) IBOutlet UITextField *postCostField;

@property (weak, nonatomic) IBOutlet UITextField *postDescriptionField;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation NewPostController

- (IBAction)postBtn:(id)sender {
   // get values from field
    NSString *title = self.postTitleField.text;
    float cost = [self.postCostField.text floatValue];
    NSString *descrirption = self.postDescriptionField.text;
    
    NSDictionary *post = @{@"title": title, @"cost": @(cost), @"descrirption": descrirption};
    
    
    // send value to firebase database
//    [[self.ref child:@"posts"] setValue:post];
}

- (void)viewDidLoad{
    // get reference of firebase
    self.ref = [[FIRDatabase database] reference];
}
@end
