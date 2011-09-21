//
//  ConferenceAppAppDelegate.m
//  ConferenceApp
//
//  Created by Peter Friese on 21.09.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import "ConferenceAppAppDelegate.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>
#import "SessionsViewController.h"
#import "Session.h"

@implementation ConferenceAppAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (void)setupRestKit
{
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:@"http://peterfriese.local/~peterfriese/ece2011-data"];
    
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;

    NSString *databaseName = @"ConferenceData.sqlite";
    objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:databaseName];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm:ss"];
    [RKObjectMapping setPreferredDateFormatter:dateFormatter];
    [RKObjectMapping setDefaultDateFormatters:[NSArray arrayWithObjects:dateFormatter, timeFormatter, nil]];
    [dateFormatter release];
    [timeFormatter release];
    RKManagedObjectMapping *sessionMapping = [RKManagedObjectMapping mappingForClass:[Session class]];
    sessionMapping.primaryKeyAttribute = @"sessionId";
    [sessionMapping mapKeyPathsToAttributes:
        @"id", @"sessionId",
        @"title", @"title",
        @"abstract", @"abstract",
        @"type", @"type",
        @"room", @"room",
        @"status", @"status",
        @"date", @"date",
        @"startTime", @"startTime",
        @"endTime", @"endTime",
        @"createdAt", @"createdAt", 
        @"category", @"category", nil];
    
    [objectManager.mappingProvider setMapping:sessionMapping forKeyPath:@"session"];

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Init RestKit
    [self setupRestKit];
    
    // this will hold our Tab Bar Controllers
    NSMutableArray *tabBarControllers = [[NSMutableArray alloc] init];
    
    // Sessions View Controller and NavigationController
    SessionsViewController *sessionsViewController = [[SessionsViewController alloc] init];
    UINavigationController *sessionsNavigationController = [[UINavigationController alloc] initWithRootViewController:sessionsViewController];
    [sessionsViewController release];
    [tabBarControllers addObject:sessionsNavigationController];
    [sessionsNavigationController release];
    
    // Produce Tab Bar Controller
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    [self.tabBarController setViewControllers:tabBarControllers];
    [tabBarControllers release];
    
    [self.window addSubview:_tabBarController.view];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_tabBarController release];
    [_window release];
    [super dealloc];
}

@end
