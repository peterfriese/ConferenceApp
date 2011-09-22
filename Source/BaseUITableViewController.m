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
@end


@implementation BaseUITableViewController

#pragma mark - View lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
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
            ? [[NSClassFromString(name) alloc] init] 
            : nil;
}

- (Class)managedObjectClass
{
    return [[self managedObject] class];
}

#pragma mark - Data handling

@synthesize resourcePath = _resourcePath;

- (void)loadData {
    // Load the object model via RestKit	
    RKObjectManager* objectManager = [RKObjectManager sharedManager];
    [objectManager loadObjectsAtResourcePath:[self resourcePath] delegate:self block:^(RKObjectLoader* loader) {
        // Twitter returns statuses as a naked array in JSON, so we instruct the loader
        // to user the appropriate object mapping
        loader.objectMapping = [objectManager.mappingProvider objectMappingForClass:[self managedObjectClass]];
    }];
}

- (void)loadObjectsFromDataStore 
{
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Failed to fetch data.");
     }
}

#pragma mark RKObjectLoaderDelegate methods

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
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

- (NSFetchedResultsController *)createFetchedResultsController
{
    return [[self managedObjectClass] fetchRequestAllGroupedBy:@"startTime" 
                                            withPredicate:nil
                                                 sortedBy:@"startTime" 
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

- (NSFetchedResultsController *)filteredFetchedResultsController
{
    if (_filteredFetchedResultsController == nil) {
        self.filteredFetchedResultsController = [self createFetchedResultsController];
    }
    return _filteredFetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
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


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *sections = [[self fetchedResultsControllerForTableView:tableView] sections];
    if ([sections count]) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        return [sectionInfo name];
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView instantiateCellForRowAtIndexPath:(NSIndexPath *)indexPath withReuseIdentifier:(NSString *)cellIdentifier
{
    return [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
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
    
    NSManagedObject *managedObject = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
    [self configureCell:cell withManagedObject:managedObject atIndexPath:indexPath];
    
    return cell;
}

@end
