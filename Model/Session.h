//
//  Session.h
//  ConferenceApp
//
//  Created by Peter Friese on 21.09.11.
//  Copyright (c) 2011 http://peterfriese.de. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Session : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * sessionId;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * abstract;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * room;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * category;

@end
