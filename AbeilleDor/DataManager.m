//
//  DataManager.m
//  AbeilleDor
//
//  Created by Roman Khan on 05/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "DataManager.h"
#import "Product.h"
#import "Yakult.h"
#import "ProductDetail.h"
#import "Cart.h"
#import "Wishlist.h"
#import "WhereToBuy.h"
#import "Reminders.h"
#import "Order.h"
#import "Message.h"

@interface DataManager ()

@property (nonatomic, copy, readwrite) SuccessBlock successBlock;

@end

@implementation DataManager
@synthesize successBlock;
@synthesize dictAllData;

static DataManager * sharedManager;

//initialize is called automatically before the class gets any other message
+ (void)initialize {
    static BOOL initialized = NO;
    if(!initialized) {
        initialized = YES;
		sharedManager = [[DataManager alloc] init];
        
    }
}

#pragma mark - Singleton Object
//Singleton Object
+ (DataManager *)sharedManager {
	return (sharedManager);
}


-(id)init {
    if (self = [super init]) {
        
        self->dictAllData = [[NSMutableDictionary alloc]init];
        
    }
    return self;
}

//! Save Login oAuth Token in User Defaults
-(void)saveAuthToken:(NSDictionary *)dict WithSuccessBlock:(SuccessBlock)block
{
    self.successBlock = block;
    if ([[dict objectForKey:@"status"]isEqualToString:@"success"]) {
        
        NSDictionary * dictResponse = [dict objectForKey:@"response"];
        
        NSString * strAuth = [dictResponse objectForKey:@"authkey"];

        NSLog(@"%@",strAuth);
        
        [[NSUserDefaults standardUserDefaults]setObject:strAuth forKey:@"OAUTH"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        self.successBlock (YES);
    }
    
    else {
        
        self.successBlock (NO);
    }
}

//! Store All Abeille d'Or Products in Core Data
+(void)storeAllProducts:(NSArray *)array WithDataBlock:(DataBlock)block
{
    if ([array count]>0) {
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            Product * productObj = [Product MR_findFirstByAttribute:@"productId" withValue:[obj objectForKey:@"productId"]];
            if (!productObj) {
                productObj = [Product MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
                
                if ([obj objectForKey:@"productId"]!= NULL) {
                    productObj.productId = [obj objectForKey:@"productId"];
                }
                else {
                    productObj.productId = @"";
                }
                
                if ([obj objectForKey:@"name"]!= NULL) {
                    productObj.productName = [obj objectForKey:@"name"];
                }
                else {
                    productObj.productName = @"";
                }
                
                if ([obj objectForKey:@"imageUrl"]!= NULL) {
                    productObj.productImageUrl = [obj objectForKey:@"imageUrl"];
                }
                else {
                    productObj.productImageUrl = @"";
                }
                
                if ([obj objectForKey:@"rating"]!= NULL) {
                    productObj.productRating = [NSString stringWithFormat:@"%@",[obj objectForKey:@"rating"]];
                }
                else {
                    productObj.productRating = @"";
                }
                
                if ([obj objectForKey:@"reviews"]!= NULL) {
                    productObj.productReviews = [obj objectForKey:@"reviews"];
                }
                else {
                    productObj.productReviews = @"";
                }
                
                if ([obj objectForKey:@"productDescription"]!= NULL) {
                    productObj.productDescription = [obj objectForKey:@"productDescription"];
                }
                else {
                    productObj.productDescription = @"";
                }
                
                if ([obj objectForKey:@"productPrice"]!= NULL) {
                    productObj.productPrice = [obj objectForKey:@"productPrice"];
                }
                else {
                    productObj.productPrice = @"";
                }
                
                productObj.isCart = @"0";
                productObj.isWishlist = @"0";
            }
            
            
        }];

    }
    else {
        
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];


}

