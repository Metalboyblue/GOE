//
//  RegionMapScene.m
//  GladiatorsOfEden
//
//  Created by me on 5/24/12.
//  Copyright 2012 MetalBoyBlue. All rights reserved.
//

#import "RegionMapScene.h"
#import "RegionMap.h"

enum nodeTags
{
	kBackgroundTag,
    kTileMapTag,
	kLabelTag,
    kTestObject1,
    kTestObject2,
    kTestObject3,
};


@implementation RegionMapLayer

@synthesize tileMap = _tileMap;
@synthesize context = _context;
@synthesize worldObjectsLayer = _worldObjectsLayer;

/*
+(id) scene{
    CCScene *scene = [CCScene node];
    WorldMapLayer *layer = [WorldMapLayer node];
    [scene addChild:layer];
    return scene;
}
*/



-(id) init
{
	if ((self = [super init]))
	{     
        winSize = [[CCDirector sharedDirector] winSize];
        
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
        
        [[GameManager sharedGameManager] playBackgroundTrack:BACKGROUND_TRACK_REGIONMAPSCENE];
       
        // Initialize array to contain all world objects while running
        listOfObjectsInRegion = [[NSMutableArray alloc] init];

        [self setUpTileMap];
                
        // the pan/zoom controller
        _controller = [[CCPanZoomController controllerWithNode:self] retain];
        _controller.boundingRect = CGRectMake(0, 0, mapWidthInPixels, mapHeightInPixels);
        _controller.zoomOutLimit = _controller.optimalZoomOutLimit;
        _controller.zoomInLimit = 2.0f;
        
        [_controller enableWithTouchPriority:1 swallowsTouches:YES];
        
        [_controller centerOnPoint:ccp(mapWidthInPixels/2, mapHeightInPixels/2)];
        
        
		self.isTouchEnabled = YES;
        
				
                
		// Create the player and add it
		player = [Player player];
		player.position = CGPointMake(winSize.width / 2, winSize.height / 2);
		// approximately position player's texture to best match the tile center position
		player.anchorPoint = CGPointMake(0.3f, 0.1f);
        [self addChild:player];
        
		// Start update
		//[self scheduleUpdate];
        //[self updateForScreenReshape];
        
	}
    
	return self;
}



///////////////////////////////////////////////////////////////////////////
#pragma mark Update


-(void) update:(ccTime)delta
{
		// continuously fix the player's Z position
	//CGPoint tilePos = [self floatingTilePosFromLocation:screenCenter tileMap:tileMap];
	//[player updateVertexZ:tilePos tileMap:tileMap];
}





-(void) dealloc
{
	[super dealloc];
}

-(bool) isTilePosBlocked:(CGPoint)tilePos tileMap:(CCTMXTiledMap*)tileMap
{
	CCTMXLayer* layer = [tileMap layerNamed:@"Objects"];
	NSAssert(layer != nil, @"Objects layer not found!");
	
	bool isBlocked = NO;
	unsigned int tileGID = [layer tileGIDAt:tilePos];
	if (tileGID > 0)
	{
		NSDictionary* tileProperties = [tileMap propertiesForGID:tileGID];
		id blocks_movement = [tileProperties objectForKey:@"blocks_movement"];
		isBlocked = (blocks_movement != nil);
	}
    
	return isBlocked;
}

-(CGPoint) tilePosFromLocation:(CGPoint)location tileMap:(CCTMXTiledMap*)tileMap
{
	float halfMapWidth = tileMap.mapSize.width * 0.5f;
	float mapHeight = tileMap.mapSize.height;
	float tileWidth = tileMap.tileSize.width;
	float tileHeight = tileMap.tileSize.height;
	
	CGPoint tilePosDiv = CGPointMake(location.x / tileWidth, location.y / tileHeight);
	float inverseTileY = mapHeight - tilePosDiv.y;
	
	// Cast to int makes sure that result is in whole numbers, tile coordinates will be used as array indices
	float posX = (int)(inverseTileY + tilePosDiv.x - halfMapWidth);
	float posY = (int)(inverseTileY - tilePosDiv.x + halfMapWidth);
    
    posX = MAX(0, posX);
    posX = MIN(tileMap.mapSize.width, posX);
    posY = MAX(0, posY);
    posY = MIN(tileMap.mapSize.height, posY);
    
	return CGPointMake(posX, posY);
}


