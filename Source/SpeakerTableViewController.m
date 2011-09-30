//
//  SpeakerTableViewController.m
//  ConferenceApp
//
//  Created by Peter Friese on 23.09.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import "SpeakerTableViewController.h"
#import "Speaker.h"

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
    return @"/speakers";
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[self fetchedResultsControllerForTableView:tableView] sectionIndexTitles];
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

-(void)configureCell:(UITableViewCell *)cell withManagedObject:(NSManagedObject *)managedObject atIndexPath:(NSIndexPath *)indexPath
{
    Speaker *speaker = (Speaker *)managedObject;
    cell.textLabel.text = speaker.fullName;
    cell.detailTextLabel.text = speaker.affiliation;
}


@end
