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
@property (nonatomic, retain) NSPredicate *datePredicate;
@end

@implementation SessionTableViewController

@synthesize displayFavorites = _displayFavorites;
@synthesize favoritesPredicate = _favoritesPredicate;
@synthesize delegate = _delegate;

@synthesize date = _date;
@synthesize datePredicate = _datePredicate;

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
    }
    return self;
}

-(void)viewDidLoad
{
    [self performSelector:@selector(toggleSearchBar) withObject:nil afterDelay:2.0];
    [super viewDidLoad];
}

- (void)toggleSearchBar
{
    CGPoint offset = [self.tableView contentOffset];
    if (offset.y == 0) {
        [self.tableView setContentOffset:CGPointMake(0, 44) animated:YES];
    }
    else {
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
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
    if (self.datePredicate != nil) {
        [predicates addObject:self.datePredicate];
    }
    NSCompoundPredicate *compoundPredicates = [[[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:predicates] autorelease];
    [predicates release];
    return compoundPredicates;
}

- (NSString *)resourcePath
{
    return @"/sessions";
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *label = @"";
    NSArray *sections = [[self fetchedResultsControllerForTableView:tableView] sections];
    if ([sections count]) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        Session *session = (Session *)[[sectionInfo objects] objectAtIndex:0];
        label = [session timeSlot];
    }
    
    
    UIView* customView = [[[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)] autorelease];
    customView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"section_grained_opa90"]];
    
    UILabel * headerLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    headerLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    headerLabel.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    headerLabel.frame = CGRectMake(11,-11, 320.0, 44.0);
    headerLabel.textAlignment = UITextAlignmentLeft;
    headerLabel.text = label;
    [customView addSubview:headerLabel];
    return customView;    
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
    Session *session = (Session *)[[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
    if ([_delegate conformsToProtocol:@protocol(SessionNavigationDelegate)]) {
        [_delegate navigateToSession:session];
    }
}

#pragma mark - Properties

- (void)setDisplayFavorites:(BOOL)displayFavorites
{
    _displayFavorites = displayFavorites;
    if (_displayFavorites == YES) {
        self.favoritesPredicate = [NSPredicate predicateWithFormat:@"attending == YES"];
    }
    else {
        self.favoritesPredicate = nil;
    }
    [self updatePredicates];    
}

- (void)setDate:(NSDate *)date
{
    if (_date != date) {
        [_date release];
        _date = [date retain];
        self.datePredicate = [NSPredicate predicateWithFormat:@"date == %@", _date];
        [self updatePredicates];
    }
}

@end
