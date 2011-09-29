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


#pragma mark - Private Interface

@interface SessionDetailsViewController()
- (void)updateFavoriteButtonState;
@property (nonatomic, retain) UIBarButtonItem *favoriteButton;
@end

#pragma mark - Implementation

@implementation SessionDetailsViewController

@synthesize track;
@synthesize room;
@synthesize sessionTitle;
@synthesize time;

@synthesize favoriteButton = _favoriteButton;

typedef enum {
    SessionDetailsSectionKindSpeakers = 1,
    SessionDetailsSectionKindAbstract = 0
} SessionDetailsSectionKind;

@synthesize session;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _favoriteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Star"] 
                                                           style:UIBarButtonItemStylePlain 
                                                          target:self 
                                                          action:@selector(toggleFavorite)];
        self.navigationItem.rightBarButtonItem = _favoriteButton;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
    sessionTitle.text = session.title;
    room.text = session.room;
    track.text = session.type;
    time.text = [NSString stringWithFormat:@"%@, %@", session.day, session.timeSlot];
    [self updateFavoriteButtonState];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
            break;
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
            break;
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

            DTAttributedTextCell *attributedCell = (DTAttributedTextCell *)cell;
            
            NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithFloat:1.2], NSTextSizeMultiplierDocumentOption, 
                                     @"Helvetica", DTDefaultFontFamily,  
                                     // @"purple", DTDefaultLinkColor, 
                                     @"http://www.peterfriese.de", NSBaseURLDocumentOption, 
                                     nil]; 
            NSData *data = [session.abstract dataUsingEncoding:NSUTF8StringEncoding];            
            NSAttributedString *string = [[NSAttributedString alloc] initWithHTML:data options:options documentAttributes:NULL];
            [attributedCell setAttributedString:string];
            [string release];
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
    static NSString *CellIdentifier = @"Cell"; // TODO: derive cellidentifier from classname
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [self tableView:tableView instantiateCellForRowAtIndexPath:indexPath withReuseIdentifier:CellIdentifier];
    }
    
    [self tableView:tableView configureCell:cell atIndexPath:indexPath];
    return cell;
}


@end
