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
@property (strong, nonatomic) FIRDatabaseReference *ref;
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

- (void)viewDidLoad{
    self.ref = [[FIRDatabase database] reference];
    
    [[self.ref child:@"Post"] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSDictionary *dict = snapshot.value;
        NSLog(@"##########################%@",dict);
        
    } withCancelBlock:^(NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
    }];
}
@end
