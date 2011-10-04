//
//  Session+Color.m
//  ConferenceApp
//
//  Created by Peter Friese on 04.10.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import "Session+Color.h"
#import "UIColor+Additions.h"

#define ECLIPSE_TECHNOLOGY_COLOR 0x5D86AD
#define COMMUNITY_AND_COLLABORATION_COLOR0 0x1593c3
#define BUILDING_INDUSTRY_SOLUTIONS 0xf49100
#define OTHER_COLOR 0x333
#define JAVA_7_SUMMIT 0xf60031

#define KEYNOTE_COLOR 0xA44ED4
#define EXTENDED_COLOR 0x23b1d4
#define STANDARD_COLOR 0x23b1d4
#define TUTORIAL_COLOR 0x91c22f
#define EXTENDED_TUTORIAL_COLOR 0x91c22f
#define SPONSORED_COLOR 0x2ad5ff
#define BREAK_COLOR 0xffe785

@implementation Session(Color)

-(UIColor *)sessionColor {
	// color keys from http://www.eclipsecon.org/2011/program/program.css
	// keynote: A44ED4
	// standard: 23b1d4
	// extended: 23b1d4
	// tutorial: 91c22f
	// extended tutorial: 91c22f
	// interlude: ffe785 
	// sponsored: 2AD5FF 
	
	NSString *sessionType = [self.type lowercaseString];
	if ([sessionType isEqualToString:@"keynote"]) {
		return UIColorFromRGB(KEYNOTE_COLOR);
	}
	else if ([sessionType isEqualToString:@"long"] || [sessionType isEqualToString:@"extended"]) {
		return UIColorFromRGB(EXTENDED_COLOR);
	}		
	else if ([sessionType isEqualToString:@"short"] || [sessionType isEqualToString:@"standard"]) {
		return UIColorFromRGB(STANDARD_COLOR);
	}
	else if ([sessionType isEqualToString:@"tutorial"]) {
		return UIColorFromRGB(TUTORIAL_COLOR);
	}		
	else if ([sessionType isEqualToString:@"extended tutorial"]) {
		return UIColorFromRGB(EXTENDED_TUTORIAL_COLOR);
	}		
	else if ([sessionType isEqualToString:@"sponsored"]) {
		return  UIColorFromRGB(SPONSORED_COLOR);
	}
	else if (([sessionType isEqualToString:@"break"]) 
			 || ([sessionType isEqualToString:@"lunch"]) 
			 || ([sessionType isEqualToString:@"longlunch"]) 
			 || ([sessionType isEqualToString:@"reception"])
			 || ([sessionType isEqualToString:@"interlude"])) {
		return UIColorFromRGB(BREAK_COLOR);
	}		
	else {
		return RGB(2, 53, 153);
	}	
	
}

@end
