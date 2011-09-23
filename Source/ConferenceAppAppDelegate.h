//
//  ConferenceAppAppDelegate.h
//  ConferenceApp
//
//  Created by Peter Friese on 21.09.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface ConferenceAppAppDelegate : NSObject <UIApplicationDelegate, RKManagedObjectStoreDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabBarController;

@end
