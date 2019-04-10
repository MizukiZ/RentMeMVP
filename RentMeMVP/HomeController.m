//
//  HomeController.m
//  RentMeMVP
//
//  Created by Mizuki Zenta on 9/4/19.
//  Copyright © 2019 Mizuki Zenta. All rights reserved.
//

#import "HomeController.h"
@import Firebase;

@interface HomeController ()
@end

@implementation HomeController
- (IBAction)LogoutBtn:(id)sender {
    NSError *signOutError;
    BOOL status = [[FIRAuth auth] signOut:&signOutError];
    if (!status) {
        NSLog(@"Error signing out: %@", signOutError);
        return;
    }
}

@end
