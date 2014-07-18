//
//  Message.h
//  AbeilleDor
//
//  Created by rkhan-mbook on 24/05/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Message : NSManagedObject

@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSString * messageId;
@property (nonatomic, retain) NSString * time;

@end
