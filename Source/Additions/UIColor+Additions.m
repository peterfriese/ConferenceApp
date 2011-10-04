//
//  UIColor+Additions.m
//  ConferenceApp
//
//  Created by Peter Friese on 04.10.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)
	+(UIColor *) cellBackgroundColor { 
		return UIColorFromRGB(0xF8F8F8);
		/*
		static UIColor *cellBackgroundColor = nil;
		if (cellBackgroundColor == nil) {
			cellBackgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
		}
		return cellBackgroundColor;
		 */
	}
@end
