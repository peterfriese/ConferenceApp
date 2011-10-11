//
//  ScheduleViewController2.m
//  ConferenceApp
//
//  Created by Peter Friese on 10.10.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import "ScheduleViewController2.h"
#import "Session.h"
#import "SessionTableViewCell.h"
#import "UIViewController+NibCells.h"
#import "SessionDetailsViewController.h"
#import "Session+Color.h"

@interface ScheduleViewController2 ()
@property (nonatomic, retain) DateNavigator *dateNavigator;
@property (nonatomic, retain) NSPredicate *datePredicate;
@property (nonatomic, retain) NSPredicate *favoritesPredicate;

@property (nonatomic, retain) UIBarButtonItem *favoritesButton;
@property (nonatomic, retain) UIBarButtonItem *searchButton;
@end


@implementation ScheduleViewController2

@synthesize dateNavigator = _dateNavigator;
@synthesize dates = _dates;
@synthesize date = _date;
@synthesize datePredicate = _datePredicate;
@synthesize displayFavorites = _displayFavorites;
@synthesize favoritesPredicate = _favoritesPredicate;
@synthesize favoritesButton = _favoritesButton;
@synthesize searchButton = _searchButton;

-(id)init {
    if ((self = [super init])) {
        self.title = @"Sessions";
        self.scopes = [NSDictionary dictionaryWithObjectsAndKeys:@"Title", @"title", @"Abstract", @"abstract", nil];
        self.placeholderText = @"Search sessions";
        self.groupBy = @"startTime";
        self.sortBy = @"startTime";
        
        [self.view addSubview:self.dateNavigator];        
        [self.view addSubview:self.tableView];
        
        self.favoritesButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Star"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleFavorites)] autorelease];
        self.navigationItem.rightBarButtonItem = self.favoritesButton;
        
        self.searchButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(toggleSearchBar:)] autorelease];
        self.navigationItem.leftBarButtonItem = self.searchButton;        
    }
    return self;
}

-(UITableView *)instantiateTableView
{
    CGRect dateNavigatorFrame = self.dateNavigator.frame;
    CGRect tableViewFrame = CGRectMake(0, 
                                       dateNavigatorFrame.origin.y + dateNavigatorFrame.size.height, 
                                       320, 
                                       self.view.frame.size.height - dateNavigatorFrame.size.height);
    
    return [[[UITableView alloc] initWithFrame:tableViewFrame] autorelease];
}

-(void)viewDidLoad
{
    [self performSelector:@selector(toggleSearchBar:) withObject:nil afterDelay:2.0];
    [super viewDidLoad];
}

- (void)dealloc
{
    [_dateNavigator release];
    [super dealloc];
}

#pragma mark - Data access

- (NSString *)entityName
{
    return @"Session";
}

- (NSString *)resourcePath
{
    return @"/sessions.json";
}

#pragma mark - DateNavigator delegate methods

- (void)navigateToDate:(NSDate *)date
{
    self.date = date;
}

#pragma mark - Properties

