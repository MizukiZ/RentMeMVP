//
//  AccountViewController.m
//  RentMeMVP
//
//  Created by Mizuki Zenta on 10/5/19.
//  Copyright © 2019 Mizuki Zenta. All rights reserved.
//

#import "AccountViewController.h"
@import Firebase;
@import GooglePlaces;

@interface AccountViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userLocation;
@property (weak, nonatomic) IBOutlet UITextView *userBio;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSDictionary *user;

@end

@implementation AccountViewController{
     GMSAutocompleteFilter *_filter;
}
- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)updateBtn:(id)sender {
 //update button clicked
    
    NSString *userName = self.userName.text;
    NSString *bio = self.userBio.text;
    
    NSDictionary *updateUser = @{@"bio": bio, @"userName": userName};
    
    [[[_ref child:@"Users"] child:[FIRAuth auth].currentUser.uid] updateChildValues:updateUser withCompletionBlock:^(NSError *error, FIRDatabaseReference *ref) {
        if (error) {
            UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Sorry something went wrong!"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil, nil];
            [toast show];
            
            int duration = 1; // duration in seconds
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [toast dismissWithClickedButtonIndex:0 animated:YES];
            });
        } else {
            
            UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Updated successfully!"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil, nil];
            [toast show];
            
            int duration = 1; // duration in seconds
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [toast dismissWithClickedButtonIndex:0 animated:YES];
            });
        }
    }];
    
    
}

- (IBAction)editModeSwitch:(UISwitch *)sender {
    if (sender.on) {
       [self editModeOn];
    } else {
       [self editModeOff];
    }
}

- (void)editModeOn{
    self.userName.enabled = YES;
    self.userLocation.enabled = YES;
    self.userBio.editable = YES;
    self.updateButton.enabled = YES;
}

- (void)editModeOff{
    self.userName.enabled = NO;
    self.userLocation.enabled = NO;
    self.userBio.editable = NO;
    self.updateButton.enabled = NO;
}
- (IBAction)locationClicked:(id)sender {
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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // add style to text view
    self.userBio.layer.borderWidth = 1;
    self.userBio.layer.borderColor = [[UIColor grayColor] CGColor];
    
    // disable text input fields
    [self editModeOff];
    
     self.ref = [[FIRDatabase database] reference];
    
    [[[self.ref child:@"Users"] child:[FIRAuth auth].currentUser.uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        self.user = snapshot.value;
            
            // set post user details
            // set image
            
            // fist set place holder and if there is a user image then overwrite
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.user[@"image"]]];
                if ( data == nil )
                    return;
                dispatch_async(dispatch_get_main_queue(), ^{
                   self.userImage.image = [UIImage imageWithData: data];
                });
            });
            // set name
            self.userName.text = self.user[@"userName"];
        // bio
        self.userBio.text = self.user[@"bio"];
        CLGeocoder *geocoder = [CLGeocoder new];
        
        if(self.user[@"location"] != NULL){
            // reverse giocoding to get user adress from lat and long
            CLLocation *userLocation = [[CLLocation alloc]initWithLatitude: [self.user[@"location"][@"lat"] doubleValue] longitude:[self.user[@"location"][@"lon"] doubleValue]];
            
            [geocoder reverseGeocodeLocation:userLocation
                           completionHandler:^(NSArray *placemarks, NSError *error) {
                               
                               if (error) {
                                   NSLog(@"Geocode failed with error: %@", error);
                                   return; // Request failed, log error
                               }
                               
                               // Check if any placemarks were found
                               if (placemarks && placemarks.count > 0)
                               {
                                   CLPlacemark *placemark = placemarks[0];
                                   
                                   // Dictionary containing address information
                                   NSDictionary *addressDictionary =
                                   placemark.addressDictionary;
                                   
                                   NSString *city = addressDictionary[@"City"];
                                   NSString *country =  addressDictionary[@"Country"];
                                   NSString *location=[NSString stringWithFormat:@"%@ %@",city,country];
                                   self.userLocation.text = location;
                               }
                               
                           }];
            
        }
        
        
        }withCancelBlock:^(NSError * _Nonnull error) {
            NSLog(@"%@", error.localizedDescription);
        }];
}

     
@end
