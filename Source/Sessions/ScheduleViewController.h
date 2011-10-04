//
//  ScheduleViewController.h
//  ConferenceApp
//
//  Created by Peter Friese on 02.10.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionTableViewController.h"

@interface ScheduleViewController : UIViewController<SessionNavigationDelegate>

@property (nonatomic, retain) NSArray *dates;
@property (nonatomic, retain) UIBarButtonItem *favoritesButton;

@end
