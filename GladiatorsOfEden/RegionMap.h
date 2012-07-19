//
//  RegionMap.h
//  GladiatorsOfEden
//
//  Created by Travis Baker on 6/27/12.
//  Copyright (c) 2012 MetalBoyBlue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WorldObjects;

@interface RegionMap : NSManagedObject

@property (nonatomic, retain) NSString * regionName;
@property (nonatomic, retain) NSSet *objects;
@end

@interface RegionMap (CoreDataGeneratedAccessors)

- (void)addObjectsObject:(WorldObjects *)value;
- (void)removeObjectsObject:(WorldObjects *)value;
- (void)addObjects:(NSSet *)values;
- (void)removeObjects:(NSSet *)values;

@end
