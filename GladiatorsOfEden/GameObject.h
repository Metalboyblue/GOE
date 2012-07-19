//
//  GameObject.h
//  GladiatorsOfEden
//
//  Created by Travis Baker on 7/3/12.
//  Copyright 2012 MetalBoyBlue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameObject : CCNode {
    CGSize winSize;
    CCSprite* sprite;
    int tileXLocation;
    int tileYLocation;
}

@property (nonatomic) int tileXLocation;
@property (nonatomic) int tileYLocation;
@property (nonatomic, retain) CCSprite* sprite;

-(void)touched;
-(void)updateVertexZ:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap;

@end
