//
//  SceneManager.m
//  Gladiators Of Eden
//
//  Created by Travis Baker on 7/27/11.
//  Copyright 2011 MetalBoyBlue. All rights reserved.
//

#import "SceneManager.h"


@interface SceneManager ()
+(void) go: (CCLayer *) layer;
+(CCScene *) wrap: (CCLayer *) layer;
@end


@implementation SceneManager



+(void) go: (CCLayer *) layer{
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *newScene = [SceneManager wrap:layer];
    if ([director runningScene]) {
        [director replaceScene:newScene];
    }else{
        [director runWithScene:newScene];
    }
}

+(CCScene *) wrap: (CCLayer *) layer{
    CCScene *newScene = [CCScene node];
    [newScene addChild:layer];
    return newScene;
}


+(void) goWorldMap{
    CCLayer* layer = [RegionMapLayer node];
    [SceneManager go:layer];
}


@end


