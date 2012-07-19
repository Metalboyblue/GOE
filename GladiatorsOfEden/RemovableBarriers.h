//
//  RemovableBarriers.h
//  GladiatorsOfEden
//
//  Created by Travis Baker on 6/28/12.
//  Copyright 2012 MetalBoyBlue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "RegionMapScene.h"
#import "GameObject.h"

@class RegionMapLayer;

@interface RemovableBarriers : GameObject {
  
}

@property(nonatomic, retain) RegionMapLayer *mapLayer;

@property (nonatomic) bool isBeingAltered;
@property (nonatomic) bool isBlocked;
@property (nonatomic) int objectStatus;
@property (nonatomic, retain) NSDate * timeAlterationBegan;
@property (nonatomic, retain) NSString* worldObjectType;



-(id)initWithLayer:(RegionMapLayer*)theLayer;
-(void)setSprite;

@end
