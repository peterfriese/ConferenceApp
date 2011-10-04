//
//  SessionTableViewCell.h
//  ConferenceApp
//
//  Created by Peter Friese on 04.10.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SessionTableViewCell : UITableViewCell {
	float height;
}

- (void) setSpeakers:(NSString *)value;
- (void) setSessionTitle:(NSString *)value;
	
- (NSNumber*) height;
- (void) prepare;

@property (nonatomic, retain) IBOutlet UILabel *trackLabel;
@property (nonatomic, retain) IBOutlet UILabel *sessionTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *speakersLabel;
@property (nonatomic, retain) IBOutlet UILabel *roomLabel;
@property (nonatomic, retain) IBOutlet UIView *trackIndicator;

@end
