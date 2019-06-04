//
//  PostUserDetailController.h
//  RentMeMVP
//
//  Created by Mizuki Zenta on 4/6/19.
//  Copyright © 2019 Mizuki Zenta. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostUserDetailController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property(strong,nonatomic) NSDictionary *userObject;
@property IBOutlet UITableView *table;

@end

NS_ASSUME_NONNULL_END
