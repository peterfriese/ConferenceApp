//
//  DateNavigator.h
//  ConferenceApp
//
//  Created by Peter Friese on 10.10.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateNavigatorDelegate <NSObject>
- (void)navigateToDate:(NSDate *)date;
@end

@interface DateNavigator : UIView

@property (nonatomic, retain) NSArray *dates;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, assign) id<DateNavigatorDelegate> delegate;

@end
