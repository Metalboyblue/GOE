//
//  RegionMapScene.h
//  GladiatorsOfEden
//
//  Created by me on 5/24/12.
//  Copyright 2012 MetalBoyBlue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TemporaryCharacter.h"
#import "Player.h"
#import "CCPanZoomController.h"
#import "TouchLayer.h"
#import "GameManager.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "RegionMap.h"
#import "WorldObjects.h"
#import "RemovableBarriers.h"

enum
{
	TileMapNode = 0,
};


@interface RegionMapLayer : CCLayer {
    CGSize winSize;
    
	TemporaryCharacter* player;
    NSMutableArray *listOfObjectsInRegion;
    
    CCPanZoomController *_controller;

    float mapWidthInPixels;
    float mapHeightInPixels;
    
    int mapBoarderSize;
    CGPoint playableAreaMin;
    CGPoint playableAreaMax;
    
    RegionMapType mapToPresent;
    RegionMap *regionMap;
}

@property(nonatomic, retain) CCTMXTiledMap* tileMap;
@property (nonatomic, retain) NSManagedObjectContext *context; //Reference to Memory
@property (nonatomic, retain) CCTMXLayer *worldObjectsLayer;
//+(id) scene;


@end
