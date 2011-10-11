//
//  NewScheduleViewController.h
//  ConferenceApp
//
//  Created by Peter Friese on 10.10.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewScheduleViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate>

@property (nonatomic, retain) IBOutlet UIView *dateNavigator;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
