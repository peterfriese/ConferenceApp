//
//  SpeakerTableViewCell.h
//  ConferenceApp
//
//  Created by Peter Friese on 02.02.12.
//  Copyright (c) 2012 http://peterfriese.de. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBAsyncImageView.h"

@interface SpeakerTableViewCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *speakerName;
@property (nonatomic, retain) IBOutlet UILabel *affiliation;
@property (nonatomic, retain) IBOutlet JBAsyncImageView *speakerImage;

@end
