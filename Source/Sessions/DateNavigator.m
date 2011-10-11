//
//  DateNavigator.m
//  ConferenceApp
//
//  Created by Peter Friese on 10.10.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import "DateNavigator.h"

#pragma mark - Internal interface

@interface DateNavigator () 
{
    NSInteger currentDateIndex;
}
- (void)updateNavigationUI;
@property (nonatomic, retain) UIImageView *backgroundView;
@property (nonatomic, retain) UILabel *dateLabel;
@property (nonatomic, retain) UIButton *previousDayButton;
@property (nonatomic, retain) UIButton *nextDayButton;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@end


#pragma mark - DateNavigator implementation

@implementation DateNavigator

#pragma mark - UI properties

@synthesize backgroundView = _backgroundView;
@synthesize dateLabel = _dateLabel;
@synthesize previousDayButton = _previousDayButton;
@synthesize nextDayButton = _nextDayButton;
@synthesize dateFormatter = _dateFormatter;

@synthesize delegate = _delegate;
@synthesize date = _date;
@synthesize dates = _dates;

#pragma mark - Lifecycle

-(id)init
{
    return [self initWithFrame:CGRectMake(0, 0, 320, 44)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backgroundView];
        [self addSubview:self.dateLabel];
        [self addSubview:self.previousDayButton];
        [self addSubview:self.nextDayButton];
        [self updateNavigationUI];
    }
    return self;
}

-(void)dealloc
{
    [_dateFormatter release];
    [_dates release];
    [_nextDayButton release];
    [_previousDayButton release];
    [_dateLabel release];
    [_backgroundView release];
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


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
    
    self.date = [self.dates objectAtIndex:currentDateIndex];
    if ([self.delegate conformsToProtocol:@protocol(DateNavigatorDelegate)]) {
        [self.delegate navigateToDate:self.date];
    }
    
	self.dateLabel.text = [self.dateFormatter stringFromDate:self.date];
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

#pragma mark - Lazy construction via property accessors

- (UIImageView *)backgroundView
{
    if (_backgroundView == nil) {
        self.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"topbar"]] autorelease];
    }
    return _backgroundView;
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

- (NSDateFormatter *)dateFormatter
{
    if (_dateFormatter == nil) {
        self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [_dateFormatter setDateFormat:@"EEEE dd"];        
    }
    return _dateFormatter;

}

#pragma mark - Other properties

- (void)setDates:(NSArray *)dates
{
    if (dates != _dates) {
        [dates retain];
        [_dates release];
        _dates = dates;
        [self updateNavigationUI];
    }
}

-(NSDate *)date
{
    return [self.dates objectAtIndex:currentDateIndex];
}

@end
