//
//  SessionTableViewController.h
//  ConferenceApp
//
//  Created by Peter Friese on 22.09.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import "BaseUITableViewController.h"
#import "Session.h"

@protocol SessionNavigationDelegate <NSObject>
- (void)navigateToSession:(Session *)session;
@end

@interface SessionTableViewController : BaseUITableViewController
@property (nonatomic) BOOL displayFavorites;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, assign) id<SessionNavigationDelegate>delegate;
@end
