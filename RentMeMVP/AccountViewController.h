//
//  AccountViewController.h
//  RentMeMVP
//
//  Created by Mizuki Zenta on 10/5/19.
//  Copyright © 2019 Mizuki Zenta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AccountViewController : UIViewController<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

NS_ASSUME_NONNULL_END