-(CGPoint)pointOnMapFromTileX:(int)xPosition andY:(int)yPosition{
    
}




#pragma mark TouchHandlingCode

-(BOOL) ccTouchBegan:(UITouch*)touch withEvent:(UIEvent *)event
{	    
    //NSLog(@"Touch Started in WorldMapScene");

	return YES;
}

-(void) ccTouchMoved:(UITouch*)touch withEvent:(UIEvent *)event
{

}

- (void)ccTouchEnded:(UITouch*)touch withEvent:(UIEvent *)event
{
   
        //Handle The Single Touch By Calling a tile position return here 
    if ([touch tapCount] == 1){
        NSLog(@"Single Tap Detected by World Map");
        CGPoint pt = [self convertTouchToNodeSpace:touch];
        [_controller centerOnPoint:pt duration:1.0 rate:2.0];
        CGPoint touchedTileNumber = [self tilePosFromLocation:pt tileMap:_tileMap];
        NSLog(@"Tile # touched  X:%f  Y:%f", touchedTileNumber.x, touchedTileNumber.y);
        player.position = pt;
        for (GameObject *objectInRegion in listOfObjectsInRegion) {
           // NSLog(@"inside loop");
            if (objectInRegion.tileXLocation == touchedTileNumber.x && objectInRegion.tileYLocation == touchedTileNumber.y){
                [objectInRegion touched];
            }
        }
    }
}

-(CGRect)myRectForTouch:(CCSprite *)sp
{
    CGRect rect;
    rect = CGRectMake(sp.position.x-sp.textureRect.size.width/2,sp.position.y,sp.textureRect.size.width,sp.textureRect.size.height);
    
    NSLog(@"Texture info x: %f \n y:%f \n Width:%f \n Height:&=%f", sp.position.x, sp.position.y, sp.textureRect.size.width, sp.textureRect.size.height);
    return rect;
    
}

