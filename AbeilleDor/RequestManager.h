//
//  DataManager.h
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Block for completion of multiple tasks
typedef void (^CompletionBlock)(BOOL result, id resultObject);

@interface RequestManager : NSObject

//! Singleton access
+(RequestManager *)sharedManager;

//! Login Via Email
-(void)loginUserWithEmail:(NSString *)email WithPassword:(NSString *)password WithAuthorizedBy:(NSString *)authorizedBy WithCompletion:(CompletionBlock)block;

//! User Registration
-(void)registerUserWithEmail:(NSString *)email WithPassword:(NSString *)password WithAge:(NSString *)age WithSex:(NSString *)sex WithCompletion:(CompletionBlock)block;

//! Forgot Password
-(void)forgotPasswordWithEmail:(NSString *)email WithCompletion:(CompletionBlock)block;

//! Products List - Abeille d'Or
-(void)loadAllAbeilleDorProductsWithCompletionBlock:(CompletionBlock)block;

//! Products List - Yakult
-(void)loadAllYakultProductsWithCompletionBlock:(CompletionBlock)block;

//! Product Detail
-(void)loadProductDetailWithProductId:(NSString *)productId WithCompletionBlock:(CompletionBlock)block;

//! Set Product in Wishlist
-(void)setWishListWithProductId:(NSString *)productId WithCompletionBlock:(CompletionBlock)block;

//! Get All Products in Wishlist
-(void)loadAllProductsinWishListWithCompletionBlock:(CompletionBlock)block;

//! Rate Product
-(void)rateProductWithProductId:(NSString *)productId WithRating:(NSString *)rating WithMessage:(NSString *)message WithName:(NSString *)name WithCompletionBlock:(CompletionBlock)block;

//! Load All Reviews
-(void)loadAllReviewsWithProductId:(NSString *)productId WithCompletionBlock:(CompletionBlock)block;

//! Where to Buy
-(void)loadWhereToBuyWithLatitude:(NSString *)latitude WithLongitude:(NSString *)longitude WithCompletionBlock:(CompletionBlock)block;

//! Promotion Video
-(void)loadPromotionVideoWithCompletionBlock:(CompletionBlock)block;

//! Send Query
-(void)sendQueryWithProductId:(NSString *)productId WithEmailId:(NSString *)email WithQuery:(NSString *)query WithCompletionBlock:(CompletionBlock)block;

//! Change Password
-(void)changePasswordWithOldPassword:(NSString *)oldPassword WithNewPassword:(NSString *)newPassword WithCompletionBlock:(CompletionBlock)block;

//! Redeem Coupons
-(void)redeemCouponsWithName:(NSString *)name WithMobile:(NSString *)mobile WithEmail:(NSString *)email WithCouponCode:(NSString *)code WithCompletionBlock:(CompletionBlock)block;

//! Get Account Info
-(void)getAccountInfoWithEmailId:(NSString *)emailId WithCompletionBlock:(CompletionBlock)block;

//! Set Account Info
-(void)setAccountInfoWithFirstName:(NSString *)firstName WithLastName:(NSString *)lastName WithEmail:(NSString *)email WithAddress:(NSString *)address WithPostalCode:(NSString *)postalcode WithPhoneNo:(NSString *)phonenumber WithProfilePicture:(NSString *)profilePicture withPicture:(UIImage *)picture WithCompletionBlock:(CompletionBlock)block;

//! Contact Us
-(void)contactUsWithName:(NSString *)name WithEmail:(NSString *)email WithMessage:(NSString *)message WithCompletionBlock:(CompletionBlock)block;

//! Sending Order List
-(void)sendOrderHistoryWithIdNumber:(NSString *)idNumber WithDate:(NSString *)date WithMoney:(NSString *)money WithAddress:(NSString *)address WithProductIds:(NSString *)productId WithQuantity:(NSString *)quantity WithCompletionBlock:(CompletionBlock)block;

//! Getting Order List
-(void)getOrderListWithEmailId:(NSString *)emailId WithCompletionBlock:(CompletionBlock)block;

//! Register For Guest
-(void)registerForGuestWithName:(NSString *)name WithEmail:(NSString *)email WithMobile:(NSString *)mobile WithCompanyName:(NSString *)company WithCompletionBlock:(CompletionBlock)block;

//! Get Latest Message
-(void)getLatestMessageWithCompletionBlock:(CompletionBlock)block;

//! Get All Messages
-(void)getAllLatestMessagesWithEmail:(NSString *)email WithCompletionBlock:(CompletionBlock)block;

//! Delete Message
-(void)deleteMessageWithMessageId:(NSString *)messageId WithCompletionBlock:(CompletionBlock)block;
@end
