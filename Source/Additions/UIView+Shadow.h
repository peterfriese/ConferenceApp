//
//  UIView+Shadow.h
//  ConferenceApp
//
//  Created by Peter Friese on 07.02.12.
//  Copyright (c) 2012 http://peterfriese.de. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Shadow)

- (void)shadow;
- (void)curlyShadowWithColor:(UIColor *)color radius:(CGFloat)radius offset:(CGFloat)offset curlFactor:(CGFloat)curlFactor shadowDepth:(CGFloat)shadowDepth;
- (void)curlyShadow;

@end
