//
//  GameManager.h
//  Gladiators of Eden
//
//  Created by Travis Baker on 8/23/11.
//  Copyright 2011 MetalBoyBlue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "SimpleAudioEngine.h"
#import "cocos2d.h"


@interface GameManager : NSObject {
    BOOL isMusicON;
    BOOL isSoundEffectsON;
    SceneTypes currentScene;
    BOOL isMonsterInCage;
    BOOL isAugmentedRealityRunning;
    
    // Added for audio
    BOOL hasAudioBeenInitialized;
    GameManagerSoundState managerSoundState;
    SimpleAudioEngine *soundEngine;
    NSMutableDictionary *listOfSoundEffectFiles;
    NSMutableDictionary *soundEffectsState;
    
    //Stored Values
    
    
    //Device Capabilities Variables
        
    //Target Scene Variables need due to transition scene
    NSInteger targetScene;
    NSInteger returnScene;
    
    
    RegionMapType regionMapToPresent;
    
}

@property (readwrite) BOOL isMusicON;
@property (readwrite) BOOL isSoundEffectsON;

@property (readwrite) GameManagerSoundState managerSoundState;
//@property (readonly) SimpleAudioEngine *soundEngine;
@property (nonatomic, retain) NSMutableDictionary *listOfSoundEffectFiles;
@property (nonatomic, retain) NSMutableDictionary *soundEffectsState;

@property (nonatomic, readwrite) NSInteger targetScene;
@property (nonatomic, readwrite) NSInteger returnScene;
@property (nonatomic, readwrite) RegionMapType regionMapToPresent;

+(GameManager*)sharedGameManager;
-(void)runSceneWithID:(SceneTypes)sceneID;                         
-(void)setupAudioEngine;
-(ALuint)playSoundEffect:(NSString*)soundEffectKey;
-(void)stopSoundEffect:(ALuint)soundEffectID;
-(void)playBackgroundTrack:(NSString*)trackFileName;
-(void)stopBackgroundTrack;
-(NSString*)formatMapToPresentTypeToMapNameString:(RegionMapType)mapToPresent;

@end
