//
//  SessionDetailsViewController.m
//  ConferenceApp
//
//  Created by Peter Friese on 26.09.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import "SessionDetailsViewController.h"
#import "Speaker.h"
#import "DTAttributedTextCell.h"
#import "NSAttributedString+html.h"
#import "DTAttributedTextContentView.h"
#import <RestKit/RestKit.h>
#import "Session+Color.h"
#import "SpeakerDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Shadow.h"

static int const kMargin = 5;
static int const kBottomMargin = 10;

#pragma mark - Private Interface

@interface SessionDetailsViewController()
- (void)updateFavoriteButtonState;
- (void) updateHeaderDimensions ;
@property (nonatomic, retain) UIBarButtonItem *favoriteButton;
@end

#pragma mark - Implementation

@implementation SessionDetailsViewController

@synthesize headerView = _headerView;
@synthesize trackLabel = _trackLabel;
@synthesize roomLabel = _roomLabel;
@synthesize sessionTitleLabel = _sessionTitleLabel;
@synthesize timeLabel = _timeLabel;
@synthesize trackIndicator = _trackIndicator;
@synthesize tableView = _tableView;
@synthesize zigzagView = _zigzagView;

@synthesize favoriteButton = _favoriteButton;

typedef enum {
    SessionDetailsSectionKindAbstract = 0,    
    SessionDetailsSectionKindSpeakers = 1
} SessionDetailsSectionKind;

@synthesize session;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Session";
        _favoriteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Star"] 
                                                           style:UIBarButtonItemStylePlain 
                                                          target:self 
                                                          action:@selector(toggleFavorite)];
        self.navigationItem.rightBarButtonItem = _favoriteButton;
    }
    return self;
}

-(void)dealloc
{
    [_favoriteButton release];
    [super dealloc];
}

#pragma mark - Favorites

- (void)updateFavoriteButtonState
{
    if ([session.attending boolValue]) {
        [_favoriteButton setImage:[UIImage imageNamed:@"StarSelected"]];
    }
    else {
        [_favoriteButton setImage:[UIImage imageNamed:@"Star"]];
    }    
}

- (void)toggleFavorite {
    session.attending = [NSNumber numberWithBool:![session.attending boolValue]];
    [[[RKObjectManager sharedManager] objectStore] save];
    
    [self updateFavoriteButtonState];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sessionTitleLabel.text = session.title;
    self.roomLabel.text = session.room;
    self.trackLabel.text = session.type;
    self.timeLabel.text = [NSString stringWithFormat:@"%@, %@", session.day, session.timeSlot];
    self.trackIndicator.backgroundColor = session.sessionColor;

    [self.zigzagView shadow];
    
    [self updateFavoriteButtonState];
    [self updateHeaderDimensions];
}

#pragma mark - View Header

- (CGSize) dimensionsForLabel:(UILabel *)label 
{
	float boundsWidth = self.headerView.bounds.size.width - label.frame.origin.x - kMargin;
    /*
	if (self.accessoryView != nil)
		boundsWidth -= self.accessoryView.bounds.size.width;
	if (self.accessoryType != UITableViewCellAccessoryNone)
		boundsWidth -= 50.0;
     */
	CGSize size = [label.text sizeWithFont:label.font
						 constrainedToSize:CGSizeMake(boundsWidth, 1000.0)
							 lineBreakMode:UILineBreakModeWordWrap];
	
	
	return size;
}

- (void) updateHeaderDimensions 
{
	CGSize sessionDimensions = [self dimensionsForLabel:self.sessionTitleLabel];
	self.sessionTitleLabel.frame = CGRectMake(self.sessionTitleLabel.frame.origin.x, 
										 self.trackLabel.frame.origin.y + self.trackLabel.frame.size.height + kMargin, 
										 sessionDimensions.width,
										 sessionDimensions.height);
	self.timeLabel.frame = CGRectMake(self.timeLabel.frame.origin.x, 
								 self.sessionTitleLabel.frame.origin.y + self.sessionTitleLabel.frame.size.height + kMargin,
								 self.timeLabel.frame.size.width, 
								 self.timeLabel.frame.size.height);
	
	height = self.timeLabel.frame.size.height + self.timeLabel.frame.origin.y + kBottomMargin;
    
    [self.headerView setFrame:CGRectMake(0, 0, 320, height)];
    
    [self.tableView setFrame:CGRectMake(0, height, 320, 460 - height)];
    [self.zigzagView setFrame:CGRectMake(0, 
                                         height - self.zigzagView.frame.size.height + 10, 
                                         self.zigzagView.frame.size.width, 
                                         self.zigzagView.frame.size.height)];
}

