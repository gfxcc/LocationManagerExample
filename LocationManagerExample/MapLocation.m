//
//  MapLocation.m
//  LocationManagerExample
//
//  Created by caoyong on 2/4/15.
//  Copyright (c) 2015 Intuit Inc. All rights reserved.
//

#import "MapLocation.h"

@implementation MapLocation

- (NSString *)title {
    return @"Your position!";
}
- (NSString *)subtitle {
    
    NSMutableString *ret = [NSMutableString new];
    if (_state)
        [ret appendString:_state];
    if (_city)
        [ret appendString:_city];
    if (_city && _state)
        [ret appendString:@", "];
    if (_streetAddress && (_city || _state || _zip))
        [ret appendString:@" • "];
    if (_streetAddress)
        [ret appendString:_streetAddress];
    if (_zip)
        [ret appendFormat:@", %@", _zip];
    
    return ret;
}


@end