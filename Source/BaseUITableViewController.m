//
//  BaseUITableViewController.m
//  ConferenceApp
//
//  Created by Peter Friese on 22.09.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import "BaseUITableViewController.h"

#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>
#import "Session.h"

@interface BaseUITableViewController()
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *filteredFetchedResultsController;
@property (nonatomic, retain) UISearchDisplayController *searchDisplayController;

- (void)setupSearchBar;
- (void)loadObjectsFromDataStore;
@end

@implementation BaseUITableViewController

#pragma mark - View lifecycle

- (id)init 
{
    if ((self = [super init])) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:RKReachabilityStateChangedNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)reachabilityChanged:(NSNotification*)notification {
    RKReachabilityObserver* observer = (RKReachabilityObserver*)[notification object];
    
    if ([observer isNetworkReachable]) {
        [self loadData];
    } 
    else {
    }
}

-(void)viewDidLoad
{
    [self setupSearchBar];
    [super viewDidLoad];
    [self loadObjectsFromDataStore];
}

#pragma mark - Search bar

@synthesize scopes = _scopes;
@synthesize placeholderText = _placeholderText;
@synthesize searchDisplayController;
@synthesize searchWasActive = _searchWasActive;
@synthesize savedSearchTerm = _savedSearchTerm;
@synthesize savedSearchScopeIndex = _savedSearchScopeIndex;
@synthesize savedSearchScope = _savedSearchScope;

- (void)setupSearchBar
{
    UISearchBar *searchBar = [[[UISearchBar alloc] init] autorelease];
	searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	[searchBar sizeToFit];
	if (self.scopes != nil) {
		searchBar.scopeButtonTitles = [self.scopes allValues];
	}
	if (self.placeholderText != nil) {
		searchBar.placeholder = self.placeholderText;
	}
	self.tableView.tableHeaderView = searchBar;	
    
	// create search display controller (CAVE: requires iOS 4.x)
	self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
	self.searchDisplayController.delegate = self;	
	self.searchDisplayController.searchResultsDataSource = self;
	self.searchDisplayController.searchResultsDelegate = self;    
}


-(void) searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView {
	self.searchWasActive = NO;
	self.savedSearchTerm = nil;
	self.savedSearchScope = nil;
	self.savedSearchScopeIndex = -1;
	self.filteredFetchedResultsController.delegate = nil;
	self.filteredFetchedResultsController = nil;
}

-(BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	self.searchWasActive = YES;
	self.savedSearchTerm = searchString;
	self.savedSearchScopeIndex = self.searchDisplayController.searchBar.selectedScopeButtonIndex;
    if ([self.searchDisplayController.searchBar.scopeButtonTitles count]) {
        self.savedSearchScope = [[self.scopes allKeys] objectAtIndex:[self savedSearchScopeIndex]];
    }
	self.filteredFetchedResultsController.delegate = nil;
	self.filteredFetchedResultsController = nil;	
    
	// by returning YES, we make sure the table view gets reloaded:
	return YES;
}

-(BOOL) searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
	self.searchWasActive = YES;
	self.savedSearchTerm = self.searchDisplayController.searchBar.text;
	self.savedSearchScopeIndex = searchOption;
    if ([self.searchDisplayController.searchBar.scopeButtonTitles count]) {
        self.savedSearchScope = [[self.scopes allKeys] objectAtIndex:[self savedSearchScopeIndex]];
    }
	self.filteredFetchedResultsController.delegate = nil;
	self.filteredFetchedResultsController = nil;
    
    
	// by returning YES, we make sure the table view gets reloaded:	
	return YES;	
}

#pragma mark - Entity

- (NSString *)entityName
{
	NSMutableString *className = [NSMutableString stringWithString:NSStringFromClass([self class])];
	NSRange match = [className rangeOfString:@"UITableViewController"];
	if (match.location == NSNotFound) {
		match = [className rangeOfString:@"UIViewController"];
        if(match.location == NSNotFound) {
            match = [className rangeOfString:@"TableViewController"];
            if (match.location == NSNotFound) {
                match = [className rangeOfString:@"ViewController"];
            }            
        }
	}
	if (match.location != NSNotFound) {
		[className deleteCharactersInRange:match];
        // TODO: check if class available AND subclass of NSManagedObject. If not, depluralize and try again
		NSLog(@"Entity name: %@", className);
		return className;
	}
	[NSException raise:@"EntityNameException" 
                format:@"You need to override BaseUITableViewController:entityName or name your controller <EntityName>UIViewController, <EntityName>ViewController or <EntityName>UITableViewController!"];
	return nil;
}

- (NSManagedObject *)managedObject
{
    NSString *name = [self entityName];
    return 
        (name != nil) 
            ? [[[NSClassFromString(name) alloc] init] autorelease]
            : nil;
}

