//
//  SpeakerTableViewCell.m
//  ConferenceApp
//
//  Created by Peter Friese on 02.02.12.
//  Copyright (c) 2012 http://peterfriese.de. All rights reserved.
//

#import "SpeakerTableViewCell.h"

@implementation SpeakerTableViewCell

@synthesize speakerName = _speakerName;
@synthesize affiliation = _affiliation;
@synthesize speakerImage = _speakerImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
    [_speakerName release];
    [_affiliation release];
    [_speakerImage release];
    [super dealloc];
}

@end
