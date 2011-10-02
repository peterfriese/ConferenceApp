//
//  SessionTableViewController.m
//  ConferenceApp
//
//  Created by Peter Friese on 22.09.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import "SessionTableViewController.h"
#import "Session.h"
#import "SessionDetailsViewController.h"

@interface SessionTableViewController()
@property (nonatomic, retain) NSPredicate *favoritesPredicate;
@end

@implementation SessionTableViewController

@synthesize favoritesButton = _favoritesButton;
@synthesize displayFavorites = _displayFavorites;
@synthesize favoritesPredicate = _favoritesPredicate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Sessions";
        self.scopes = [NSDictionary dictionaryWithObjectsAndKeys:@"Title", @"title", @"Abstract", @"abstract", nil];
        self.placeholderText = @"Search sessions";
        self.groupBy = @"startTime";
        self.sortBy = @"startTime";
        
        self.displayFavorites = NO;
        self.favoritesButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Star"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleFavorites)];
        self.navigationItem.rightBarButtonItem = self.favoritesButton;
            
        
        /*
        UIToolbar *toolbar = [UIToolbar new];
        toolbar.barStyle = UIBarStyleDefault;
        [toolbar sizeToFit];
        
        NSArray *segments = [NSArray arrayWithObjects:@"Schedule", @"Favorites", nil];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segments];
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        [segmentedControl sizeToFit];
        
        UIBarButtonItem *segmentedToolbarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
        [segmentedControl release];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolbar setItems:[NSArray arrayWithObjects:flexSpace, segmentedToolbarItem, flexSpace, nil]];
        [segmentedControl release];
        
        //Set the frame
        CGFloat toolbarHeight = [toolbar frame].size.height;
        CGRect mainViewBounds = self.view.bounds;
        [toolbar setFrame:CGRectMake(CGRectGetMinX(mainViewBounds), toolbarHeight, CGRectGetWidth(mainViewBounds), toolbarHeight)];
        
        //Here we go
        [self.view addSubview:toolbar];
         */
    }
    return self;
}

-(void)dealloc
{
    [_favoritesButton release];
    [super dealloc];
}

- (void)toggleFavorites {
    self.displayFavorites = !self.displayFavorites;
    if (self.displayFavorites) {
        [self.favoritesButton setImage:[UIImage imageNamed:@"StarSelected"]];
        self.favoritesPredicate = [NSPredicate predicateWithFormat:@"attending == YES"];
        [self updatePredicates];
    }
    else {
        [self.favoritesButton setImage:[UIImage imageNamed:@"Star"]];
        self.favoritesPredicate = nil;
        [self updatePredicates];
    }
}

- (NSPredicate *)composePredicates:(NSPredicate *)searchStringPredicate
{
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    if (searchStringPredicate != nil) {
        [predicates addObject:searchStringPredicate];
    }
    if (self.favoritesPredicate != nil) {
        [predicates addObject:self.favoritesPredicate];
    }
    NSCompoundPredicate *compoundPredicates = [[[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:predicates] autorelease];
    [predicates release];
    return compoundPredicates;
}

- (NSString *)resourcePath
{
    return @"/sessions";
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *sections = [[self fetchedResultsControllerForTableView:tableView] sections];
    if ([sections count]) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        Session *session = (Session *)[[sectionInfo objects] objectAtIndex:0];
        return [session timeSlot];
    }
    return @"";
}

- (void)configureCell:(UITableViewCell *)cell withManagedObject:(NSManagedObject *)managedObject atIndexPath:(NSIndexPath *)indexPath
{
    Session *session = (Session*)managedObject;
    cell.textLabel.text = session.title;

    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm:ss"];
    NSString *startTime = [timeFormatter stringFromDate:[session startTime]];
    NSString *endTime = [timeFormatter stringFromDate:[session endTime]];
    [timeFormatter release];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SessionDetailsViewController *sessionDetailsViewController = [[SessionDetailsViewController alloc] init];
    
    Session *session = (Session *)[[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];    
    sessionDetailsViewController.session = session;
                                            
    [self.navigationController pushViewController:sessionDetailsViewController animated:YES];
    [sessionDetailsViewController release];
}

@end
