//
//  ScheduleViewController2.h
//  ConferenceApp
//
//  Created by Peter Friese on 10.10.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateNavigator.h"
#import "BaseUIViewController.h"

@interface ScheduleViewController : BaseUIViewController<DateNavigatorDelegate>

@property (nonatomic, retain) NSArray *dates;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic) BOOL displayFavorites;
- (void)toggleSearchBar:(id)sender;

@end
