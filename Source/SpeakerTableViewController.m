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
        self.groupBy = @"lastName";
    }
    return self;
}

-(NSString *)resourcePath
{
    return @"/speakers.json";
}

-(void)configureCell:(UITableViewCell *)cell withManagedObject:(NSManagedObject *)managedObject atIndexPath:(NSIndexPath *)indexPath
{
    Speaker *speaker = (Speaker *)managedObject;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [speaker firstName], [speaker lastName]];
    cell.detailTextLabel.text = speaker.affiliation;
}


@end
