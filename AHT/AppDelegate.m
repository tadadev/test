//
//  AppDelegate.m
//  AHT
//
//  Created by Troy DeMar on 2/24/15.
//  Copyright (c) 2015 Troy. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "TAGManager.h"
#import "TAGContainer.h"
#import "TAGContainerOpener.h"
#import "GAI.h"
#import "ACTReporter.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <ChimpKit/ChimpKit.h>
#import "iRate.h"
#import <CreateSend/CreateSend.h>

@interface AppDelegate () <TAGContainerOpenerNotifier>

@end

@implementation AppDelegate
@synthesize audio, threshold;


static NSString *sqliteStoreName = @"audicus_aht.sqlite";



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //Tag Manager
//    self.tagManager = [TAGManager instance];
//    
//    [self.tagManager.logger setLogLevel:kTAGLoggerLogLevelVerbose];
//    
//    [TAGContainerOpener openContainerWithId:@"GTM-N5GX8T"   // Update with your Container ID.
//                                 tagManager:self.tagManager
//                                   openType:kTAGOpenTypePreferFresh
//                                    timeout:nil
//                                   notifier:self];
    
    
    //Google Analytics
    [GAI sharedInstance].dispatchInterval = 10;
    
    //[[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-21401477-4"];
    
    
    //Google Conversion
    [ACTConversionReporter reportWithConversionID:@"974798586" label:@"4dVYCLXSlVwQ-v3o0AM" value:@"0.00" isRepeatable:NO];
    
    // Enable automated usage reporting.
    [ACTAutomatedUsageTracker enableAutomatedUsageReportingWithConversionID:@"974798586"];
    
    
    
    //Fabric
    [Fabric with:@[CrashlyticsKit]];

    
    //Diable Idle Timer
    application.idleTimerDisabled = YES;
    
    //Setup App Parameters
    audio = AudioType_NS_1;
    threshold = ThresholdLvl_40;
    
    
    
    //MagicalRecord
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelVerbose];
    MagicalRecordStack *Stack= [MagicalRecord setupSQLiteStackWithStoreNamed:sqliteStoreName];
    if(!Stack){
        UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                         message:@"Error while Creating database"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [myAlert show];
    }
    
    
    //MailChimp (Removed)
    //[[ChimpKit sharedKit] setApiKey:@"bdd0fbc5a421c16d97f54aac156bb1b1-us2"];
    
    
    //iRate
    //enable preview mode
    [iRate sharedInstance].promptAtLaunch = NO;
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    //[iRate sharedInstance].previewMode = NO;

    
    
//    for (NSString* family in [UIFont familyNames])
//    {
//        NSLog(@"%@", family);
//        
//        for (NSString* name in [UIFont fontNamesForFamilyName: family])
//        {
//            NSLog(@"  %@", name);
//        }
//    }

    
    //return YES;
    
    //facebook
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //facebook
    [FBSDKAppEvents activateApp];
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //MagicalRecord
    [MagicalRecord cleanUp];
    
}



- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    //facebook
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}


#pragma mark - TAGContainerOpenerNotifier

- (void)containerAvailable:(TAGContainer *)container {
    // Note that containerAvailable may be called on any thread, so you may need to dispatch back to
    // your main thread.
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Anything??");
        self.container = container;
    });
}


@end