- (NSNumber*) height 
{
	return [NSNumber numberWithFloat:height];
}

- (NSUInteger) numberOfLines:(NSString *)value 
{
	NSString *countString = @"";
	NSScanner *scanner = [NSScanner scannerWithString:value];
	[scanner scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"] intoString:&countString];
	return [countString length];
}

- (void) setSessionTitle:(NSString *)value 
{
	self.sessionTitleLabel.lineBreakMode = UILineBreakModeWordWrap;
	self.sessionTitleLabel.text = value;		
	self.sessionTitleLabel.numberOfLines = [self numberOfLines:value];
}

#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case SessionDetailsSectionKindAbstract:
            return @"Abstract";
            
        case SessionDetailsSectionKindSpeakers:
            return @"Presenters";
            
        default:
            return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case SessionDetailsSectionKindAbstract:
            return 1;
            
        case SessionDetailsSectionKindSpeakers:
        {
            NSUInteger count = [session.speakers count];
            return count;
        }
            
        default:
            return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView instantiateCellForRowAtIndexPath:(NSIndexPath *)indexPath withReuseIdentifier:(NSString *)cellIdentifier
{
    UITableViewCell *cell = nil;
    
    switch ([indexPath section]) {
        case SessionDetailsSectionKindAbstract:
            cell = [[[DTAttributedTextCell alloc] initWithReuseIdentifier:cellIdentifier accessoryType:UITableViewCellAccessoryNone] autorelease];
            DTAttributedTextCell *attributedCell = (DTAttributedTextCell *)cell;
            attributedCell.selectionStyle = UITableViewCellSelectionStyleNone;            
            break;
            
        case SessionDetailsSectionKindSpeakers:
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath section]) {
        case SessionDetailsSectionKindAbstract:
        {
            if ([cell isKindOfClass:[DTAttributedTextCell class]]) {
                DTAttributedTextCell *attributedCell = (DTAttributedTextCell *)cell;
                
                NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithFloat:1.2], NSTextSizeMultiplierDocumentOption, 
                                         @"Helvetica", DTDefaultFontFamily,  
                                         // @"purple", DTDefaultLinkColor, 
                                         // @"http://www.peterfriese.de", NSBaseURLDocumentOption, 
                                         nil]; 
                NSData *data = [session.abstract dataUsingEncoding:NSUTF8StringEncoding];
                NSAttributedString *string = [[NSAttributedString alloc] initWithHTML:data options:options documentAttributes:NULL];
                [attributedCell setAttributedString:string];
                [string release];                
            }
            break;
        }
            
        case SessionDetailsSectionKindSpeakers:
        {
            NSArray *speakers = [session.speakers allObjects];
            Speaker *speaker = [speakers objectAtIndex:[indexPath row]];
            cell.textLabel.text = [speaker fullName];
            cell.detailTextLabel.text = [speaker affiliation];
            break;
        }
            
        default:
            cell.textLabel.text = @"Dummy";            
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=  [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[DTAttributedTextCell class]]) {
        DTAttributedTextCell *cell = (DTAttributedTextCell *) [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.attributedTextContextView.bounds.size.height; // for cell seperator
    }
    else {
        return cell.bounds.size.height;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = nil;
    switch ([indexPath section]) {
        case SessionDetailsSectionKindAbstract:
            cellIdentifier = @"SessionDetailsCellAbstract";
            break;
            
        case SessionDetailsSectionKindSpeakers:
            cellIdentifier = @"SessionDetailsCellSpeaker";
            break;
            
        default:
            break;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [self tableView:tableView instantiateCellForRowAtIndexPath:indexPath withReuseIdentifier:cellIdentifier];
    }
    
    [self tableView:tableView configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == SessionDetailsSectionKindSpeakers) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        Speaker *speaker = [[[session speakers] allObjects] objectAtIndex:[indexPath row]];
        SpeakerDetailsViewController *speakerDetailsViewController = [[SpeakerDetailsViewController alloc] init];
        speakerDetailsViewController.speaker = speaker;
        [self.navigationController pushViewController:speakerDetailsViewController animated:YES];
        [speakerDetailsViewController release];
    }
}


@end
