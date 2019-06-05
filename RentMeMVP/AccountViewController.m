//
//  AccountViewController.m
//  RentMeMVP
//
//  Created by Mizuki Zenta on 10/5/19.
//  Copyright © 2019 Mizuki Zenta. All rights reserved.
//

#import "AccountViewController.h"
@import Firebase;


@interface AccountViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userLocation;
@property (weak, nonatomic) IBOutlet UITextView *userBio;
@property (strong, nonatomic) FIRDatabaseReference *ref;
@property (strong, nonatomic) NSDictionary *user;
@end

@implementation AccountViewController
- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
}

- (void)editModeOff{
    self.userName.enabled = NO;
    self.userLocation.enabled = NO;
    self.userBio.editable = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
        NSLog(@"user lat is %@", self.user[@"location"][@"lat"]);
        CLGeocoder *geocoder = [CLGeocoder new];
        
        
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
        
        
            
            
        }withCancelBlock:^(NSError * _Nonnull error) {
            NSLog(@"%@", error.localizedDescription);
        }];
}

     
@end
