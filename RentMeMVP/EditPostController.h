//
//  EditPostController.h
//  RentMeMVP
//
//  Created by Mizuki Zenta on 6/6/19.
//  Copyright © 2019 Mizuki Zenta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


NS_ASSUME_NONNULL_BEGIN

@interface EditPostController : UIViewController<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property(strong,nonatomic) NSDictionary *postObject;
@end

NS_ASSUME_NONNULL_END
