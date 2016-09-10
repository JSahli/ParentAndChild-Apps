//
//  Equations.h
//  ParentApp
//
//  Created by Jesse Sahli on 5/20/16.
//  Copyright © 2016 sahlitude. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <math.h>

@interface Equations : NSObject

+(double) distanceInMetersParentY: (double) lat1
                          ParentX: (double) long1
                           ChildY: (double) lat2
                           ChildX: (double) long2;

@end
