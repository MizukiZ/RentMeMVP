//
//  EditPostController.m
//  RentMeMVP
//
//  Created by Mizuki Zenta on 6/6/19.
//  Copyright © 2019 Mizuki Zenta. All rights reserved.
//

#import "EditPostController.h"
@import Firebase;

@interface EditPostController ()
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UIPickerView *categoryField;
@property (weak, nonatomic) IBOutlet UITextField *costField;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation EditPostController

- (void)viewDidLoad {
    [super viewDidLoad];
    // get reference of firebase
    self.ref = [[FIRDatabase database] reference];
    
    // add style to text view
    self.descriptionField.layer.borderWidth = 1;
    self.descriptionField.layer.borderColor = [[UIColor grayColor] CGColor];
    
    
}
- (IBAction)backBtn:(id)sender {
      [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)updateBtn:(id)sender {
}
- (IBAction)cameraBtn:(id)sender {
}


@end
