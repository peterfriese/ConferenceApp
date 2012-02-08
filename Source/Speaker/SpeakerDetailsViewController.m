//
//  SessionDetailsViewController.m
//  ConferenceApp
//
//  Created by Peter Friese on 26.09.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import "SpeakerDetailsViewController.h"
#import "Speaker.h"
#import "DTAttributedTextCell.h"
#import "NSAttributedString+html.h"
#import "DTAttributedTextContentView.h"
#import <RestKit/RestKit.h>
#import "Session+Color.h"
#import "UIImage+Blocks.h"
#import "SessionDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Shadow.h"

static int const kMargin = 5;
static int const kBottomMargin = 10;

#pragma mark - Private Interface

@interface SpeakerDetailsViewController()
- (void) updateHeaderDimensions;
@end

#pragma mark - Implementation

@implementation SpeakerDetailsViewController

@synthesize headerView = _headerView;
@synthesize speakernameLabel = _speakernameLabel;
@synthesize affiliationLabel = _affiliationLabel;
@synthesize tableView = _tableView;
@synthesize zigzagView = _zigzagView;
@synthesize pictureFrame = _pictureFrame;
@synthesize photoView = _photoView;

typedef enum {
    SessionDetailsSectionKindBio = 0,    
    SessionDetailsSectionKindSessions = 1
} SessionDetailsSectionKind;

@synthesize speaker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Speaker";
        
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.speakernameLabel.text = speaker.fullName;
    self.affiliationLabel.text = speaker.affiliation;
    
    [self.zigzagView shadow];
    
    [self.photoView cancel];
    if ([speaker.picture length] > 0) {
        self.photoView.cachesImage = YES;
        self.photoView.imageURL = [NSURL URLWithString:speaker.picture];
    }
    else {
        self.photoView.image = [UIImage imageNamed:@"111-user.png"];
    }
    
    // white border
    self.pictureFrame.backgroundColor = [UIColor whiteColor];
    self.pictureFrame.layer.borderColor = [UIColor whiteColor].CGColor;
    self.pictureFrame.layer.borderWidth = 1.0;    
    self.pictureFrame.layer.cornerRadius = 5.0;
    
    self.photoView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.photoView.layer.borderWidth = 1.0;
    
    // curly shadow
    [self.pictureFrame curlyShadow];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - View Header

- (CGSize) dimensionsForLabel:(UILabel *)label 
{
	float boundsWidth = self.headerView.bounds.size.width - label.frame.origin.x - kMargin;
	CGSize size = [label.text sizeWithFont:label.font
						 constrainedToSize:CGSizeMake(boundsWidth, 1000.0)
							 lineBreakMode:UILineBreakModeWordWrap];
	return size;
}

- (void) updateHeaderDimensions 
{
	CGSize sessionDimensions = [self dimensionsForLabel:self.speakernameLabel];
	self.speakernameLabel.frame = CGRectMake(self.speakernameLabel.frame.origin.x, 
										 self.speakernameLabel.frame.origin.y, 
										 sessionDimensions.width,
										 sessionDimensions.height);
	self.affiliationLabel.frame = CGRectMake(self.affiliationLabel.frame.origin.x, 
								 self.speakernameLabel.frame.origin.y + self.speakernameLabel.frame.size.height + kMargin,
								 self.affiliationLabel.frame.size.width, 
								 self.affiliationLabel.frame.size.height);
	
	height = self.affiliationLabel.frame.size.height + self.affiliationLabel.frame.origin.y + kBottomMargin;
    
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

#pragma mark - Table View Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case SessionDetailsSectionKindBio:
            return @"Bio";
            
        case SessionDetailsSectionKindSessions:
            return @"Sessions";
            
        default:
            return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case SessionDetailsSectionKindBio:
            return 1;
            
        case SessionDetailsSectionKindSessions:
        {
            NSUInteger count = [speaker.sessions count];
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
        case SessionDetailsSectionKindBio:
            cell = [[[DTAttributedTextCell alloc] initWithReuseIdentifier:cellIdentifier accessoryType:UITableViewCellAccessoryNone] autorelease];
            DTAttributedTextCell *attributedCell = (DTAttributedTextCell *)cell;
            attributedCell.selectionStyle = UITableViewCellSelectionStyleNone;            
            break;
            
        case SessionDetailsSectionKindSessions:
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath section]) {
        case SessionDetailsSectionKindBio:
        {
            if ([cell isKindOfClass:[DTAttributedTextCell class]]) {
                DTAttributedTextCell *attributedCell = (DTAttributedTextCell *)cell;
                
                NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithFloat:1.2], NSTextSizeMultiplierDocumentOption, 
                                         @"Helvetica", DTDefaultFontFamily,  
                                         // @"purple", DTDefaultLinkColor, 
                                         // @"http://www.peterfriese.de", NSBaseURLDocumentOption, 
                                         nil]; 
                NSData *data = [speaker.bio dataUsingEncoding:NSUTF8StringEncoding];            
                NSAttributedString *string = [[NSAttributedString alloc] initWithHTML:data options:options documentAttributes:NULL];
                [attributedCell setAttributedString:string];
                [string release];
            }
            break;
        }
            
        case SessionDetailsSectionKindSessions:
        {
            NSArray *sessions = [speaker.sessions allObjects];
            Session *session = [sessions objectAtIndex:[indexPath row]];
            cell.textLabel.text = [session title];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", [session day], [session timeSlot]];
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
        case SessionDetailsSectionKindBio:
            cellIdentifier = @"SessionDetailsCellBio";
            break;
            
        case SessionDetailsSectionKindSessions:
            cellIdentifier = @"SessionDetailsCellSessions";
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
    if ([indexPath section] == SessionDetailsSectionKindSessions) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        Session *session = (Session *)[[[self.speaker sessions] allObjects] objectAtIndex:[indexPath row]];
        SessionDetailsViewController *sessionDetailsViewController = [[SessionDetailsViewController alloc] init];
        sessionDetailsViewController.session = session;
        [self.navigationController pushViewController:sessionDetailsViewController animated:YES];
        [sessionDetailsViewController release];
    }
}

- (void)dealloc {
    [_pictureFrame release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setPictureFrame:nil];
    [super viewDidUnload];
}
@end
