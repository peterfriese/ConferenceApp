//
//  SessionTableViewController.h
//  ConferenceApp
//
//  Created by Peter Friese on 22.09.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import "BaseUITableViewController.h"

@interface SessionTableViewController : BaseUITableViewController

@property (nonatomic, retain) UIBarButtonItem *favoritesButton;
@property (nonatomic) BOOL displayFavorites;

@end
