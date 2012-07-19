//
//  TouchLayer.h
//  Bona Fide Blackjack
//
//  Created by Christopher Brand on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface TouchLayer : CCLayer
{
    BOOL inhibitor;
    BOOL ignoreTouchEnd;
    NSTimeInterval timeTouchStarted;
    CGPoint whereTouchStarted;
    CGPoint whereTouchEnded;
}

-(void) swipeLeft;
-(void) swipeRight;
-(void) swipeUp;
-(void) swipeDown;
-(void) singleTap;
-(void) doubleTap;
-(void) tripleTap;
-(void) longTouch;

@end
