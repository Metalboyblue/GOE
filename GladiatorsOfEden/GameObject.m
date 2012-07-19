//
//  GameObject.m
//  GladiatorsOfEden
//
//  Created by Travis Baker on 7/3/12.
//  Copyright 2012 MetalBoyBlue. All rights reserved.
//

#import "GameObject.h"


@implementation GameObject

@synthesize tileXLocation;
@synthesize tileYLocation;
@synthesize sprite = _sprite;


-(void)touched{
    NSLog(@"touched");
    
    [sprite setOpacity:1.0];
    CCFadeTo *fadeIn = [CCFadeTo actionWithDuration:0.5 opacity:127];
    CCFadeTo *fadeOut = [CCFadeTo actionWithDuration:0.5 opacity:255];
    
    CCSequence *pulseSequence = [CCSequence actionOne:fadeIn two:fadeOut];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:pulseSequence];
    [sprite runAction:repeat];

}

-(void)updateVertexZ:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap{
    float lowestZ = -(tileMap.mapSize.width + tileMap.mapSize.height);
    float currentZ = tilePos.x + tilePos.y;
    self.vertexZ = lowestZ + currentZ - 1;
    NSLog(@"updated my z to: %f", self.vertexZ);
}


@end
