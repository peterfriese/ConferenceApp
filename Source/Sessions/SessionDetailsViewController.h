//
//  SessionDetailsViewController.h
//  ConferenceApp
//
//  Created by Peter Friese on 26.09.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"

@interface SessionDetailsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UILabel *track;
@property (nonatomic, retain) IBOutlet UILabel *room;
@property (nonatomic, retain) IBOutlet UILabel *sessionTitle;
@property (nonatomic, retain) IBOutlet UILabel *time;
@property (nonatomic, retain) IBOutlet UIView *trackIndicator;

@property (nonatomic, retain) Session *session;

@end
