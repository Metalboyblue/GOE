//
//  TouchLayer.m
//  Bona Fide Blackjack
//
//  Created by Christopher Brand on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TouchLayer.h"

@implementation TouchLayer

- (id)init
{
    self = [super init];
    if (self) {
        self.isTouchEnabled = YES;
        inhibitor = false;
        ignoreTouchEnd = false;
    }
    
    return self;
}

//Touch Methods
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"Touch Detected By TouchLayer");
    timeTouchStarted = [NSDate timeIntervalSinceReferenceDate];
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView: [touch view]];
    whereTouchStarted = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    [self performSelector:@selector(pressAndHold) withObject: nil afterDelay: 1.0];
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(ignoreTouchEnd == true) {
        ignoreTouchEnd = false;
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pressAndHold) object:nil];
    
    UITouch* touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView: [touch view]];
    NSTimeInterval touchTime = [NSDate timeIntervalSinceReferenceDate] - timeTouchStarted;
    whereTouchEnded = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    CGFloat slideLengthTest = 15;
    
    CGFloat xDifference = whereTouchEnded.x - whereTouchStarted.x;
    CGFloat yDifference = whereTouchEnded.y - whereTouchStarted.y;
    
    // Detect touch anywhere
    
    if((abs(xDifference) > slideLengthTest || abs(yDifference) > slideLengthTest) && [touch tapCount] == 0) {
        inhibitor = true;
        if(abs(xDifference) > abs(yDifference)) {
            if(xDifference < 0) {
                [self swipeLeft];
            } else {
                [self swipeRight];
            }
        } else {
            if(yDifference < 0) {
                [self swipeDown];
            } else {
                [self swipeUp];
            }
        }
    } else if(touchTime > .35 && ([touch tapCount] == 0 || [touch tapCount] ==1)) {
        [self longTouch];
        inhibitor = true;
    } else if([touch tapCount] == 1) {
        inhibitor = false;
        [self performSelector:@selector(singleTap) withObject:nil afterDelay:.35];
    } else if([touch tapCount] == 2 && inhibitor == false) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTap) object:nil];
        [self performSelector:@selector(doubleTap) withObject:nil afterDelay:.35];
    } else if([touch tapCount] == 3 && inhibitor == false) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doubleTap) object:nil];
        [self performSelector:@selector(tripleTap) withObject:nil afterDelay:.35];
    }
}

-(void) ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

-(void) swipeLeft
{
    NSLog(@"SwipeLeft Detected");
}

-(void) swipeRight
{
}

-(void) swipeUp
{
}

-(void) swipeDown
{
}

-(void) singleTap
{
    NSLog(@"Single Tap Detected");
}

-(void) doubleTap
{
}

-(void) tripleTap
{
}

-(void) longTouch
{
}

-(void) dealloc
{
    [super dealloc];
}

@end
