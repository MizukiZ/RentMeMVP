//
//  LeftViewController.m
//  RentMeMVP
//
//  Created by Mizuki Zenta on 21/4/19.
//  Copyright © 2019 Mizuki Zenta. All rights reserved.
//

#import "LeftViewController.h"
@import Firebase;

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)LogoutBtn:(id)sender {
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Logout"
                                 message:@"Are You Sure Want to Logout?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    //Add Buttons
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    NSError *signOutError;
                                    BOOL status = [[FIRAuth auth] signOut:&signOutError];
                                    if (!status) {
                                        NSLog(@"Error signing out: %@", signOutError);
                                        return;
                                    }
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no process
                                   // do nothing
                               }];
    
    //Add your buttons to alert controller
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
