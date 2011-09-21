//
//  SessionsViewController.h
//  ConferenceApp
//
//  Created by Peter Friese on 21.09.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"

#import <RestKit/CoreData/CoreData.h>

@interface SessionsViewController : UITableViewController<NSFetchedResultsControllerDelegate, RKObjectLoaderDelegate>

@property (nonatomic, retain) NSArray *sessions;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
