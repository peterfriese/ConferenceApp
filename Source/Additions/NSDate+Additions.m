//
//  NSDate+Additions.m
//  ConferenceApp
//
//  Created by Peter Friese on 02.10.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

+ (NSDate *) dateFromString:(NSString *)string 
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyyy-MM-dd"];
	NSDate *myDate = [df dateFromString:string];
	[df release];
	return myDate;
}

@end
