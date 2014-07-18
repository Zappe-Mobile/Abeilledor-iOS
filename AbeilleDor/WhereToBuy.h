//
//  WhereToBuy.h
//  AbeilleDor
//
//  Created by Admin on 11/03/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WhereToBuy : NSManagedObject

@property (nonatomic, retain) NSString * storeAddress;
@property (nonatomic, retain) NSString * storeLatitude;
@property (nonatomic, retain) NSString * storeLongitude;
@property (nonatomic, retain) NSString * storeName;
@property (nonatomic, retain) NSString * storeIdentifier;

@end
