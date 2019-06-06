//
//  ViewController.m
//  RentMeMVP
//
//  Created by Mizuki Zenta on 9/4/19.
//  Copyright © 2019 Mizuki Zenta. All rights reserved.
//

#import "ViewController.h"
@import Firebase;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameInput;
@property (weak, nonatomic) IBOutlet UITextField *emailInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@end

@implementation ViewController

- (IBAction)registerBtn:(id)sender {


    NSString *email = self.emailInput.text;
    NSString *password = self.passwordInput.text;
    NSString *userName = self.nameInput.text;
    
    [[FIRAuth auth] createUserWithEmail:email
                               password:password
                             completion:^(FIRAuthDataResult * _Nullable authResult,
                                          NSError * _Nullable error) {
                                 if(authResult){
                                     
                                      // create new user with registerd infomation
                                     NSDictionary *newUser = @{@"email": email, @"password": password, @"userName": userName};
                                     
                                     NSString *id = [FIRAuth auth].currentUser.uid;
                                     // send value to firebase database
                                     [[[[[FIRDatabase database] reference] child:@"Users"] child:id] setValue:newUser];
                                     
                                     // create an account successfully
                                     [[FIRAuth auth] signInWithEmail:email
                                                            password:password
                                                          completion:^(FIRAuthDataResult * _Nullable authResult,
                                                                       NSError * _Nullable error) {
                                                              
                                                              UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                                                              message:@"Register and logged in successfully"
                                                                                                             delegate:nil
                                                                                                    cancelButtonTitle:nil
                                                                                                    otherButtonTitles:nil, nil];
                                                              [toast show];
                                                              
                                                              int duration = 2; // duration in seconds
                                                              
                                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                                  [toast dismissWithClickedButtonIndex:0 animated:YES];
                                                              });
                                                              
                                                          }];
                                 }else{
                                     UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                                     message:error.localizedDescription
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


@end
