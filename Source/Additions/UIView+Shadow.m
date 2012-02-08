//
//  UIView+Shadow.m
//  ConferenceApp
//
//  Created by Peter Friese on 07.02.12.
//  Copyright (c) 2012 http://peterfriese.de. All rights reserved.
//

#import "UIView+Shadow.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (Shadow)

- (void)shadow
{
    // drop shadow
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.6f;
    self.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.layer.shadowRadius = 2.0f;    
}

- (void)curlyShadowWithColor:(UIColor *)color radius:(CGFloat)radius offset:(CGFloat)offset curlFactor:(CGFloat)curlFactor shadowDepth:(CGFloat)shadowDepth
{
    // drop shadow
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 1.0f;
    self.layer.shadowOffset = CGSizeMake(0.0f, offset);
    self.layer.shadowRadius = radius;
    
    // curly shadow
    CGSize size = self.bounds.size;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0f, 0.0f)];
    [path addLineToPoint:CGPointMake(size.width, 0.0f)];
    [path addLineToPoint:CGPointMake(size.width, size.height + shadowDepth)];
    [path addCurveToPoint:CGPointMake(0.0f, size.height + shadowDepth)
            controlPoint1:CGPointMake(size.width - curlFactor, size.height + shadowDepth - curlFactor)
            controlPoint2:CGPointMake(curlFactor, size.height + shadowDepth - curlFactor)];    
    
    self.layer.shadowPath = path.CGPath;
}

- (void)curlyShadow
{
    [self curlyShadowWithColor:[UIColor blackColor] radius:5.0f offset:10.0f curlFactor:15.0f shadowDepth:5.0f];
}


@end
