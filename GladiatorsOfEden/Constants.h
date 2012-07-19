//
//  Constants.h
//  LilDevilsGame
//
//  Created by Travis Baker on 8/16/11.
//  Copyright 2011 MetalBoyBlue. All rights reserved.
//
#import <Foundation/Foundation.h>
// Debug Enemy States with Labels
// 0 for OFF, 1 for ON
#define ENEMY_STATE_DEBUG 0

// Audio Items
#define AUDIO_MAX_WAITTIME 150

typedef enum {
    kAudioManagerUninitialized=0,
    kAudioManagerFailed=1,
    kAudioManagerInitializing=2,
    kAudioManagerInitialized=100,
    kAudioManagerLoading=200,
    kAudioManagerReady=300
    
} GameManagerSoundState;


typedef enum {
    kNoSceneUninitialized=0,
    kRegionMapScene=1,
} SceneTypes;


// Audio Constants
#define SFX_NOTLOADED NO
#define SFX_LOADED YES

#define PLAYSOUNDEFFECT(...) \
[[GameManager sharedGameManager] playSoundEffect:@#__VA_ARGS__]

#define STOPSOUNDEFFECT(...) \
[[GameManager sharedGameManager] stopSoundEffect:__VA_ARGS__]


// Background Music
// Cage Scene
#define BACKGROUND_TRACK_REGIONMAPSCENE @"Soliloquy_1.mp3"


// Weapon Constants


// World Map Objects Constants
typedef enum{
    kSmallTree=1,
    kLargeTree=2,
    kSmallRock=3,
    kLargRock=4,
    kCastle=5,
    kHospital=6,
    kCave=7,
    kMine=8,
    kShrine=9,
    kPortal=10
}WorldMapObjectType;

// Region Maps Available to Present
typedef enum{
    kTestRegion=1,
    kSecondTestRegion=2
}RegionMapType;

