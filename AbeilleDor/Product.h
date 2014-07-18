//
//  Product.h
//  AbeilleDor
//
//  Created by Admin on 11/03/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Product : NSManagedObject

@property (nonatomic, retain) NSString * isCart;
@property (nonatomic, retain) NSString * isWishlist;
@property (nonatomic, retain) NSString * productId;
@property (nonatomic, retain) NSString * productImageUrl;
@property (nonatomic, retain) NSString * productName;
@property (nonatomic, retain) NSString * productRating;
@property (nonatomic, retain) NSString * productReviews;
@property (nonatomic, retain) NSString * productDescription;
@property (nonatomic, retain) NSString * productPrice;

@end