-(void)setUpTileMap{
    // First, check gamemanager to determine the map selected
    mapToPresent = [[GameManager sharedGameManager] regionMapToPresent];

    //Load Tilemap
    _tileMap = [CCTMXTiledMap tiledMapWithTMXFile:[[GameManager sharedGameManager] formatMapToPresentTypeToMapNameString:mapToPresent]];
                
    _tileMap.anchorPoint = ccp(0.0f,0.0f);
    _tileMap.scale = CC_CONTENT_SCALE_FACTOR();
    [self addChild:_tileMap z:-1 tag:kTileMapTag];
    
    
    //Setup Playable Area
    mapBoarderSize = 10;
    playableAreaMin = CGPointMake(-(mapBoarderSize * _tileMap.tileSize.width), (mapBoarderSize * _tileMap.tileSize.height));
    playableAreaMax = CGPointMake((_tileMap.mapSize.width-(mapBoarderSize*2))*_tileMap.tileSize.width, (_tileMap.mapSize.height-(mapBoarderSize*2))*_tileMap.tileSize.height);
    
    //Determine Playable Area Bounding Rect
   // NSLog(@"mapBoarderSize:%i", mapBoarderSize);
   // NSLog(@"map bounds.  TLX:%f  TLY:%f  BRX:%f  BRY:%f ", playableAreaMin.x, playableAreaMin.y, playableAreaMax.x, playableAreaMax.y);
    //Determine pixel size of the playable area of the map
    mapWidthInPixels = _tileMap.mapSize.width * _tileMap.tileSize.width;
    mapHeightInPixels = _tileMap.mapSize.height * _tileMap.tileSize.height;
    //NSLog(@"tilemap tilesize: %f", _tileMap.tileSize.width);
    //NSLog(@"tilemap mapsize:%f", _tileMap.mapSize.width);
    
   //Check For Memory Model for this map.  If it exists then Load it, Otherwise this is first load.  Seed from Tiled Map and then save.  This allows modification of maps.
    
    _context = [(AppController *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    if (!_context) {
        // Handle the error.
		NSLog(@"context = nil");
    }
    
    //Fetch Region Map Entities and look for entity with name of current map to load
    NSError *error;

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RegionMap" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    
    NSArray *fetchedObjects = [_context executeFetchRequest:fetchRequest error:&error];
    NSLog(@"Number of saved objects: %i", [fetchedObjects count]);
        
    BOOL nameExists = NO;// Use flag to determine if the name exists
    NSString* nameOfMap = [[GameManager sharedGameManager] formatMapToPresentTypeToMapNameString:mapToPresent];
    if ([fetchedObjects count] > 0) {
        
        for (RegionMap *map in fetchedObjects) {
            
            if ([map.regionName isEqualToString:nameOfMap]) {
                nameExists = YES;
                regionMap = map;
            }  
        }
    }
    
    if (nameExists) {
        //[self loadMapAssets];
        [self seedMapIntoMemory];
    }
    else {
        [self seedMapIntoMemory];
    }
}

-(void)seedMapIntoMemory{
    
    NSLog(@"Seeding Memory");
    // First, Create a RegionMap Object to Store
    RegionMap* newMap = [NSEntityDescription insertNewObjectForEntityForName:@"RegionMap" inManagedObjectContext:_context];

    //Set the name to the name of the Region
    newMap.regionName = [[GameManager sharedGameManager] formatMapToPresentTypeToMapNameString:mapToPresent];
    
    // Now get the layer built in Tiled
    _worldObjectsLayer = [_tileMap layerNamed:@"MapItemsLayer"];
    _worldObjectsLayer.visible = NO;
    
    
    // Now cycle through the Tiles and look for tiles with properties.  Each asset in this layer should have a property
    CGSize s = [_worldObjectsLayer layerSize];
    for( int x=0; x<s.width;x++) {
        for( int y=0; y< s.height; y++ ) {
            NSInteger tileGID = [_worldObjectsLayer tileGIDAt:ccp(x,y)];
            //NSLog(@"TileGID:%i at location x: %i  y: %i",tileGID, x, y);
            NSDictionary* tileProperties = [_tileMap propertiesForGID:tileGID];
            if (tileProperties) {
                //Now create a WorldObject, set its required properties then add to RegionMap Object
                WorldObjects *assetInRegion = [NSEntityDescription insertNewObjectForEntityForName:@"WorldObjects" inManagedObjectContext:_context];
                assetInRegion.tileXLocation = [NSNumber numberWithInt:x];
                assetInRegion.tileYLocation = [NSNumber numberWithInt:y];
                assetInRegion.worldObjectType = [tileProperties valueForKey:@"AssetType"];
                [newMap addObjectsObject:assetInRegion];
                
                //NSLog(@"found %@ Asset and added to newMap at tile: x:%i  y:%i", [tileProperties valueForKey:@"AssetType"], x,y);
            }
        
        }
    }
    
    // Once the assets are created and added to the newMap
    // Then save to the device
    NSError *error;
    if (![_context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }

    // Now load the Map Assets to the Scene
    regionMap = newMap;
    
    [self loadMapAssets];

}

-(void)loadMapAssets{
    NSSet *thisRegionsObjects = regionMap.objects;
    for (WorldObjects* asset in thisRegionsObjects) {
        //NSLog(@"%@ asset located at on tile: x:%i  y:%i", asset.worldObjectType, [asset.tileXLocation intValue], [asset.tileYLocation intValue]);
        RemovableBarriers *removableAsset = [[RemovableBarriers alloc] initWithLayer:self];
        removableAsset.tileXLocation = [asset.tileXLocation intValue];
        removableAsset.tileYLocation = [asset.tileYLocation intValue];
        removableAsset.worldObjectType = asset.worldObjectType;
        [removableAsset setSprite];
        [removableAsset updateVertexZ:CGPointMake(removableAsset.tileXLocation, removableAsset.tileYLocation) tileMap:_tileMap];
        [listOfObjectsInRegion addObject:removableAsset];
    }
    NSLog(@"listOfObjects count:%i", [listOfObjectsInRegion count]);
}
@end
