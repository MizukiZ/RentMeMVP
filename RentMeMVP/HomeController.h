//
//  HomeController.h
//  RentMeMVP
//
//  Created by Mizuki Zenta on 9/4/19.
//  Copyright © 2019 Mizuki Zenta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property IBOutlet UITableView *table;
@end
