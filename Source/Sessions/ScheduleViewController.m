//
//  ScheduleViewController.m
//  ConferenceApp
//
//  Created by Peter Friese on 02.10.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import "ScheduleViewController.h"
#import "SessionTableViewController.h"
#import "NSDate+Additions.h"
#import "SessionDetailsViewController.h"

@interface ScheduleViewController() {
    NSInteger currentDateIndex;
}
- (void)updateNavigationUI;
@property (nonatomic, retain) UIView *dateNavigationBar;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UIButton *previousDayButton;
@property (nonatomic, retain) UIButton *nextDayButton;
@property (nonatomic, retain) SessionTableViewController *sessionsViewController;
@property (nonatomic, retain) UIBarButtonItem *searchButton;
@end


@implementation ScheduleViewController

@synthesize dates = _dates;
@synthesize favoritesButton = _favoritesButton;
@synthesize searchButton = _searchButton;

@synthesize dateNavigationBar = _dateNavigationBar;
@synthesize dateLabel = _dateLabel;
@synthesize previousDayButton = _previousDayButton;
@synthesize nextDayButton = _nextDayButton;
@synthesize sessionsViewController = _sessionsViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Schedule";
        currentDateIndex = 0;
        
        [self.view addSubview:self.dateNavigationBar];
        [self.view addSubview:self.dateLabel];
        [self.view addSubview:self.previousDayButton];
        [self.view addSubview:self.nextDayButton];
        [self.view addSubview:self.sessionsViewController.view];
        
        self.favoritesButton = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Star"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleFavorites)] autorelease];
        self.navigationItem.rightBarButtonItem = self.favoritesButton;
        
        self.searchButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(toggleSearchBar)] autorelease];
        self.navigationItem.leftBarButtonItem = self.searchButton;
    }
    return self;
}

- (void)dealloc
{
    [_favoritesButton release];    
    [_sessionsViewController release];
    [_nextDayButton release];
    [_previousDayButton release];
    [_dateLabel release];
    [_dateNavigationBar release];
    [_dates release];
    [super dealloc];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateNavigationUI];    
}

#pragma mark - Search button

- (void)toggleSearchBar
{
    [self.sessionsViewController toggleSearchBar];
}

#pragma mark - Favorites

- (void)toggleFavorites {
    self.sessionsViewController.displayFavorites = !self.sessionsViewController.displayFavorites;
    if (self.sessionsViewController.displayFavorites) {
        
        [self.favoritesButton setImage:[UIImage imageNamed:@"StarSelected"]];
    }
    else {
        [self.favoritesButton setImage:[UIImage imageNamed:@"Star"]];
    }
}

#pragma mark - Navigation buttons

- (void)updateNavigationUI
{
    if (currentDateIndex == 0) {
        [self.previousDayButton setHidden:YES];
    }
    else {
        [self.previousDayButton setHidden:NO];
    }
    
    if (currentDateIndex == [self.dates count] - 1) {
        [self.nextDayButton setHidden:YES];
    }
    else {
        [self.nextDayButton setHidden:NO];
    }
    
    NSDate *date = [self.dates objectAtIndex:currentDateIndex];
    [self.sessionsViewController setDate:date];
    
    // TODO: lazy!
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"EEEE dd"];
	self.dateLabel.text = [formatter stringFromDate:date];
	[formatter release];
}

- (void)navigateToPreviousDay
{
    currentDateIndex -= 1;
    [self updateNavigationUI];
}

- (void)navigateToNextDay
{
    currentDateIndex += 1;
    [self updateNavigationUI];
}

#pragma msrk - Properties

- (UIView *)dateNavigationBar
{
    if (_dateNavigationBar == nil) {
        self.dateNavigationBar = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topbar"]] autorelease];
    }
    return _dateNavigationBar;
}

- (UILabel *)dateLabel
{
    if (_dateLabel == nil) {
        self.dateLabel = [[[UILabel alloc] init] autorelease];
        self.dateLabel.frame = CGRectMake(50, 5, 220, 38);
        self.dateLabel.textAlignment = UITextAlignmentCenter;
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.font = [UIFont boldSystemFontOfSize:22];
        self.dateLabel.textColor = [UIColor colorWithRed:59/255.0 green:73/255.0 blue:88/255.0 alpha:1];
    }
    return _dateLabel;
}

- (UIButton *)previousDayButton
{
    if (_previousDayButton == nil) {
        self.previousDayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.previousDayButton.frame = CGRectMake(2, 2, 44, 44);
        self.previousDayButton.backgroundColor = [UIColor clearColor];
        [self.previousDayButton setImage:[UIImage imageNamed:@"leftArrow"] forState:UIControlStateNormal];
        [self.previousDayButton addTarget:self action:@selector(navigateToPreviousDay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _previousDayButton;
}

- (UIButton *)nextDayButton
{
    if (_nextDayButton == nil) {
        self.nextDayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nextDayButton.frame = CGRectMake(320-44-2, 2, 44, 44);
        self.nextDayButton.backgroundColor = [UIColor clearColor];
        [self.nextDayButton setImage:[UIImage imageNamed:@"rightArrow"] forState:UIControlStateNormal];
        [self.nextDayButton addTarget:self action:@selector(navigateToNextDay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextDayButton;
}

- (SessionTableViewController *)sessionsViewController
{
    if(_sessionsViewController == nil) {
        self.sessionsViewController = [[[SessionTableViewController alloc] init] autorelease];
        self.sessionsViewController.view.frame = CGRectMake(0, 44, 320, 480-64);
        self.sessionsViewController.date = [NSDate dateFromString:@"2011-11-03"];
        self.sessionsViewController.delegate = self;
    }
    return _sessionsViewController;
}

-(void)navigateToSession:(Session *)session
{
    SessionDetailsViewController *sessionDetailsViewController = [[SessionDetailsViewController alloc] init];
    sessionDetailsViewController.session = session;
    [self.navigationController pushViewController:sessionDetailsViewController animated:YES];
    [sessionDetailsViewController release];    
}

@end
