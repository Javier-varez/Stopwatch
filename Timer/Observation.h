//
//  Observation.h
//  Timer
//
//  Created by Francisco Javier Álvarez García on 03/01/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Observation : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *timesForObservation;
@end

@interface Observation (CoreDataGeneratedAccessors)

- (void)addTimesForObservationObject:(NSManagedObject *)value;
- (void)removeTimesForObservationObject:(NSManagedObject *)value;
- (void)addTimesForObservation:(NSSet *)values;
- (void)removeTimesForObservation:(NSSet *)values;

@end
