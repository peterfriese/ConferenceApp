//
//  BaseUITableViewController.m
//  ConferenceApp
//
//  Created by Peter Friese on 22.09.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import "BaseUITableViewController.h"

#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>
#import "Session.h"

@implementation BaseUITableViewController


-(id)init {
    if ((self = [super init])) {
        [self.view addSubview:self.tableView];
    }
    return self;
}

-(UITableView *)instantiateTableView
{
    CGRect frame = CGRectMake(0, 0, 320, 480);
    return [[[UITableView alloc] initWithFrame:frame] autorelease];
}

@end
