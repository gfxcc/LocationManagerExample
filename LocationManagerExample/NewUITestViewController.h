//
//  NewUITestViewController.h
//  LocationManagerExample
//
//  Created by caoyong on 2/6/15.
//  Copyright (c) 2015 Intuit Inc. All rights reserved.
//

#import "Inf.h"
#import "MapLocation.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <QuartzCore/QuartzCore.h>

@interface NewUITestViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end
