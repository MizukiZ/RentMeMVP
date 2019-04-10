//
//  LoginController.m
//  RentMeMVP
//
//  Created by Mizuki Zenta on 9/4/19.
//  Copyright © 2019 Mizuki Zenta. All rights reserved.
//

#import "LoginController.h"
#import "HomeController.h"
@import Firebase;

@interface LoginController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UITextField *emailInput;
@property (weak, nonatomic) NSString *message;
@end

@implementation LoginController



- (IBAction)loginBtn:(id)sender {

    NSString *email = self.emailInput.text;
    NSString *passowrd = self.passwordInput.text;

    [[FIRAuth auth] signInWithEmail:email
                           password:passowrd
                         completion:^(FIRAuthDataResult * _Nullable authResult,
                                      NSError * _Nullable error) {
                             if(authResult){
                                 // validation success
                                 self.message = @"Logged in successfully";
                             }else{
                                 // validation fail
                                 self.message = error.localizedDescription;
                             }

                             UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                             message:_message
                                                                            delegate:nil
                                                                   cancelButtonTitle:nil
                                                                   otherButtonTitles:nil, nil];
                             [toast show];

                             int duration = 1; // duration in seconds

                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                 [toast dismissWithClickedButtonIndex:0 animated:YES];
                             });
                         }];

}

@end
