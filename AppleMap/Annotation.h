//
//  Annotation.h
//  AppleMap
//
//  Created by Gordon Kung on 7/20/16.
//  Copyright © 2016 programming_in_objective-c_4th_edition. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *subtitle;

@property (nonatomic, strong) NSString *urlString;

@end
