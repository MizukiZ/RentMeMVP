//
//  NewPostController.m
//  RentMeMVP
//
//  Created by Mizuki Zenta on 13/4/19.
//  Copyright © 2019 Mizuki Zenta. All rights reserved.
//

#import "NewPostController.h"
@import GooglePlaces;

@import Firebase;

@interface NewPostController()
@property (weak, nonatomic) IBOutlet UITextField *postTitleField;
@property (weak, nonatomic) IBOutlet UITextField *postCostField;
@property (weak, nonatomic) IBOutlet UITextView *postDescriptionField;
@property (weak, nonatomic) IBOutlet UIPickerView *postCategoryField;
@property (weak, nonatomic) IBOutlet UITextField *postLocationField;

@property (strong, atomic) NSArray *categoriesArray;
@property (atomic) NSString *selectedCategory;

@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation NewPostController{
    GMSAutocompleteFilter *_filter;
}
- (IBAction)locationFieldClicked:(id)sender {
     [self autocompleteClicked];
}

// Present the autocomplete view controller when the button is pressed.
- (void)autocompleteClicked {
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    
    // Specify the place data types to return.
    GMSPlaceField fields = (GMSPlaceFieldName | GMSPlaceFieldPlaceID);
    acController.placeFields = fields;
    
    // Specify a filter.
    _filter = [[GMSAutocompleteFilter alloc] init];
    _filter.type = kGMSPlacesAutocompleteTypeFilterAddress;
    acController.autocompleteFilter = _filter;
    
    // Display the autocomplete view controller.
    [self presentViewController:acController animated:YES completion:nil];
}

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    
    // ###### at the moment this function is disabled since there is a need to creat billing account for Google API #######
//    NSLog(@"Place name %@", place.name);
//    NSLog(@"Place ID %@", place.placeID);
//    NSLog(@"Place attributions %@", place.attributions.string);
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Turn the network activity indicator on and off again.
- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

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
    
    // #########    the location info is hard coded due to the change of google api price plan    ##########
    NSDictionary *locationObject = [NSDictionary dictionaryWithObjectsAndKeys:@"lat", @"-37.8104277", @"lon", @"144.9629153", nil];
    
    
    NSDictionary *post = @{@"title": title, @"cost": @(cost), @"descrirption": descrirption, @"category": self.selectedCategory, @"location": locationObject};
    
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
