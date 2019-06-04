//
//  PostUserDetailController.m
//  RentMeMVP
//
//  Created by Mizuki Zenta on 4/6/19.
//  Copyright © 2019 Mizuki Zenta. All rights reserved.
//

#import "PostUserDetailController.h"

@interface PostUserDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *userNameField;
@property (weak, nonatomic) IBOutlet UILabel *emailField;
@property (weak, nonatomic) IBOutlet UILabel *bioField;
@property (weak, nonatomic) IBOutlet UIImageView *userImageField;

@end

@implementation PostUserDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // set values for each field
    self.userNameField.text = self.userObject[@"userName"];
    self.emailField.text = self.userObject[@"email"];
    self.bioField.text = self.userObject[@"bio"];
    
    // set image
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.userObject[@"image"]]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            self.userImageField.image = [UIImage imageWithData: data];
        });
    });
}

@end
