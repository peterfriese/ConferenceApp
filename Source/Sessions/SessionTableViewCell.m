//
//  SessionTableViewCell.m
//  ConferenceApp
//
//  Created by Peter Friese on 04.10.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//


#import "SessionTableViewCell.h"


@implementation SessionTableViewCell

@synthesize trackLabel = _trackLabel;
@synthesize sessionTitleLabel = _sessionTitleLabel;
@synthesize speakersLabel = _speakersLabel;
@synthesize roomLabel = _roomLabel;
@synthesize trackIndicator = _trackIndicator;

static int const kMargin = 5;

- (void)dealloc {
	[_trackLabel release];
	[_sessionTitleLabel release];
	[_speakersLabel release];
	[_roomLabel release];
	[_trackIndicator release];
    [super dealloc];
}

- (CGSize) dimensionsForLabel:(UILabel *)label {
    float boundsWidth = self.bounds.size.width;
	if (self.accessoryView != nil)
		boundsWidth -= self.accessoryView.bounds.size.width;
	if (self.accessoryType != UITableViewCellAccessoryNone)
		boundsWidth -= 50.0;
	CGSize size = [label.text sizeWithFont:label.font
						 constrainedToSize:CGSizeMake(boundsWidth, 1000.0)
							 lineBreakMode:UILineBreakModeWordWrap];
	return size;
}

- (void) prepare {
	CGSize sessionDimensions = [self dimensionsForLabel:self.sessionTitleLabel];
	self.sessionTitleLabel.frame = CGRectMake(self.sessionTitleLabel.frame.origin.x, 
									 self.trackLabel.frame.origin.y + self.trackLabel.frame.size.height + kMargin, 
									 sessionDimensions.width, 
									 sessionDimensions.height);
	
	CGSize speakersDimensions = [self dimensionsForLabel:self.speakersLabel];
	self.speakersLabel.frame = CGRectMake(self.speakersLabel.frame.origin.x, 
									 self.sessionTitleLabel.frame.origin.y + self.sessionTitleLabel.frame.size.height + kMargin, 
									 speakersDimensions.width, 
									 speakersDimensions.height);
	
	height = self.speakersLabel.frame.size.height + self.speakersLabel.frame.origin.y + kMargin;
}

- (NSNumber*) height {
	return [NSNumber numberWithFloat:height];
}

- (NSUInteger) numberOfLines:(NSString *)value {
	NSString *countString = @"";
	NSScanner *scanner = [NSScanner scannerWithString:value];
	[scanner scanCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"] intoString:&countString];
	return [countString length];
}

- (void) setSpeakers:(NSString *)value {
	self.speakersLabel.lineBreakMode = UILineBreakModeWordWrap;
	self.speakersLabel.text = value;		
	self.speakersLabel.numberOfLines = [self numberOfLines:value];
}

- (void) setSessionTitle:(NSString *)value {
	self.sessionTitleLabel.lineBreakMode = UILineBreakModeWordWrap;
	self.sessionTitleLabel.text = value;		
	self.sessionTitleLabel.numberOfLines = [self numberOfLines:value];
}


@end
