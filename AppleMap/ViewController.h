//
//  ViewController.h
//  AppleMap
//
//  Created by Gordon Kung on 7/20/16.
//  Copyright © 2016 programming_in_objective-c_4th_edition. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "WebViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate>






- (IBAction)setMap:(id)sender;

@end

