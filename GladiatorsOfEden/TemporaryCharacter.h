//
//  TemporaryCharacter.h
//  GladiatorsOfEden
//
//  Created by me on 5/24/12.
//  Copyright 2012 MetalBoyBlue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface TemporaryCharacter : CCSprite {
    
}


+(id) player;
-(void) updateVertexZ:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap;


@end
