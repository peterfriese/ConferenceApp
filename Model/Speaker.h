//
//  Speaker.h
//  ConferenceApp
//
//  Created by Peter Friese on 23.09.11.
//  Copyright (c) 2011 http://peterfriese.de. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/CoreData/CoreData.h>

@class Session;

@interface Speaker : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * speakerId;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * affiliation;
@property (nonatomic, retain) NSString * bio;
@property (nonatomic, retain) NSString * role;
@property (nonatomic, retain) NSString * initial;
@property (nonatomic, retain) NSSet *sessions;

- (NSString *)fullName;
- (NSString *)initial;
@end

@interface Speaker (CoreDataGeneratedAccessors)

- (void)addSessionsObject:(Session *)value;
- (void)removeSessionsObject:(Session *)value;
- (void)addSessions:(NSSet *)values;
- (void)removeSessions:(NSSet *)values;
@end
