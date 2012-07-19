//
//  AppDelegate.m
//  GladiatorsOfEden
//
//  Created by me on 4/28/12.
//  Copyright MetalBoyBlue 2012. All rights reserved.
//

#import "cocos2d.h"

#import "AppDelegate.h"
#import "RegionMapScene.h"
#import "GameManager.h"


@implementation AppController

@synthesize window=window_, navController=navController_, director=director_;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Create the main window
	window_ = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];


	// Create an CCGLView with a RGB565 color buffer, and a depth buffer of 0-bits
	CCGLView *glView = [CCGLView viewWithFrame:[window_ bounds]
								   pixelFormat:kEAGLColorFormatRGB565	//kEAGLColorFormatRGBA8
								   depthFormat:GL_DEPTH_COMPONENT24_OES
							preserveBackbuffer:NO
									sharegroup:nil
								 multiSampling:NO
							   numberOfSamples:0];

	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];

	director_.wantsFullScreenLayout = YES;

	// Display FSP and SPF
	[director_ setDisplayStats:YES];

    [glView setMultipleTouchEnabled:YES];
    
	// set FPS at 60
	[director_ setAnimationInterval:1.0/60];

	// attach the openglView to the director
	[director_ setView:glView];

	// for rotation and other messages
	[director_ setDelegate:self];

	// 2D projection
	[director_ setProjection:kCCDirectorProjection2D];
//	[director setProjection:kCCDirectorProjection3D];

	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director_ enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");

	// Create a Navigation Controller with the Director
	navController_ = [[UINavigationController alloc] initWithRootViewController:director_];
	navController_.navigationBarHidden = YES;

	// set the Navigation Controller as the root view controller
//	[window_ setRootViewController:rootViewController_];
	[window_ addSubview:navController_.view];

	// make main window visible
	[window_ makeKeyAndVisible];

	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	// When in iPhone RetinaDisplay, iPad, iPad RetinaDisplay mode, CCFileUtils will append the "-hd", "-ipad", "-ipadhd" to all loaded files
	// If the -hd, -ipad, -ipadhd files are not found, it will load the non-suffixed version
	[CCFileUtils setiPhoneRetinaDisplaySuffix:@"-hd"];		// Default on iPhone RetinaDisplay is "-hd"
	[CCFileUtils setiPadSuffix:@"-ipad"];					// Default on iPad is "" (empty string)
	[CCFileUtils setiPadRetinaDisplaySuffix:@"-ipadhd"];	// Default on iPad RetinaDisplay is "-ipadhd"

	// Assume that PVR images have premultiplied alpha
	[CCTexture2D PVRImagesHavePremultipliedAlpha:YES];

	// and add the scene to the stack. The director will run it when it automatically when the view is displayed.
	//[director_ pushScene: [WorldMapLayer scene]]; 
    
    NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    if (ubiq) {
        NSLog(@"iCloud Access At %@", ubiq);
    }else {
        NSLog(@"No iCloud Access");
    }
    [[GameManager sharedGameManager] setupAudioEngine];
    //Temporarily set map to test map
    [[GameManager sharedGameManager] setRegionMapToPresent:kTestRegion];
    
    [[GameManager sharedGameManager] runSceneWithID:kRegionMapScene];

    
    
	return YES;
}

// Supported orientations: Landscape. Customize it for your own needs
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


// getting a call, pause the game
-(void) applicationWillResignActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ pause];
}

// call got rejected
-(void) applicationDidBecomeActive:(UIApplication *)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ resume];
}

-(void) applicationDidEnterBackground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application
{
	if( [navController_ visibleViewController] == director_ )
		[director_ startAnimation];
}

// application will be killed
- (void)applicationWillTerminate:(UIApplication *)application
{
	CC_DIRECTOR_END();
}

// purge memory
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCDirector sharedDirector] purgeCachedData];
}

