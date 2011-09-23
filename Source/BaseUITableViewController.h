//
//  BaseUITableViewController.h
//  ConferenceApp
//
//  Created by Peter Friese on 22.09.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface BaseUITableViewController : UITableViewController<NSFetchedResultsControllerDelegate, RKObjectLoaderDelegate, UISearchDisplayDelegate> {
}

#pragma mark - Data interface
@property (nonatomic, retain) NSString *resourcePath;

#pragma mark - Search bar
@property (nonatomic, retain) NSDictionary *scopes;
@property (nonatomic, retain) NSString *placeholderText;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedSearchScopeIndex;
@property (nonatomic, copy) NSString *savedSearchScope;
@property (nonatomic) BOOL searchWasActive;

#pragma mark - 
@property (nonatomic, retain) NSString *groupBy;

- (Class)managedObject;
- (void)loadData;

- (void)configureCell:(UITableViewCell *)cell withManagedObject:(NSManagedObject *)managedObject atIndexPath:(NSIndexPath *)indexPath;
- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView;

@end
