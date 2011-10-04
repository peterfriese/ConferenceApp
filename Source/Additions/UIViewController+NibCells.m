//
//  UIViewController+NibCells.h
//  ConferenceApp
//
//  Created by Peter Friese on 04.10.11.
//  Copyright 2011 http://peterfriese.de. All rights reserved.
//

@implementation UIViewController (NibCells)

- (UITableViewCell *)loadTableViewCellFromNibNamed:(NSString *)nibName;
{
    NSArray *bundleItems = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    UITableViewCell *cell = nil;
    for (id item in bundleItems) {
        if ([item isKindOfClass:[UITableViewCell class]]) {
            cell = item;
            break;
        }
    }
    NSAssert1(cell, @"Expected nib named %@ to contain a UITableViewCell", nibName);
    return cell;
}

- (UITableViewCell *)loadReusableTableViewCellFromNibNamed:(NSString *)nibName;
{
    UITableViewCell *cell = [self loadTableViewCellFromNibNamed:nibName];
    NSAssert1(cell.reuseIdentifier, @"Cell in nib named %@ does not have a reuse identifier set", nibName);
    NSAssert2([cell.reuseIdentifier isEqualToString:nibName], @"Expected cell to have a reuse identifier of %@, but it was %@", nibName, cell.reuseIdentifier);
    return cell;
}

@end
