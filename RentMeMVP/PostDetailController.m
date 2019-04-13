//
//  PostDetailController.m
//  RentMeMVP
//
//  Created by Mizuki Zenta on 13/4/19.
//  Copyright © 2019 Mizuki Zenta. All rights reserved.
//

#import "PostDetailController.h"

@interface PostDetailController()
@property (weak, nonatomic) IBOutlet UILabel *postTitle;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;

@end

@implementation PostDetailController

- (void)viewDidLoad{
    NSLog(@"received: %@", self.postObject[@"title"]);
    
    // set passed object value to each field
    self.postTitle.text = self.postObject[@"title"];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: self.postObject[@"image"]]];
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            // WARNING: is the cell still using the same data by this point??
            self.postImageView.image = [UIImage imageWithData: data];
        });
    });
}

@end
