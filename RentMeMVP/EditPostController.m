//
//  EditPostController.m
//  RentMeMVP
//
//  Created by Mizuki Zenta on 6/6/19.
//  Copyright © 2019 Mizuki Zenta. All rights reserved.
//

#import "EditPostController.h"
#import <SpinKit/RTSpinKitView.h>
@import Firebase;
@import GooglePlaces;

@interface EditPostController ()
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UIPickerView *categoryField;
@property (weak, nonatomic) IBOutlet UITextField *costField;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;

@property (strong, atomic) NSArray *categoriesArray;
@property (atomic) NSString *selectedCategory;


@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation EditPostController{
    GMSAutocompleteFilter *_filter;
     Boolean noCamera;
}
- (IBAction)locationFieldClicked:(id)sender {
    [self autocompleteClicked];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // get reference of firebase
    self.ref = [[FIRDatabase database] reference];
    
    // set category array
    self.categoriesArray = @[@"Sport", @"Appliance",@"Instrument",@"Clothe",@"Tool",@"Ride"];
    // set default selected caterogyr
    self.selectedCategory = self.postObject[@"category"];
    
    // setting for picker UI
    self.categoryField.delegate = self;
    self.categoryField.dataSource = self;
    
    // set default value for the category picker
    [self.categoryField selectRow:[_categoriesArray indexOfObject:_selectedCategory] inComponent:0 animated:YES];
    
    noCamera = false;
    // when a device does not have a camera show warning
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        noCamera = true;
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"No camera is detected!"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
    // add style to text view
    self.descriptionField.layer.borderWidth = 1;
    self.descriptionField.layer.borderColor = [[UIColor grayColor] CGColor];
    
    
    //set value to each field
    self.titleField.text = self.postObject[@"title"];
     self.descriptionField.text = self.postObject[@"description"];
    
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
    
    // set cost
    id cost = self.postObject[@"cost"];
    NSString *costS = [NSString stringWithFormat:@"%@", cost];
    self.costField.text = costS;
    
    // set location
   CLGeocoder *geocoder = [CLGeocoder new];
        // reverse giocoding to get user adress from lat and long
        CLLocation *postLocation = [[CLLocation alloc]initWithLatitude: [self.postObject[@"location"][@"lat"] doubleValue] longitude:[self.postObject[@"location"][@"lon"] doubleValue]];
        
        [geocoder reverseGeocodeLocation:postLocation
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
                               NSString *location=[NSString stringWithFormat:@"%@, %@",city,country];
                               self.locationField.text = location;
                           }
                           
                       }];
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

- (IBAction)backBtn:(id)sender {
      [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cameraBtn:(id)sender {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        // show Dialog to choose between take a photo or pick up image from device
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Image upload"
                                     message:@"Please choose a mothod for uploading your image."
                                     preferredStyle:UIAlertControllerStyleAlert];
        //Add Buttons
        UIAlertAction* libraryButton = [UIAlertAction
                                        actionWithTitle:@"Photo library"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                            [self presentViewController:picker animated:YES completion:NULL];
                                        }];
        
        UIAlertAction* takePhotoButton = [UIAlertAction
                                          actionWithTitle:@"Take a photo"
                                          style:UIAlertActionStyleDefault
                                          handler:^(UIAlertAction * action) {
                                              picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                              [self presentViewController:picker animated:YES completion:NULL];
                                          }];
        
        UIAlertAction* cancelButton = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           // do nothing
                                       }];
        
        //Add your buttons to alert controller
        [alert addAction:libraryButton];
        if(!noCamera){
            // if there is a camera on the device, add this option
            [alert addAction:takePhotoButton];
        }
        [alert addAction:cancelButton];
        
        [self presentViewController:alert animated:YES completion:nil];
}

// after user takes a image or choose an image, this callback is triggered
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.postImageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
// when user cancel the image picker view, this callback is triggered
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)updateBtn:(id)sender {
    // Get a reference to the storage service using the default Firebase App
    FIRStorage *storage = [FIRStorage storage];
    // Create a storage reference from our storage service
    FIRStorageReference *storageRef = [storage reference];
    
    // get values from field
    NSString *title = self.titleField.text;
    double cost = [self.costField.text doubleValue];
    NSString *description = self.descriptionField.text;
    
    // #########    the location info is hard coded due to the change of google api price plan    ##########
    NSDictionary *locationObject = [NSDictionary dictionaryWithObjectsAndKeys: @(-37.8104277),@"lat",@(144.9629153),@"lon" , nil];
    
    
    
    // Generate a data from the image selected
    NSData *imageData = UIImageJPEGRepresentation(self.postImageView.image, 0.8);
    
    //set required field valiation
    if(!title || !cost || !self.postImageView.image || !description){
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        // show Dialog to ask for filling every field from submit form
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Error"
                                     message:@"Please fill every filed including a image"
                                     preferredStyle:UIAlertControllerStyleAlert];
        //Add Buttons
        UIAlertAction* okButton = [UIAlertAction
                                   actionWithTitle:@"Ok"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       // do noting
                                   }];
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
        // set loading icon
        RTSpinKitView *spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleWave];
        spinner.spinnerSize = 60;
        spinner.center = CGPointMake(self.view.frame.size.width  / 2,
                                     self.view.frame.size.height / 2);
        [self.view addSubview:spinner];
        
        // directory ref
        NSString *dir = @"ItemImages/";
        // unique id for the image
        NSString *uuid = [[NSUUID UUID] UUIDString];
        FIRStorageReference *itemImageRef = [storageRef child:[dir stringByAppendingString:uuid]];
        // Create the file metadata
        FIRStorageMetadata *imageMetadata = [[FIRStorageMetadata alloc] init];
        imageMetadata.contentType = @"image/jpeg";
        
        
        // Upload the file to the path "images/rivers.jpg"
        FIRStorageUploadTask *uploadTask = [itemImageRef putData:imageData
                                                        metadata:imageMetadata
                                                      completion:^(FIRStorageMetadata *metadata,
                                                                   NSError *error) {
                                                          if (error != nil) {
                                                              // Uh-oh, an error occurred!
                                                          } else {
                                                              // Metadata contains file metadata such as size, content-type, and download URL.
                                                              int size = metadata.size;
                                                              // You can also access to download URL after upload.
                                                              [itemImageRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                                                                  if (error != nil) {
                                                                      // Uh-oh, an error occurred!
                                                                  } else {
                                                                      // get downloadURL
                                                                      NSString *downloadURL = [URL absoluteString];
                                                                      
                                                                      
                                                                      // location update is diabled due to the google api pricing change
                                                                      NSDictionary *post = @{@"title": title, @"cost": @(cost), @"description": description, @"category": self.selectedCategory, @"image": downloadURL};
                                                                      
                                                                      // dissmiss the loading icon
                                                                      [spinner stopAnimating];
                                                                      
                                                                      // update value to firebase database
                                                                      [[[self->_ref child:@"Post"] child:self.postObject[@"id"]] updateChildValues:post withCompletionBlock:^(NSError *error, FIRDatabaseReference *ref) {
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
                                                                              
                                                                              // dismiss itself view
                                                                              [self dismissViewControllerAnimated:YES completion:nil];
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
                                                                              
                                                                              // dismiss itself view
                                                                              [self dismissViewControllerAnimated:YES completion:nil];
                                                                          }
                                                                      }];
                                                                      
                                                                  }
                                                              }];
                                                          }
                                                      }];
        
    }
}


@end
