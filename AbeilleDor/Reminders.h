//
//  Reminders.h
//  AbeilleDor
//
//  Created by Admin on 16/03/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Reminders : NSManagedObject

@property (nonatomic, retain) NSString * startDate;
@property (nonatomic, retain) NSString * endDate;
@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * reminderTime;

@end
