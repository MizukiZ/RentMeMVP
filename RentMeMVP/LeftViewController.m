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
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }
}

@end
