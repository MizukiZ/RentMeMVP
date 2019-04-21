//
//  PostMap.m
//  RentMeMVP
//
//  Created by Mizuki Zenta on 21/4/19.
//  Copyright © 2019 Mizuki Zenta. All rights reserved.
//

#import "PostMapController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface PostMapController()

@end

@implementation PostMapController

- (void)loadView {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:13];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView;
}
@end
