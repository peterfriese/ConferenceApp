//
//  Session.m
//  ConferenceApp
//
//  Created by Peter Friese on 23.09.11.
//  Copyright (c) 2011 http://peterfriese.de. All rights reserved.
//

#import "Session.h"
#import "Speaker.h"

@interface Session()
@property (nonatomic, retain) NSDateFormatter *dayFormatter;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@end

@implementation Session

@dynamic abstract;
@dynamic category;
@dynamic createdAt;
@dynamic date;
@dynamic endTime;
@dynamic room;
@dynamic sessionId;
@dynamic startTime;
@dynamic status;
@dynamic title;
@dynamic type;
@dynamic speakers;
@dynamic attending;

@synthesize day = _day;
@synthesize timeSlot = _timeSlot;
@synthesize dayFormatter = _dayFormatter;
@synthesize dateFormatter = _dateFormatter;

- (NSString *) day {
	if (_day == nil) {
		if (_dayFormatter == nil) {
			self.dayFormatter = [[[NSDateFormatter alloc] init] autorelease];
			[self.dayFormatter setDateFormat:@"EEEE dd"];		
		}
		self.day = [self.dayFormatter stringFromDate:[self date]];		
	}
	return _day;
}

- (NSString *) timeSlot {
	if (_timeSlot == nil) {
		if (_dateFormatter == nil) {
			self.dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
			[self.dateFormatter setDateFormat:@"HH:mm"];		
		}
		
		if(self.startTime && self.endTime) {
			NSString *start = [self.dateFormatter stringFromDate:[self startTime]];
			NSString *end = [self.dateFormatter stringFromDate:[self endTime]];
			
			self.timeSlot = [NSString stringWithFormat:@"%@ - %@", start, end];
		} else {
			self.timeSlot = @"unknown time slot";
		}	
	}
	return _timeSlot;
}


@end
