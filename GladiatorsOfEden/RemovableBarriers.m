//
//  RemovableBarriers.m
//  GladiatorsOfEden
//
//  Created by Travis Baker on 6/28/12.
//  Copyright 2012 MetalBoyBlue. All rights reserved.
//

#import "RemovableBarriers.h"


@implementation RemovableBarriers

@synthesize mapLayer;
@synthesize isBeingAltered;
@synthesize isBlocked;
@synthesize objectStatus;
@synthesize timeAlterationBegan;
@synthesize worldObjectType;


-(id)initWithLayer:(RegionMapLayer*)theLayer{
    if ((self=[super init])) {
        
        self.mapLayer = theLayer;
        [theLayer addChild:self];
        
        winSize = [[CCDirector sharedDirector] winSize];
        
        //sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@.png",worldObjectType]];
        //[self setSprite];
        
        
    }
    return self;
}

-(void)setSprite{
    NSLog(@"loading sprite with name:%@.png",worldObjectType);
    sprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@.png",worldObjectType]];
    sprite.position = [self.mapLayer.worldObjectsLayer positionAt:CGPointMake(tileXLocation, tileYLocation)];
    //sprite.position = ccp(winSize.width/2, winSize.height/2);
    NSLog(@"TileXLocation:%i  TileYLocation:%i", tileXLocation, tileYLocation);
    NSLog(@"Sprite positioned at x:%f and y:%f", sprite.position.x, sprite.position.y);
    sprite.anchorPoint = ccp(0.5, 0);
    
    sprite.visible = YES;
    [self addChild:sprite z:500];
}
@end
