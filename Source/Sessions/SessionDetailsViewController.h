//
//  SessionDetailsViewController.h
//  ConferenceApp
//
//  Created by Peter Friese on 26.09.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"

@interface SessionDetailsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    float height;
}

@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) IBOutlet UILabel *trackLabel;
@property (nonatomic, retain) IBOutlet UILabel *roomLabel;
@property (nonatomic, retain) IBOutlet UILabel *sessionTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UIView *trackIndicator;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIImageView *zigzagView;

@property (nonatomic, retain) Session *session;

@end