- (Class)managedObjectClass
{
    NSString *name = [self entityName];
    return (name != nil)
        ? NSClassFromString(name)
        : nil;
}

#pragma mark - Data handling

@synthesize resourcePath = _resourcePath;

- (void)loadData {
    // Load the object model via RestKit
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    
    if ([objectManager isOnline]) {
//        [objectManager loadObjectsAtResourcePath:[self resourcePath] delegate:self];
        [objectManager loadObjectsAtResourcePath:[self resourcePath] delegate:self block:^(RKObjectLoader* loader) {
            // Twitter returns statuses as a naked array in JSON, so we instruct the loader
            // to user the appropriate object mapping
            loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[[self managedObjectClass] class]];
        }];
    }
    else {
        [self loadObjectsFromDataStore];
    }
    
}

- (void)loadObjectsFromDataStore 
{
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Failed to fetch data.");
     }
}

#pragma mark - RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
    NSLog(@"Loaded %d objects: %@", [objects count], objects);
	[self loadObjectsFromDataStore];
	[self.tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
	UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" 
                                                     message:[error localizedDescription] 
                                                    delegate:nil 
                                           cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];
	NSLog(@"Hit error: %@", error);
}

#pragma mark - NSFetchedResultsController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize filteredFetchedResultsController = _filteredFetchedResultsController;
@synthesize groupBy = _groupBy;
@synthesize sortBy = _sortBy;

- (NSFetchedResultsController *)createFetchedResultsController
{
    return [[self managedObjectClass] fetchRequestAllGroupedBy:self.groupBy 
                                            withPredicate:nil
                                                 sortedBy:self.sortBy
                                                ascending:YES];
}

- (NSFetchedResultsController *)createFetchedResultsControllerWithSearchPredicate:(NSPredicate *)predicate
{
    return [[self managedObjectClass] fetchRequestAllGroupedBy:self.groupBy 
                                                 withPredicate:predicate
                                                      sortedBy:self.sortBy
                                                     ascending:YES];
}

- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView
{
    if (tableView == self.tableView) {
        return self.fetchedResultsController;
    }
    else {
        return self.filteredFetchedResultsController;
    }
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController == nil) {
        self.fetchedResultsController = [self createFetchedResultsController];
    }
    return _fetchedResultsController;
}

- (NSPredicate *)predicateForSearchString:(NSString *)searchString scope:(NSString *)scope {
    // TODO: make sure this also works when we do not have a scopes bar (need to search SELF then)
	//return [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", [scope lowercaseString], searchString];
    return [NSPredicate predicateWithFormat:@"%K CONTAINS[cd] %@", scope, searchString];
}

- (NSFetchedResultsController *)filteredFetchedResultsController
{
    if (_filteredFetchedResultsController == nil) {
        NSPredicate *searchPredicate = [self predicateForSearchString:_savedSearchTerm scope:self.savedSearchScope];
        self.filteredFetchedResultsController = [self createFetchedResultsControllerWithSearchPredicate:searchPredicate];
        NSError *error;
        [[self filteredFetchedResultsController] performFetch:&error];
    }
    return _filteredFetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type 
{
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:sectionIndex];
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertSections:set withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteSections:set withRowAnimation:UITableViewRowAnimationFade];
            
        default:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tv = [self tableView];
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tv insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tv cellForRowAtIndexPath:indexPath] withManagedObject:nil atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tv insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            break;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSUInteger count = [[[self fetchedResultsControllerForTableView:tableView] sections] count];
    return 
        (count == 0)
            ? 1
            : count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sections = [[self fetchedResultsControllerForTableView:tableView] sections];
    if ([sections count]) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView instantiateCellForRowAtIndexPath:(NSIndexPath *)indexPath withReuseIdentifier:(NSString *)cellIdentifier
{
    return [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
}

- (void)tableView:(UITableView *)tableView configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *managedObject = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
    [self configureCell:cell withManagedObject:managedObject atIndexPath:indexPath];
}

- (void)configureCell:(UITableViewCell *)cell withManagedObject:(NSManagedObject *)managedObject atIndexPath:(NSIndexPath *)indexPath
{
    // subclasses should implement this method
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell"; // TODO: derive cellidentifier from classname
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [self tableView:tableView instantiateCellForRowAtIndexPath:indexPath withReuseIdentifier:CellIdentifier];
    }
    
    [self tableView:tableView configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - Memory management
-(void)dealloc
{
    [_groupBy release];
    [_scopes release];
    [_placeholderText release];
    [_fetchedResultsController release];
    [_filteredFetchedResultsController release];
    [searchDisplayController release];
    [super dealloc];
}



@end
