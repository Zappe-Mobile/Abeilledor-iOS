//
//  DataManager.h
//  AbeilleDor
//
//  Created by Roman Khan on 05/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Block for completion of multiple tasks
typedef void (^SuccessBlock)(BOOL result);

//! Block for Saving in Core Data
typedef void (^DataBlock)(BOOL success,NSError * error);

@interface DataManager : NSObject

@property (nonatomic, strong) NSMutableDictionary * dictAllData;

//! Singleton access
+(DataManager *)sharedManager;

//! Save oAuth Token
-(void)saveAuthToken:(NSDictionary *)dict WithSuccessBlock:(SuccessBlock)block;

//! Store Products - Abeille d'Or
+(void)storeAllProducts:(NSArray *)array WithDataBlock:(DataBlock)block;

//! Update Product "isCart" - Abeille d'Or
+(void)updateAddCartProductWithProductId:(NSString *)productId WithDataBlock:(DataBlock)block;

//! Update & Remove Entity Product - For Cart Info
+(void)updateAndRemoveCartProductWithProductId:(NSString *)productId WithDataBlock:(DataBlock)block;

//! Update Product "isWishlist" - Abeille d'Or
+(void)updateAddWishlistProductWithProductId:(NSString *)productId WithDataBlock:(DataBlock)block;

//! Update and Remove Entity Product - For Wishlist Info
+(void)updateAndRemoveWishlistProductWithProductId:(NSString *)productId WithDataBlock:(DataBlock)block;

//! Update Product "isWishlist" - Yakult
+(void)updateAddWishlistYakultWithProductId:(NSString *)productId WithDataBlock:(DataBlock)block;

//! Update Product "isWishlist" - Yakult
+(void)updateAndRemoveWishlistYakultWithProductId:(NSString *)productId WithDataBlock:(DataBlock)block;

//! Remove Product From Shopping Cart - Update Products Screen
+(void)updateProductsListForRemovalFromShoppingCartWithProductId:(NSString *)productId WithDataBlock:(DataBlock)block;

//! Store Products - Yakult
+(void)storeAllYakultProducts:(NSArray *)array WithDataBlock:(DataBlock)block;

//! Store Product Detail
+(void)storeProductDetail:(NSDictionary *)dict WithDataBlock:(DataBlock)block;

//! Store Where To Buy
+(void)storeWhereToBuyInfo:(NSArray *)array WithDataBlock:(DataBlock)block;

//! Store Order History Data
+(void)storeOrderHistory:(NSArray *)array WithDataBlock:(DataBlock)block;

//! Add Products to Cart
+(void)addProductsToCart:(NSDictionary *)dict WithDataBlock:(DataBlock)block;

//! Add Products to Wishlist
+(void)addProductsToWishlist:(NSDictionary *)dict WithDataBlock:(DataBlock)block;

//! Store Medication Reminders
+(void)storeMedicationRemindersWithStartDate:(NSString *)startDate WithEndDate:(NSString *)endDate WithMessage:(NSString *)reminderMessage WithTime:(NSString *)reminderTime WithDataBlock:(DataBlock)block;

//! Remove Item From Cart
+(void)removeItemFromCartWithProductId:(NSString *)productId WithDataBlock:(DataBlock)block;

//! Remove All Items From Cart
+(void)removeAllItemsFromCartWithDataBlock:(DataBlock)block;

//! Remove Item From Wishlist
+(void)removeItemFromWishlistWithProductId:(NSString *)productId WithDataBlock:(DataBlock)block;

//! Remove Item From Reminders
+(void)removeItemFromRemindersWithMessage:(NSString *)message WithStartDate:(NSString *)startDate WithEndDate:(NSString *)endDate WithTime:(NSString *)time WithDataBlock:(DataBlock)block;

//! Remove All Items From Order
+(void)removeAllOrderFromCoreDataWithDataBlock:(DataBlock)block;

//! Update Product List After Adding Review
+(void)updateProductsListForAddingOfReviewWithProductId:(NSString *)productId WithDataBlock:(DataBlock)block;

//! Update Product Info After Addind Quantity Value
+(void)updateCartWithProductId:(NSString *)productId WithProductQuantity:(NSString *)productQuantity WithDataBlock:(DataBlock)block;

//! Store Message Data
+(void)StoreMessageData:(NSArray *)arrayData WithDataBlock:(DataBlock)block;

//! Remove Message
+(void)removeMessageWithMessageId:(NSString *)messageId WithDataBlock:(DataBlock)block;

//! Load All Products From Core Data
+(NSMutableArray *)loadAllProductsFromCoreData;

//! Load All Yakult Products From Core Data
+(NSMutableArray *)loadAllYakultProductsFromCoreData;

//! Load Product Detail
+(NSMutableArray *)loadProductDetailForProductId:(NSString *)productId;

//! Load Yakult Product Detail From Core Data
+(NSMutableArray *)loadYakultProductDetailForProductId:(NSString *)productId;

//! Load All Items From Cart
+(NSMutableArray *)loadAllProductsFromCart;

//! Load All Items From Wishlist
+(NSMutableArray *)loadAllProductsFromWishlist;

//! Load All Items From WhereToBuy
+(NSMutableArray *)loadAllDataFromWhereToBuy;

//! Load All Medication Reminders
+(NSMutableArray *)loadAllDataFromMedicationReminders;

//! Load All History
+(NSMutableArray *)loadAllOrderHistory;

//! Load All Messages
+(NSMutableArray *)loadAllMessages;
@end
