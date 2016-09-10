//
//  Equations.m
//  ParentApp
//
//  Created by Jesse Sahli on 5/20/16.
//  Copyright © 2016 sahlitude. All rights reserved.
//

#import "Equations.h"
#import <math.h>

@implementation Equations

+(double) distanceInMetersParentY: (double) lat1
                          ParentX: (double) long1
                           ChildY: (double) lat2
                           ChildX: (double) long2{
    
    double radian = M_PI/180;
    
    double dlong = (long2 - long1) * radian;
    double dlat = (lat2 - lat1) * radian;
    double a = pow(sin(dlat/2.0), 2) + cos(lat1*radian) * cos(lat2*radian) * pow(sin(dlong/2.0), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1-a));
    double d = (6367 * c) * 1000;
    
    return d;
}

@end
