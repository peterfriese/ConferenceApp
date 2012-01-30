//
//  Session.h
//  ConferenceApp
//
//  Created by Peter Friese on 23.09.11.
//  Copyright (c) 2011 http://peterfriese.de. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

#import <RestKit/RestKit.h>
#import <RestKit/CoreData.h>

@class Speaker;

@interface Session : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * abstract;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSString * room;
@property (nonatomic, retain) NSNumber * sessionId;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *speakers;
@property (nonatomic, retain) NSNumber * attending;

@property (nonatomic, retain) NSString *day;
@property (nonatomic, retain) NSString *timeSlot;
@end

@interface Session (CoreDataGeneratedAccessors)

- (void)addSpeakersObject:(Speaker *)value;
- (void)removeSpeakersObject:(Speaker *)value;
- (void)addSpeakers:(NSSet *)values;
- (void)removeSpeakers:(NSSet *)values;
@end
