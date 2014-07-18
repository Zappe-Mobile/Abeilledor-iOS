//
//  Order.h
//  AbeilleDor
//
//  Created by Admin on 20/03/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Order : NSManagedObject

@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * destinationAddress;
@property (nonatomic, retain) NSString * money;
@property (nonatomic, retain) NSString * orderid;

@end
