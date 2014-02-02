//
//  Time.h
//  Timer
//
//  Created by Francisco Javier Álvarez García on 03/01/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Observation;

@interface Time : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Observation *linkedObservation;

- (NSComparisonResult)compare:(Time *)otherObject;

@end
