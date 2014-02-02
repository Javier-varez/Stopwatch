//
//  Time.m
//  Timer
//
//  Created by Francisco Javier Álvarez García on 03/01/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import "Time.h"
#import "Observation.h"


@implementation Time

@dynamic name;
@dynamic time;
@dynamic date;
@dynamic linkedObservation;

- (NSComparisonResult)compare:(Time *)otherObject {
    return [self.date compare:otherObject.date];
}

@end
