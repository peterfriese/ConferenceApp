//
//  SpeakerTableViewController.m
//  ConferenceApp
//
//  Created by Peter Friese on 23.09.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import "SpeakerTableViewController.h"
#import "Speaker.h"
#import "SpeakerDetailsViewController.h"
#import "UIViewController+NibCells.h"
#import "JBAsyncImageView.h"
#import "SpeakerTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Shadow.h"

@implementation SpeakerTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Speakers";
        self.scopes = [NSDictionary dictionaryWithObjectsAndKeys:@"First Name", @"firstName", @"Last Name", @"lastName", @"Company", @"affiliation", nil];
        self.groupBy = @"initial";
        self.sortBy = @"lastName";
        
    }
    return self;
}

-(NSString *)resourcePath
{
    return @"/speakers.json";
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[self fetchedResultsControllerForTableView:tableView] sectionIndexTitles];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *label = @"";
    NSArray *sections = [[self fetchedResultsControllerForTableView:tableView] sections];
    if ([sections count]) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        Speaker *speaker = (Speaker *)[[sectionInfo objects] objectAtIndex:0];
        label = [speaker initial];
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *sections = [[self fetchedResultsControllerForTableView:tableView] sections];
    if ([sections count]) {
        id<NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
        return [sectionInfo name];
    }
    return @"";    
}

- (NSString *)cellIdentifier
{
    static NSString *kCellIdentifier = @"SpeakerTableViewCell";
    return kCellIdentifier;
}

- (NSString *)cellIdentifierForSearch
{
    static NSString *kCellIdentifier = @"SpeakerTableViewCell";
    return kCellIdentifier;
}

- (UITableViewCell *)tableView:(UITableView *)tableView instantiateCellForRowAtIndexPath:(NSIndexPath *)indexPath withReuseIdentifier:(NSString *)cellIdentifier
{
    SpeakerTableViewCell *result = (SpeakerTableViewCell *)[self loadReusableTableViewCellFromNibNamed:cellIdentifier];
    
    // white border
    result.pictureFrame.backgroundColor = [UIColor whiteColor];
    result.pictureFrame.layer.borderColor = [UIColor whiteColor].CGColor;
    result.pictureFrame.layer.borderWidth = 1.0;    
    result.pictureFrame.layer.cornerRadius = 4.0;

    [result.pictureFrame curlyShadowWithColor:[UIColor blackColor] 
                                       radius:1.0f
                                       offset:2.0f 
                                   curlFactor:5 
                                  shadowDepth:1.0f];
    
    return result;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}


-(void)configureCell:(UITableViewCell *)cell withManagedObject:(NSManagedObject *)managedObject atIndexPath:(NSIndexPath *)indexPath
{
    Speaker *speaker = (Speaker *)managedObject;
    
    SpeakerTableViewCell *speakerCell = (SpeakerTableViewCell *)cell;
    speakerCell.speakerName.text = speaker.fullName;
    speakerCell.affiliation.text = speaker.affiliation;
    
    [speakerCell.speakerImage cancel];
    speakerCell.speakerImage.image = nil;
    if ([speaker.picture length] > 0) {
        speakerCell.speakerImage.cachesImage = YES;
        speakerCell.speakerImage.imageURL = [NSURL URLWithString:speaker.picture];
    }
    else {
        speakerCell.speakerImage.image = [UIImage imageNamed:@"111-user.png"];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];    
    Speaker *speaker = (Speaker *)[[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
    SpeakerDetailsViewController *speakerDetailsViewController = [[SpeakerDetailsViewController alloc] init];
    [speakerDetailsViewController setSpeaker:speaker];
    [self.navigationController pushViewController:speakerDetailsViewController animated:YES];
    [speakerDetailsViewController release];
}


@end
