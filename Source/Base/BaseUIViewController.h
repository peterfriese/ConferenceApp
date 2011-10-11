//
//  BaseUIViewController.h
//  ConferenceApp
//
//  Created by Peter Friese on 10.10.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface BaseUIViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, RKObjectLoaderDelegate, UISearchDisplayDelegate>

#pragma mark - TableView
@property (nonatomic, retain) UITableView *tableView;
- (UITableView *)instantiateTableView;

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
@property (nonatomic, retain) NSString *sortBy;

- (Class)managedObject;
- (void)loadData;

- (void)configureCell:(UITableViewCell *)cell withManagedObject:(NSManagedObject *)managedObject atIndexPath:(NSIndexPath *)indexPath;
- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView;
- (NSPredicate *)composePredicates:(NSPredicate *)searchStringPredicate;
- (void)updatePredicates;
- (NSString *)entityName;

@end
