//
//  BaseUITableViewController.h
//  ConferenceApp
//
//  Created by Peter Friese on 22.09.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface BaseUITableViewController : UITableViewController<NSFetchedResultsControllerDelegate, RKObjectLoaderDelegate> {
}
@property (nonatomic, retain) NSString *resourcePath;

- (Class)managedObject;
- (void)loadData;

@end
