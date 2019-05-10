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
@property (weak, nonatomic) IBOutlet UITextView *postDescriptionField;
@property (weak, nonatomic) IBOutlet UIPickerView *postCategoryField;

@property (strong, atomic) NSArray *categoriesArray;
@property (atomic) NSString *selectedCategory;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation NewPostController
- (IBAction)backBtn:(id)sender { 
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)cameraBtn:(id)sender {
}

- (IBAction)postBtn:(id)sender {
   // get values from field
    NSString *title = self.postTitleField.text;
    float cost = [self.postCostField.text floatValue];
    NSString *descrirption = self.postDescriptionField.text;
    
    
    
    NSDictionary *post = @{@"title": title, @"cost": @(cost), @"descrirption": descrirption, @"category": self.selectedCategory};
    
    NSLog(@"Post data is: %@", post);
    
    
    // send value to firebase database
//    [[self.ref child:@"posts"] setValue:post];
}

- (void)viewDidLoad{
    // get reference of firebase
    self.ref = [[FIRDatabase database] reference];
    
//      customize a borderline of description field
     self.postDescriptionField.layer.borderWidth = 0.5f;
     self.postDescriptionField.layer.borderColor = [[UIColor grayColor] CGColor];
    
    // set category array
    self.categoriesArray = @[@"Sport", @"Appliance",@"Instrument",@"Clothe",@"Tool",@"Ride"];
    
    // setting for picker UI
    self.postCategoryField.delegate = self;
    self.postCategoryField.dataSource = self;

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.categoriesArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *titleRow;
    titleRow = [NSString stringWithFormat:@"%@", [self.categoriesArray objectAtIndex:row]];
    return titleRow;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // here you can remember the selected row or perform some action
    self.selectedCategory = self.categoriesArray[row];
}
@end
