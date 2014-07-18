//
//  Cart.h
//  AbeilleDor
//
//  Created by Admin on 28/03/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Cart : NSManagedObject

@property (nonatomic, retain) NSString * productId;
@property (nonatomic, retain) NSString * productImageUrl;
@property (nonatomic, retain) NSString * productName;
@property (nonatomic, retain) NSString * productPrice;
@property (nonatomic, retain) NSString * productRating;
@property (nonatomic, retain) NSString * productReviews;
@property (nonatomic, retain) NSString * productQuantity;

@end
