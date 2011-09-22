//
//  SessionTableViewController.m
//  ConferenceApp
//
//  Created by Peter Friese on 22.09.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import "SessionTableViewController.h"
#import "Session.h"

@implementation SessionTableViewController

- (NSString *)resourcePath
{
    return @"/sessions.json";
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

@end
