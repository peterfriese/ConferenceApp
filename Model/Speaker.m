//
//  Speaker.m
//  ConferenceApp
//
//  Created by Peter Friese on 23.09.11.
//  Copyright (c) 2011 http://peterfriese.de. All rights reserved.
//

#import "Speaker.h"
#import "Session.h"


@implementation Speaker
@dynamic speakerId;
@dynamic firstName;
@dynamic lastName;
@dynamic affiliation;
@dynamic bio;
@dynamic role;
@dynamic sessions;
@dynamic initial;

- (NSString *)initial {
	if ([[self lastName] length] > 0  && [self lastName] != nil) {
        NSString *initial = [[self lastName] substringToIndex:1];
		return initial;
        
	}
	return @" ";
}

@end