//! Store All Yakult Products in Core Data
+(void)storeAllYakultProducts:(NSArray *)array WithDataBlock:(DataBlock)block
{
    if ([array count]>0) {
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            Yakult * productObj = [Yakult MR_findFirstByAttribute:@"productId" withValue:[obj objectForKey:@"productId"]];
            if (!productObj) {
                productObj = [Yakult MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
                
                if ([obj objectForKey:@"productId"]!= NULL) {
                    productObj.productId = [obj objectForKey:@"productId"];
                }
                else {
                    productObj.productId = @"";
                }
                
                if ([obj objectForKey:@"name"]!= NULL) {
                    productObj.productName = [obj objectForKey:@"name"];
                }
                else {
                    productObj.productName = @"";
                }
                
                if ([obj objectForKey:@"imageUrl"]!= NULL) {
                    productObj.productImageUrl = [obj objectForKey:@"imageUrl"];
                }
                else {
                    productObj.productImageUrl = @"";
                }
                
                if ([obj objectForKey:@"rating"]!= NULL) {
                    productObj.productRating = [NSString stringWithFormat:@"%@",[obj objectForKey:@"rating"]];
                }
                else {
                    productObj.productRating = @"";
                }
                
                if ([obj objectForKey:@"reviews"]!= NULL) {
                    productObj.productReviews = [obj objectForKey:@"reviews"];
                }
                else {
                    productObj.productReviews = @"";
                }
                
                if ([obj objectForKey:@"productDescription"]!= NULL) {
                    productObj.productDescription = [obj objectForKey:@"productDescription"];
                }
                else {
                    productObj.productDescription = @"";
                }
                
                if ([obj objectForKey:@"productPrice"]!= NULL) {
                    productObj.productPrice = [obj objectForKey:@"productPrice"];
                }
                else {
                    productObj.productPrice = @"";
                }
                
                productObj.isWishlist = @"0";
            }
            
            
        }];

    }
    else {
        
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}

//! Update Product "isCart" - Abeille d'Or
+(void)updateAddCartProductWithProductId:(NSString *)productId WithDataBlock:(DataBlock)block;
{
    Product * productObj = [Product MR_findFirstByAttribute:@"productId" withValue:productId];
    
    if (productObj) {
        
        productObj.isCart = @"1";
    }

    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];
}