- (void)setDates:(NSArray *)dates
{
    if (dates != _dates) {
        [dates retain];
        [_dates release];
        _dates = dates;
        [self.dateNavigator setDates:_dates];
    }
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

- (void)toggleFavorites {
    self.displayFavorites = !self.displayFavorites;
    if (self.displayFavorites) {
        
        [self.favoritesButton setImage:[UIImage imageNamed:@"StarSelected"]];
    }
    else {
        [self.favoritesButton setImage:[UIImage imageNamed:@"Star"]];
    }
}

#pragma mark - Lazy UI creation

- (DateNavigator *)dateNavigator
{
    if (_dateNavigator == nil) {
        self.dateNavigator = [[[DateNavigator alloc] init] autorelease];
        self.dateNavigator.delegate = self;
    }
    return _dateNavigator;
}


#pragma mark - UITableViewDelegate methods

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *label = @"";
    NSArray *sections = [[self fetchedResultsControllerForTableView:tableView] sections];
    if ([sections count]) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        Session *session = (Session *)[[sectionInfo objects] objectAtIndex:0];
        if (self.searchWasActive) {
            label = [NSString stringWithFormat:@"%@ - %@", [session day], [session timeSlot]];
        }
        else {
            label = [session timeSlot];
        }
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

- (UITableViewCell *)tableView:(UITableView *)tableView instantiateCellForRowAtIndexPath:(NSIndexPath *)indexPath withReuseIdentifier:(NSString *)cellIdentifier
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SessionTableViewCell"];
	if (cell == nil) {
		cell = [self loadReusableTableViewCellFromNibNamed:@"SessionTableViewCell"];
	}
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell withManagedObject:(NSManagedObject *)managedObject atIndexPath:(NSIndexPath *)indexPath
{
    Session *session = (Session*)managedObject;
    
    /*
     cell.textLabel.text = session.title;
     
     NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
     [timeFormatter setDateFormat:@"HH:mm:ss"];
     NSString *startTime = [timeFormatter stringFromDate:[session startTime]];
     NSString *endTime = [timeFormatter stringFromDate:[session endTime]];
     [timeFormatter release];
     cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", startTime, endTime];
     */
    
    
	if ([cell isKindOfClass:[SessionTableViewCell class]]) {
		SessionTableViewCell *sessionCell = (SessionTableViewCell *)cell;
        
		sessionCell.trackLabel.text = [session category];
        
		sessionCell.trackIndicator.backgroundColor = [session sessionColor];

		sessionCell.roomLabel.text = [session room];
		[sessionCell setSessionTitle:session.title];
		
		NSArray *speakerNames = [[session.speakers valueForKey:@"fullName"] allObjects];
		NSString *joinedNames = [speakerNames componentsJoinedByString:@", "];
		[sessionCell setSpeakers:joinedNames];
		
		sessionCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		[sessionCell prepare];
	}
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
	if ([cell isKindOfClass:[SessionTableViewCell class]]) {
		return [[(SessionTableViewCell*)cell height] floatValue];
	}    
    else {
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    Session *session = (Session *)[[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
    SessionDetailsViewController *sessionDetailsViewController = [[SessionDetailsViewController alloc] init];
    sessionDetailsViewController.session = session;
    [self.navigationController pushViewController:sessionDetailsViewController animated:YES];
    [sessionDetailsViewController release];    
}


#pragma mark - UISearchDisplayDelegate methods

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionTransitionNone animations:^(void) {
        CGRect dateNavigatorFrame = self.dateNavigator.frame;
        CGRect tableViewFrame = self.tableView.frame;
        tableViewFrame.origin.y = tableViewFrame.origin.y - dateNavigatorFrame.size.height;
        self.tableView.frame = tableViewFrame;
        //self.dateNavigator.alpha = 0;
        //[self.dateNavigator setHidden:YES];
    } completion:nil];
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionTransitionNone animations:^(void) {
        // [self.dateNavigator setHidden:NO];    
        //self.dateNavigator.alpha = 100;
        
        CGRect dateNavigatorFrame = self.dateNavigator.frame;
        CGRect tableViewFrame = self.tableView.frame;
        tableViewFrame.origin.y = tableViewFrame.origin.y + dateNavigatorFrame.size.height;
        self.tableView.frame = tableViewFrame;    
    } completion:nil];
}

#pragma mark -
#pragma mark -

- (void)toggleSearchBar:(id)sender
{
    CGPoint offset = [self.tableView contentOffset];
    if (offset.y == 0) {
        [self.tableView setContentOffset:CGPointMake(0, 44) animated:YES];
    }
    else {
        [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
        // TODO: Added this for Heiko (see https://github.com/peterfriese/ConferenceApp/issues/44). Not sure if this is the way to go, looks odd.
        if (sender != nil) {
            [self.searchDisplayController.searchBar becomeFirstResponder];
        }        
    }
}

- (NSPredicate *)composePredicates:(NSPredicate *)searchStringPredicate
{
    NSMutableArray *predicates = [[NSMutableArray alloc] init];
    if (searchStringPredicate != nil) {
        [predicates addObject:searchStringPredicate];
    }
    else {
        if (self.datePredicate != nil) {
            [predicates addObject:self.datePredicate];
        }        
    }
    
    if (self.favoritesPredicate != nil) {
        [predicates addObject:self.favoritesPredicate];
    }
    
    NSCompoundPredicate *compoundPredicates = [[[NSCompoundPredicate alloc] initWithType:NSAndPredicateType subpredicates:predicates] autorelease];
    [predicates release];
    return compoundPredicates;
}

@end
