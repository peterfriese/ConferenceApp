//
//  ConferenceAppAppDelegate.m
//  ConferenceApp
//
//  Created by Peter Friese on 21.09.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import "ConferenceAppAppDelegate.h"
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>
#import "Session.h"
#import "SpeakerTableViewController.h"
#import "Speaker.h"
#import "NSDate+Additions.h"
#import "NewScheduleViewController.h"
#import "ScheduleViewController.h"

#import "NSAttributedString+HTML.h"

@implementation ConferenceAppAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (void)setupRestKit
{
    // NSString *baseURL = @"http://www.eclipsecon.org/europe2011/json";
    // NSString *baseURL = @"http://peterfriese.local:3000";
    NSString *baseURL = @"http://eclipsecon2012-node.webbyapp.com";
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:baseURL];
    
    objectManager.client.requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;

    // send UDID with each request
    NSString *udid = [[UIDevice currentDevice] uniqueIdentifier];
    [objectManager.client setValue:udid forHTTPHeaderField:@"udid"];

    NSString *databaseName = @"ConferenceData.sqlite";
    objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:databaseName inDirectory:nil usingSeedDatabaseName:nil managedObjectModel:nil delegate:self];
    
    // Set up date and time parsers
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm:ss"];
    [RKObjectMapping setPreferredDateFormatter:dateFormatter];
    [RKObjectMapping setDefaultDateFormatters:[NSArray arrayWithObjects:dateFormatter, timeFormatter, nil]];
    [dateFormatter release];
    [timeFormatter release];
    
    // Speaker Mapping
    RKManagedObjectMapping *speakerMapping = [RKManagedObjectMapping mappingForClass:[Speaker class]];
    [speakerMapping mapKeyPathsToAttributes:
        @"id", @"speakerId", 
        @"fullname", @"fullName",
        @"lastname", @"lastName",
        @"firstname", @"firstName",
        @"organization", @"affiliation",
        @"bio", @"bio",
        @"picture", @"picture",
     nil];    
    speakerMapping.primaryKeyAttribute = @"speakerId";    
    
    // Session Mapping
    RKManagedObjectMapping *sessionMapping = [RKManagedObjectMapping mappingForClass:[Session class]];
    sessionMapping.primaryKeyAttribute = @"sessionId";    
    [sessionMapping mapKeyPathsToAttributes:
        @"id", @"sessionId",
        @"title", @"title",
        @"abstract", @"abstract",
        @"type", @"type",
        @"room", @"room",
        @"date", @"date",
        @"start", @"startTime",
        @"end", @"endTime",
        @"category", @"category", 
        nil];
    [sessionMapping mapKeyPath:@"presenter" toRelationship:@"speakers" withMapping:speakerMapping];
    
    // Add mappings to mapping manager:
    [objectManager.mappingProvider setMapping:sessionMapping forKeyPath:@"session"];
//    [objectManager.mappingProvider setMapping:speakerMapping forKeyPath:@"presenter"];
}

-(void)managedObjectStore:(RKManagedObjectStore *)objectStore didFailToCreatePersistentStoreCoordinatorWithError:(NSError *)error
{
    NSLog(@"An error occurred, we'll reset the data store. Error: %@", error);
    [objectStore deletePersistantStore];
    [objectStore save];    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DATA_STORE_RELOAD" object:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Init RestKit
    [self setupRestKit];
    
    // this will hold our Tab Bar Controllers
    NSMutableArray *tabBarControllers = [[NSMutableArray alloc] init];
    
    // Sessions View Controller and NavigationController
    /*
    SessionTableViewController *sessionsViewController = [[SessionTableViewController alloc] init];
    sessionsViewController.date = [NSDate dateFromString:@"2011-11-03"];
    sessionsViewController.tabBarItem.image = [UIImage imageNamed:@"83-calendar"];
    UINavigationController *sessionsNavigationController = [[UINavigationController alloc] initWithRootViewController:sessionsViewController];
    [sessionsNavigationController.navigationBar setTintColor:[UIColor blackColor]];
    [sessionsViewController release];    
    [tabBarControllers addObject:sessionsNavigationController];
    [sessionsNavigationController release];
    */
    
    NSArray *dates = [NSArray arrayWithObjects:
                      [NSDate dateFromString:@"2012-03-26"],                       
                      [NSDate dateFromString:@"2012-03-27"], 
                      [NSDate dateFromString:@"2012-03-28"], 
                      [NSDate dateFromString:@"2012-03-29"], 
                      nil];

    ScheduleViewController *scheduleViewController2 = [[ScheduleViewController alloc] init];
    scheduleViewController2.title = @"Sessions";
    scheduleViewController2.showFavoritesButton = NO;
    scheduleViewController2.dates = dates;
    scheduleViewController2.tabBarItem.image = [UIImage imageNamed:@"83-calendar"];
    UINavigationController *scheduleNavigationController2 = [[UINavigationController alloc] initWithRootViewController:scheduleViewController2];
    [scheduleNavigationController2.navigationBar setTintColor:[UIColor blackColor]];    
    [scheduleViewController2 release];
    [tabBarControllers addObject:scheduleNavigationController2];
    [scheduleNavigationController2 release];
    
    ScheduleViewController *favouritesViewController = [[ScheduleViewController alloc] init];
    favouritesViewController.displayFavorites = YES;
    favouritesViewController.showFavoritesButton = NO;
    favouritesViewController.title = @"My Schedule";
    favouritesViewController.dates = dates;
    favouritesViewController.tabBarItem.image = [UIImage imageNamed:@"mySchedule"];
    UINavigationController *favouritesNavigationController = [[UINavigationController alloc] initWithRootViewController:favouritesViewController];
    [favouritesNavigationController.navigationBar setTintColor:[UIColor blackColor]];
    [favouritesViewController release];
    [tabBarControllers addObject:favouritesNavigationController];
    [favouritesNavigationController release];

    // This class has been used to develop the extra animation of the search bar in conjunctioin with the date navigator. Leaving it in here for reference purposes.
    /*
    NewScheduleViewController *newScheduleViewController = [[NewScheduleViewController alloc] init];
    newScheduleViewController.tabBarItem.image = [UIImage imageNamed:@"83-calendar"];
    UINavigationController *newScheduleNavigationController = [[UINavigationController alloc] initWithRootViewController:newScheduleViewController];
    [newScheduleViewController release];
    [tabBarControllers addObject:newScheduleNavigationController];
    [newScheduleNavigationController release];
     */
    
    // Speaker View Controller and NavigationController
    SpeakerTableViewController *speakerViewController = [[SpeakerTableViewController alloc] init];
    speakerViewController.tabBarItem.image = [UIImage imageNamed:@"66-microphone"];
    UINavigationController *speakerNavigationController = [[UINavigationController alloc] initWithRootViewController:speakerViewController];
    [speakerNavigationController.navigationBar setTintColor:[UIColor blackColor]];
    [speakerViewController release];
    [tabBarControllers addObject:speakerNavigationController];
    [speakerNavigationController release];
    
    // Produce Tab Bar Controller
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    [self.tabBarController setViewControllers:tabBarControllers];
    [tabBarControllers release];
    
    [self.window addSubview:_tabBarController.view];
    [self.window makeKeyAndVisible];
    
    // HACK
    NSData *data = [@"<html><body><b>Startup</b></body></html>" dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *string = [[NSAttributedString alloc] initWithHTML:data options:nil documentAttributes:nil];
    [string release];
    
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
