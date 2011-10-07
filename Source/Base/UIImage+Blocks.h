//
//  UIImage+Blocks.h
//  ConferenceApp
//
//  Created by Peter Friese on 07.10.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Blocks)

typedef void(^ResultHandler)(UIImage *image);

+ (void)imageFromURL:(NSString *)url withResultHandler:(ResultHandler)handler;


@end
