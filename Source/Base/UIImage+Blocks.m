//
//  UIImage+Blocks.m
//  ConferenceApp
//
//  Created by Peter Friese on 07.10.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import "UIImage+Blocks.h"

@implementation UIImage (Blocks)

+ (void)imageFromURL:(NSString *)url withResultHandler:(ResultHandler)handler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage *anImage = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[handler copy] autorelease];
            handler(anImage);
        });
    });
}

@end
