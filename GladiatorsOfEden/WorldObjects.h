//
//  WorldObjects.h
//  GladiatorsOfEden
//
//  Created by Travis Baker on 6/28/12.
//  Copyright (c) 2012 MetalBoyBlue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RegionMap;

@interface WorldObjects : NSManagedObject

@property (nonatomic, retain) NSNumber * isBeingAltered;
@property (nonatomic, retain) NSNumber * isBlocked;
@property (nonatomic, retain) NSNumber * objectStatus;
@property (nonatomic, retain) NSDate * timeAlterationBegan;
@property (nonatomic, retain) NSString * worldObjectType;
@property (nonatomic, retain) NSNumber * tileXLocation;
@property (nonatomic, retain) NSNumber * tileYLocation;
@property (nonatomic, retain) RegionMap *map;

@end