// next delta time will be zero
-(void) applicationSignificantTimeChange:(UIApplication *)application
{
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void) dealloc
{
	[window_ release];
	[navController_ release];

	[super dealloc];
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GOEModel" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
    
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	if (!TARGET_IPHONE_SIMULATOR) {
        if (__persistentStoreCoordinator != nil) {
            return __persistentStoreCoordinator;
        }
        
        __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] 
                                        initWithManagedObjectModel: [self managedObjectModel]];
        
        NSPersistentStoreCoordinator* psc = __persistentStoreCoordinator;
        
        
        NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"GladiatorsOfEden.sqlite"];
        
        // done asynchronously since it may take a while 
        // to download preexisting iCloud content 
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
            
            
            // building the path to store transaction logs
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSURL *transactionLogsURL = [fileManager 
                                         URLForUbiquityContainerIdentifier:nil];
            NSString* coreDataCloudContent = [[transactionLogsURL path] 
                                              stringByAppendingPathComponent:@"goe_data"];
            transactionLogsURL = [NSURL fileURLWithPath:coreDataCloudContent];
            
            //  Building the options array for the coordinator
            NSDictionary* options = [NSDictionary 		
                                     dictionaryWithObjectsAndKeys:
                                     @"com.metalboyblue.coredata.notes", 
                                     NSPersistentStoreUbiquitousContentNameKey, 
                                     transactionLogsURL,
                                     NSPersistentStoreUbiquitousContentURLKey, 
                                     [NSNumber numberWithBool:YES], 
                                     NSMigratePersistentStoresAutomaticallyOption, 
                                     nil];
            
            
            NSError *error = nil;
            
            [psc lock];
            
            if (![psc addPersistentStoreWithType:NSSQLiteStoreType 
                                   configuration:nil 
                                             URL:storeUrl 
                                         options:options 
                                           error:&error]) {
                
                NSLog(@"Core data error %@, %@", error, [error userInfo]);
                abort();
            }
            
            [psc unlock];
            
            // post a notification to tell the main thread 
            // to refresh the user interface
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"persistent store added correctly");
                [[NSNotificationCenter defaultCenter] 
                 postNotificationName:@"com.metalboyblue.refetchNotes" 
                 object:self 
                 userInfo:nil];
            });
        });
        
        return __persistentStoreCoordinator;
    }
    else {
        if (__persistentStoreCoordinator != nil)
        {
            return __persistentStoreCoordinator;
        }
        
        NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"GladiatorsOfEden.sqlite"];       
        NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
        
        NSError *error = nil;
        __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }    
        
        return __persistentStoreCoordinator;

    }
}


- (NSManagedObjectContext *)managedObjectContext
{   
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }	
    NSPersistentStoreCoordinator *coordinator = 
    [self persistentStoreCoordinator];
    
    if (coordinator != nil) {        
        // choose a concurrency type for the context
        NSManagedObjectContext* moc = 
        [[NSManagedObjectContext alloc] 
         initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        [moc performBlockAndWait:^{
            // configure context properties
            [moc setPersistentStoreCoordinator: coordinator];
            [[NSNotificationCenter defaultCenter] 
             addObserver:self 
             selector:@selector(mergeChangesFrom_iCloud:) 
             name:NSPersistentStoreDidImportUbiquitousContentChangesNotification 
             object:coordinator];
        }];
        __managedObjectContext = moc;
    }    
    return __managedObjectContext;
}


- (void)saveContext
{
    NSError *error = nil;
    
    if ([self.managedObjectContext hasChanges] && 
        ![self.managedObjectContext save:&error])
    {
        NSLog(@"Core Data error %@, %@", error, [error userInfo]);
        abort();
    } 
}

- (void)mergeChangesFrom_iCloud:(NSNotification *)notification {
    NSManagedObjectContext* moc = [self managedObjectContext];    
    [moc performBlock:^{
        [self mergeiCloudChanges:notification 
                      forContext:moc];
    }];
}

- (void)mergeiCloudChanges:(NSNotification*)note 
                forContext:(NSManagedObjectContext*)moc {    
    [moc mergeChangesFromContextDidSaveNotification:note];     
    //Refresh view with no fetch controller if any    
}

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


@end
