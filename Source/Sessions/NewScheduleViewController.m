//
//  NewScheduleViewController.m
//  ConferenceApp
//
//  Created by Peter Friese on 10.10.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import "NewScheduleViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation NewScheduleViewController

@synthesize tableView;
@synthesize dateNavigator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %d|%d", [indexPath section], [indexPath row]];
    return cell;
}

#pragma mark - UISearchDisplayDelegate

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionTransitionNone animations:^(void) {
        CGRect dateNavigatorFrame = self.dateNavigator.frame;
        CGRect tableViewFrame = tableView.frame;
        tableViewFrame.origin.y = tableViewFrame.origin.y - dateNavigatorFrame.size.height;
        tableView.frame = tableViewFrame;
        //self.dateNavigator.alpha = 0;
        //[self.dateNavigator setHidden:YES];
    } completion:nil];
}

- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {    
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionTransitionNone animations:^(void) {
        // [self.dateNavigator setHidden:NO];    
        //self.dateNavigator.alpha = 100;
        
        CGRect dateNavigatorFrame = self.dateNavigator.frame;
        CGRect tableViewFrame = tableView.frame;
        tableViewFrame.origin.y = tableViewFrame.origin.y + dateNavigatorFrame.size.height;
        tableView.frame = tableViewFrame;    
    } completion:nil];
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {    
}


@end