//! Update & Remove Entity Product - For Cart Info
+(void)updateAndRemoveCartProductWithProductId:(NSString *)productId WithDataBlock:(DataBlock)block
{
    Product * productObj = [Product MR_findFirstByAttribute:@"productId" withValue:productId];
    
    if (productObj) {
        
        productObj.isCart = @"0";
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}

//! Update Product "isWishlist" - Abeille d'Or
+(void)updateAddWishlistProductWithProductId:(NSString *)productId WithDataBlock:(DataBlock)block
{
    Product * productObj = [Product MR_findFirstByAttribute:@"productId" withValue:productId];
    
    if (productObj) {
        
        productObj.isWishlist = @"1";
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}

//! Update and Remove Entity Product - For Wishlist Info
+(void)updateAndRemoveWishlistProductWithProductId:(NSString *)productId WithDataBlock:(DataBlock)block
{
    Product * productObj = [Product MR_findFirstByAttribute:@"productId" withValue:productId];
    
    if (productObj) {
        
        productObj.isWishlist = @"0";
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}

//! Update Product "isWishlist" - Yakult
+(void)updateAddWishlistYakultWithProductId:(NSString *)productId WithDataBlock:(DataBlock)block
{
    Yakult * productObj = [Yakult MR_findFirstByAttribute:@"productId" withValue:productId];
    
    if (productObj) {
        
        productObj.isWishlist = @"1";
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}

//! Update Product "isWishlist" - Yakult
+(void)updateAndRemoveWishlistYakultWithProductId:(NSString *)productId WithDataBlock:(DataBlock)block
{
    Yakult * productObj = [Yakult MR_findFirstByAttribute:@"productId" withValue:productId];
    
    if (productObj) {
        
        productObj.isWishlist = @"0";
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];
 
}

//! Remove Product From Shopping Cart - Update Products Screen
+(void)updateProductsListForRemovalFromShoppingCartWithProductId:(NSString *)productId WithDataBlock:(DataBlock)block
{
    Product * productObj = [Product MR_findFirstByAttribute:@"productId" withValue:productId];
    
    if (productObj) {
        
        productObj.isCart = @"0";
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}

//! Store Product Detail in Core Data
+(void)storeProductDetail:(NSDictionary *)dict WithDataBlock:(DataBlock)block
{
    NSLog(@"%@",dict);
    ProductDetail * productObj = [ProductDetail MR_findFirstByAttribute:@"productId" withValue:[dict objectForKey:@"productId"]];
    if (!productObj) {
        productObj = [ProductDetail MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        
        
        if ([dict objectForKey:@"productId"]!= NULL) {
            productObj.productId = [dict objectForKey:@"productId"];
        }
        else {
            productObj.productId = @"";
        }
        
        if ([dict objectForKey:@"name"]!= NULL) {
            productObj.productName = [dict objectForKey:@"name"];
        }
        else {
            productObj.productName = @"";
        }
        
        if ([dict objectForKey:@"imageUrl"]!= NULL) {
            productObj.productImageUrl = [dict objectForKey:@"imageUrl"];
        }
        else {
            productObj.productImageUrl = @"";
        }
        
        if ([dict objectForKey:@"rating"]!= NULL) {
            productObj.productRating = [NSString stringWithFormat:@"%@",[dict objectForKey:@"rating"]];
        }
        else {
            productObj.productRating = @"";
        }
        
        if ([dict objectForKey:@"reviews"]!= NULL) {
            productObj.productReviews = [dict objectForKey:@"reviews"];
        }
        else {
            productObj.productReviews = @"";
        }

        if ([dict objectForKey:@"price"]!= NULL) {
            productObj.productPrice = [dict objectForKey:@"price"];
        }
        else {
            productObj.productPrice = @"";
        }

        if ([dict objectForKey:@"description"]!= NULL) {
            productObj.productDescription = [dict objectForKey:@"description"];
        }
        else {
            productObj.productDescription = @"";
        }

        
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];
}

//! Store Where To Buy Info
+(void)storeWhereToBuyInfo:(NSArray *)array WithDataBlock:(DataBlock)block
{
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

    WhereToBuy * whereObj = [WhereToBuy MR_findFirstByAttribute:@"storeName" withValue:[obj objectForKey:@"name"]];
    if (!whereObj) {
        whereObj = [WhereToBuy MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        
        
        if ([obj objectForKey:@"name"]!= NULL) {
            whereObj.storeName = [obj objectForKey:@"name"];
        }
        else {
            whereObj.storeName = @"";
        }
        
        if ([obj objectForKey:@"address"]!= NULL) {
            whereObj.storeAddress = [obj objectForKey:@"address"];
        }
        else {
            whereObj.storeAddress = @"";
        }
        
        if ([obj objectForKey:@"lat"]!= NULL) {
            whereObj.storeLatitude = [obj objectForKey:@"lat"];
        }
        else {
            whereObj.storeLatitude = @"";
        }
        
        if ([obj objectForKey:@"long"]!= NULL) {
            whereObj.storeLongitude = [obj objectForKey:@"long"];
        }
        else {
            whereObj.storeLongitude = @"";
        }
        
        if ([obj objectForKey:@"store_for"]!= NULL) {
            whereObj.storeIdentifier = [obj objectForKey:@"store_for"];
        }
        else {
            whereObj.storeIdentifier = @"";
        }
    }
        
    }];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}

//! Store Order History Data
+(void)storeOrderHistory:(NSArray *)array WithDataBlock:(DataBlock)block
{
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        Order * orderObj = [Order MR_findFirstByAttribute:@"orderid" withValue:[obj objectForKey:@"orderid"]];
        if (!orderObj) {
            orderObj = [Order MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
            
            
            if ([obj objectForKey:@"date"]!= NULL) {
                orderObj.date = [obj objectForKey:@"date"];
            }
            else {
                orderObj.date = @"";
            }
            
            if ([obj objectForKey:@"destinationAddress"]!= NULL) {
                orderObj.destinationAddress = [obj objectForKey:@"destinationAddress"];
            }
            else {
                orderObj.destinationAddress = @"";
            }
            
            if ([obj objectForKey:@"money"]!= NULL) {
                orderObj.money = [obj objectForKey:@"money"];
            }
            else {
                orderObj.money = @"";
            }
            
            if ([obj objectForKey:@"orderid"]!= NULL) {
                orderObj.orderid = [obj objectForKey:@"orderid"];
            }
            else {
                orderObj.orderid = @"";
            }
            
        }
        else {
            
        }
        
    }];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}

//! Store Message Data
+(void)StoreMessageData:(NSArray *)arrayData WithDataBlock:(DataBlock)block
{
    [arrayData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

    Message * messageObj = [Message MR_findFirstByAttribute:@"messageId" withValue:[obj objectForKey:@"id"] inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
    
    
        NSLog(@"%@",messageObj.messageId);
        
        if ([messageObj.messageId isEqualToString:[obj objectForKey:@"id"]]) {
            
            [messageObj MR_deleteEntity];
            
        }

    
//    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"LASTMESSAGE"]isEqualToString:[dictData objectForKey:@"id"]]) {
//        
//        
//    }
//    else {
//        
        messageObj = [Message MR_createInContext:[NSManagedObjectContext MR_contextForCurrentThread]];
        
        if ([obj objectForKey:@"msg"]!= [NSNull null]) {
            messageObj.message = [obj objectForKey:@"msg"];
        }
        else {
            messageObj.message = @"";

        }
        messageObj.messageId = [obj objectForKey:@"id"];
        messageObj.time = [obj objectForKey:@"time"];

//        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//        [defaults removeObjectForKey:@"LASTMESSAGE"];
//        [defaults setObject:[dictData objectForKey:@"id"] forKey:@"LASTMESSAGE"];
//        [defaults synchronize];

//    }
    }];
    
    [[NSManagedObjectContext MR_contextForCurrentThread] MR_saveToPersistentStoreWithCompletion:block];

}


//! Remove Message
+(void)removeMessageWithMessageId:(NSString *)messageId WithDataBlock:(DataBlock)block
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"LASTMESSAGE"];
    [defaults setObject:messageId forKey:@"LASTMESSAGE"];
    [defaults synchronize];
    

    Message * messageObj = [Message MR_findFirstByAttribute:@"messageId" withValue:messageId];
    if (messageObj) {
        
        [messageObj MR_deleteEntity];
    }
    
    
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}


//! Add Products to Cart
+(void)addProductsToCart:(NSDictionary *)dict WithDataBlock:(DataBlock)block
{
    Cart * cartObj = [Cart MR_findFirstByAttribute:@"productId" withValue:[dict objectForKey:@"productId"]];
    if (!cartObj) {
        cartObj = [Cart MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        
        
        cartObj.productId = [dict objectForKey:@"productId"];
        
        cartObj.productName = [dict objectForKey:@"productName"];
        
        cartObj.productImageUrl = [dict objectForKey:@"productImage"];
        
        cartObj.productRating = [dict objectForKey:@"productRating"];
        
        cartObj.productReviews = [dict objectForKey:@"productReviews"];
        
        cartObj.productPrice = [dict objectForKey:@"productPrice"];
        
        cartObj.productQuantity = [dict objectForKey:@"productQuantity"];
        
        
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];
 
}

//! Add Products to Wishlist
+(void)addProductsToWishlist:(NSDictionary *)dict WithDataBlock:(DataBlock)block
{
    Wishlist * wishObj = [Wishlist MR_findFirstByAttribute:@"productId" withValue:[dict objectForKey:@"productId"]];
    if (!wishObj) {
        wishObj = [Wishlist MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        
        
        wishObj.productId = [dict objectForKey:@"productId"];
        
        wishObj.productName = [dict objectForKey:@"productName"];
        
        wishObj.productImageUrl = [dict objectForKey:@"productImage"];
        
        wishObj.productRating = [dict objectForKey:@"productRating"];
        
        wishObj.productReviews = [dict objectForKey:@"productReviews"];
        
        wishObj.productType = [dict objectForKey:@"productType"];
        
        wishObj.productPrice = [dict objectForKey:@"productPrice"];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}

//! Store Medication Reminders
+(void)storeMedicationRemindersWithStartDate:(NSString *)startDate WithEndDate:(NSString *)endDate WithMessage:(NSString *)reminderMessage WithTime:(NSString *)reminderTime WithDataBlock:(DataBlock)block
{
    Reminders *reminderObj = [Reminders MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
        
        
        reminderObj.startDate = startDate;
        
        reminderObj.endDate = endDate;
        
        reminderObj.message = reminderMessage;
        
        reminderObj.reminderTime = reminderTime;
        
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}

//! Remove Item From Cart
+(void)removeItemFromCartWithProductId:(NSString *)productId WithDataBlock:(DataBlock)block
{
    Cart * cartObj = [Cart MR_findFirstByAttribute:@"productId" withValue:productId];
    if (cartObj) {
        
        [cartObj MR_deleteEntity];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}


//! Remove All Items From Cart
+(void)removeAllItemsFromCartWithDataBlock:(DataBlock)block
{
    for (Cart * Object in [DataManager loadAllProductsFromCart]) {
        
        [Object MR_deleteEntity];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];
    
}


//! Remove Item From Wishlist
+(void)removeItemFromWishlistWithProductId:(NSString *)productId WithDataBlock:(DataBlock)block
{
    Wishlist * wishObj = [Wishlist MR_findFirstByAttribute:@"productId" withValue:productId];
    if (wishObj) {
        
        [wishObj MR_deleteEntity];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}

//! Remove Item From Reminders
+(void)removeItemFromRemindersWithMessage:(NSString *)message WithStartDate:(NSString *)startDate WithEndDate:(NSString *)endDate WithTime:(NSString *)time WithDataBlock:(DataBlock)block
{
    Reminders * reminderObj = [Reminders MR_findFirstByAttribute:@"message" withValue:message];
    if (reminderObj) {
        
        [reminderObj MR_deleteEntity];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}

//! Remove All Items From Order
+(void)removeAllOrderFromCoreDataWithDataBlock:(DataBlock)block
{
    for (Order * Object in [DataManager loadAllOrderHistory]) {
        
        [Object MR_deleteEntity];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}

//! Update Product List After Adding Review
+(void)updateProductsListForAddingOfReviewWithProductId:(NSString *)productId WithDataBlock:(DataBlock)block
{
    Product * productObj = [Product MR_findFirstByAttribute:@"productId" withValue:productId];
    
    if (productObj) {
        
        NSString * strRating = productObj.productReviews;
        
        NSInteger intR = [strRating intValue];
        intR = intR + 1;
        
        productObj.productReviews = [NSString stringWithFormat:@"%ld",(long)intR];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];

}

//! Update Product Info After Addind Quantity Value
+(void)updateCartWithProductId:(NSString *)productId WithProductQuantity:(NSString *)productQuantity WithDataBlock:(DataBlock)block
{
    Cart * cartObj = [Cart MR_findFirstByAttribute:@"productId" withValue:productId];
    
    if (cartObj) {
        cartObj.productQuantity = productQuantity;
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:block];
}

//! Load All Abeille d'Or Products From Core Data
+(NSMutableArray *)loadAllProductsFromCoreData
{
    return [Product MR_findAll].mutableCopy;
}

//! Load All Yakult Products From Core Data
+(NSMutableArray *)loadAllYakultProductsFromCoreData
{
    return [Yakult MR_findAll].mutableCopy;
}

//! Load Product Detail From Core Data
+(NSMutableArray *)loadProductDetailForProductId:(NSString *)productId
{
    return [Product MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"productId == %@", productId] inContext:[NSManagedObjectContext MR_defaultContext]].mutableCopy;
}

//! Load Yakult Product Detail From Core Data
+(NSMutableArray *)loadYakultProductDetailForProductId:(NSString *)productId
{
    return [Yakult MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"productId == %@", productId] inContext:[NSManagedObjectContext MR_defaultContext]].mutableCopy;
}

//! Load All Items From Cart
+(NSMutableArray *)loadAllProductsFromCart
{
    return [Cart MR_findAll].mutableCopy;
}

//! Load All Items From Wishlist
+(NSMutableArray *)loadAllProductsFromWishlist
{
    return [Wishlist MR_findAll].mutableCopy;
}

//! Load All Items From WhereToBuy
+(NSMutableArray *)loadAllDataFromWhereToBuy
{
    return [WhereToBuy MR_findAll].mutableCopy;
}

//! Load All Medication Reminders
+(NSMutableArray *)loadAllDataFromMedicationReminders
{
    return [Reminders MR_findAll].mutableCopy;
}

//! Load All History
+(NSMutableArray *)loadAllOrderHistory
{
    return [Order MR_findAll].mutableCopy;
}

//! Load All Messages
+(NSMutableArray *)loadAllMessages
{
    NSFetchRequest *peopleRequest = [Message MR_requestAllSortedBy:@"messageId" ascending:NO];
    [peopleRequest setReturnsDistinctResults:YES];
    
    return [Message MR_executeFetchRequest:peopleRequest].mutableCopy;

    //return [Message MR_findAll].mutableCopy;
}

@end
