//
//  SessionDetailsViewController.h
//  ConferenceApp
//
//  Created by Peter Friese on 26.09.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Speaker.h"
#import "JBAsyncImageView.h"

@interface SpeakerDetailsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate> {
    float height;
}

@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) IBOutlet UILabel *speakernameLabel;
@property (nonatomic, retain) IBOutlet UILabel *affiliationLabel;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIImageView *zigzagView;
@property (retain, nonatomic) IBOutlet UIView *pictureFrame;
@property (nonatomic, retain) IBOutlet JBAsyncImageView *photoView;

@property (nonatomic, retain) Speaker *speaker;

@end
