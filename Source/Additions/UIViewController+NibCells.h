//
//  UIViewController+NibCells.h
//  ConferenceApp
//
//  Created by Peter Friese on 04.10.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

@interface UIViewController (NibCells)

- (UITableViewCell *)loadTableViewCellFromNibNamed:(NSString *)nibName;
- (UITableViewCell *)loadReusableTableViewCellFromNibNamed:(NSString *)nibName;

@end
