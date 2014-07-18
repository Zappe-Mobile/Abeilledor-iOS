//
//  DataManager.m
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "RequestManager.h"
#import "Service.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@interface RequestManager () {
    
}

@property (nonatomic, copy, readwrite) CompletionBlock completionBlock;

@end

@implementation RequestManager
@synthesize completionBlock;

static RequestManager * sharedManager;

//initialize is called automatically before the class gets any other message
+ (void)initialize {
    static BOOL initialized = NO;
    if(!initialized) {
        initialized = YES;
		sharedManager = [[RequestManager alloc] init];
    }
}

#pragma mark - Singleton Object
//Singleton Object
+ (RequestManager *)sharedManager {
	return (sharedManager);
}


-(id)init {
    if (self = [super init]) {
        
    }
    return self;
}


//! Login Via Email
-(void)loginUserWithEmail:(NSString *)email WithPassword:(NSString *)password WithAuthorizedBy:(NSString *)authorizedBy WithCompletion:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString * strPayload = [NSString stringWithFormat:@"pl={\n\"email\":\"%@\",\n\"password\":\"%@\",\n\"authorizedby\":\"%@\",\n\"dtoken\":\"%@\"}",email,password,authorizedBy,[[NSUserDefaults standardUserDefaults]objectForKey:@"DEVICETOKEN"]];
    
    NSString * strPayloadFinal = [NSString stringWithFormat:@"%@&%@",LOGIN_URL,strPayload];
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@""];
    strPayloadFinal = [strPayloadFinal stringByTrimmingCharactersInSet:set];
    strPayloadFinal = [strPayloadFinal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSLog(@"%@",strPayloadFinal);
    
    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            self.completionBlock(NO, responseObject);
        }
        else {
            self.completionBlock (YES, responseObject);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"No Internet connection Please try again."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alert show];
        self.completionBlock(NO, error);
    }];
    [op start];

    
}

//! User Registration
-(void)registerUserWithEmail:(NSString *)email WithPassword:(NSString *)password WithAge:(NSString *)age WithSex:(NSString *)sex WithCompletion:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString * strPayload = [NSString stringWithFormat:@"pl={\n\"email\":\"%@\",\n\"password\":\"%@\",\n\"age\":\"%@\",\n\"gender\":\"%@\"}",email,password,age,sex];
    
    NSString * strPayloadFinal = [NSString stringWithFormat:@"%@&%@",REGISTRATION_URL,strPayload];
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@""];
    strPayloadFinal = [strPayloadFinal stringByTrimmingCharactersInSet:set];
    strPayloadFinal = [strPayloadFinal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            self.completionBlock(NO, responseObject);
        }
        else {
            self.completionBlock (YES, responseObject);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Internet connection Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.completionBlock(NO, error);
    }];
    [op start];

}

//! Forgot Password
-(void)forgotPasswordWithEmail:(NSString *)email WithCompletion:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString * strPayload = [NSString stringWithFormat:@"pl={\n\"email\":\"%@\"}",email];
    
    NSString * strPayloadFinal = [NSString stringWithFormat:@"%@&%@",FORGOT_URL,strPayload];
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@""];
    strPayloadFinal = [strPayloadFinal stringByTrimmingCharactersInSet:set];
    strPayloadFinal = [strPayloadFinal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            self.completionBlock(NO, responseObject);
        }
        else {
            self.completionBlock (YES, responseObject);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Internet connection Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.completionBlock(NO, error);
    }];
    [op start];

}

//! Products List - Abeille d'Or
-(void)loadAllAbeilleDorProductsWithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString * strPayload = [NSString stringWithFormat:@"pl={\n\"clientId\":\"%@\"}",@"Abeille D'or"];
    
    NSString * strPayloadFinal = [NSString stringWithFormat:@"%@&%@&auth=%@",PRODUCTLIST_URL,strPayload,[[NSUserDefaults standardUserDefaults]objectForKey:@"OAUTH"]];
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@""];
    strPayloadFinal = [strPayloadFinal stringByTrimmingCharactersInSet:set];
    strPayloadFinal = [strPayloadFinal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            self.completionBlock(NO, nil);
        }
        else {
            self.completionBlock (YES, responseObject);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Internet connection Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.completionBlock(NO, error);
    }];
    [op start];
    

}

//! Products List - Yakult
-(void)loadAllYakultProductsWithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString * strPayload = [NSString stringWithFormat:@"pl={\n\"clientId\":\"%@\"}",@"yakult"];
    
    NSString * strPayloadFinal = [NSString stringWithFormat:@"%@&%@&auth=%@",PRODUCTLIST_URL,strPayload,[[NSUserDefaults standardUserDefaults]objectForKey:@"OAUTH"]];
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@""];
    strPayloadFinal = [strPayloadFinal stringByTrimmingCharactersInSet:set];
    strPayloadFinal = [strPayloadFinal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            self.completionBlock(NO, nil);
        }
        else {
            self.completionBlock (YES, responseObject);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Internet connection Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.completionBlock(NO, error);
    }];
    [op start];

}

//! Product Detail
-(void)loadProductDetailWithProductId:(NSString *)productId WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString * strPayload = [NSString stringWithFormat:@"pl={\n\"productId\":\"%@\"}",productId];
    
    NSString * strPayloadFinal = [NSString stringWithFormat:@"%@&%@&auth=%@",PRODUCTDETAIL_URL,strPayload,[[NSUserDefaults standardUserDefaults]objectForKey:@"OAUTH"]];
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@""];
    strPayloadFinal = [strPayloadFinal stringByTrimmingCharactersInSet:set];
    strPayloadFinal = [strPayloadFinal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            self.completionBlock(NO, nil);
        }
        else {
            self.completionBlock (YES, responseObject);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Internet connection Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.completionBlock(NO, error);
    }];
    [op start];

}

//! Set Product in a Wishlist
-(void)setWishListWithProductId:(NSString *)productId WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString * strPayload = [NSString stringWithFormat:@"pl={\n\"email\":\"%@\",\n\"productId\":\"%@\"}",@"matrix.romankhan@gmail.com",@"55"];
    
    NSString * strPayloadFinal = [NSString stringWithFormat:@"%@&%@&auth=%@",SET_WISHLIST,strPayload,[[NSUserDefaults standardUserDefaults]objectForKey:@"OAUTH"]];
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@""];
    strPayloadFinal = [strPayloadFinal stringByTrimmingCharactersInSet:set];
    strPayloadFinal = [strPayloadFinal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            self.completionBlock(NO, nil);
        }
        else {
            self.completionBlock (YES, responseObject);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Internet connection Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.completionBlock(NO, error);
    }];
    [op start];

}

//! Get All Products in Wishlist
-(void)loadAllProductsinWishListWithCompletionBlock:(CompletionBlock)block
{
    
}

//! Rate Product
-(void)rateProductWithProductId:(NSString *)productId WithRating:(NSString *)rating WithMessage:(NSString *)message WithName:(NSString *)name WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString * strPayload = [NSString stringWithFormat:@"pl={\n\"productId\":\"%@\",\n\"rating\":\"%@\",\n\"message\":\"%@\",\n\"name\":\"%@\"}",productId,rating,message,name];
    
    NSString * strPayloadFinal = [NSString stringWithFormat:@"%@&%@&auth=%@",SET_REVIEW,strPayload,[[NSUserDefaults standardUserDefaults]objectForKey:@"OAUTH"]];
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@""];
    strPayloadFinal = [strPayloadFinal stringByTrimmingCharactersInSet:set];
    strPayloadFinal = [strPayloadFinal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",strPayloadFinal);
    
    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            self.completionBlock(NO, nil);
        }
        else {
            self.completionBlock (YES, responseObject);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Internet connection Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.completionBlock(NO, error);
    }];
    [op start];

}

//! Load All Reviews
-(void)loadAllReviewsWithProductId:(NSString *)productId WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString * strPayload = [NSString stringWithFormat:@"pl={\n\"productId\":\"%@\"}",productId];
    
    NSString * strPayloadFinal = [NSString stringWithFormat:@"%@&%@&auth=%@",LOAD_REVIEWS,strPayload,[[NSUserDefaults standardUserDefaults]objectForKey:@"OAUTH"]];
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@""];
    strPayloadFinal = [strPayloadFinal stringByTrimmingCharactersInSet:set];
    strPayloadFinal = [strPayloadFinal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",strPayloadFinal);
    
    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            self.completionBlock(NO, nil);
        }
        else {
            self.completionBlock (YES, responseObject);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Internet connection Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.completionBlock(NO, error);
    }];
    [op start];

}

//! Load Where to Buy Info
-(void)loadWhereToBuyWithLatitude:(NSString *)latitude WithLongitude:(NSString *)longitude WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString * strPayload = [NSString stringWithFormat:@"pl={\n\"latitude\":\"%@\",\n\"longitude\":\"%@\"}",@"1.29196",@"103.8502"];
    
    NSString * strPayloadFinal = [NSString stringWithFormat:@"%@&%@&auth=%@",WHERETO_BUY,strPayload,[[NSUserDefaults standardUserDefaults]objectForKey:@"OAUTH"]];
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@""];
    strPayloadFinal = [strPayloadFinal stringByTrimmingCharactersInSet:set];
    strPayloadFinal = [strPayloadFinal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            self.completionBlock(NO, nil);
        }
        else {
            self.completionBlock (YES, responseObject);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Internet connection Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.completionBlock(NO, error);
    }];
    [op start];

}

//! Promotion Video
-(void)loadPromotionVideoWithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString * strPayload = [NSString stringWithFormat:@"pl={\n\"clientId\":\"%@\"}",@"yakult"];
    
    NSString * strPayloadFinal = [NSString stringWithFormat:@"%@&%@&auth=%@",PROMOTION,strPayload,[[NSUserDefaults standardUserDefaults]objectForKey:@"OAUTH"]];
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@""];
    strPayloadFinal = [strPayloadFinal stringByTrimmingCharactersInSet:set];
    strPayloadFinal = [strPayloadFinal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            self.completionBlock(NO, nil);
        }
        else {
            self.completionBlock (YES, responseObject);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Internet connection Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.completionBlock(NO, error);
    }];
    [op start];

}

//! Send Query
-(void)sendQueryWithProductId:(NSString *)productId WithEmailId:(NSString *)email WithQuery:(NSString *)query WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString * strPayload = [NSString stringWithFormat:@"pl={\n\"productId\":\"%@\",\n\"email\":\"%@\",\n\"query\":\"%@\"}",productId,email,query];
    
    NSString * strPayloadFinal = [NSString stringWithFormat:@"%@&%@&auth=%@",SEND_QUERY,strPayload,[[NSUserDefaults standardUserDefaults]objectForKey:@"OAUTH"]];
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@""];
    strPayloadFinal = [strPayloadFinal stringByTrimmingCharactersInSet:set];
    strPayloadFinal = [strPayloadFinal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            self.completionBlock(NO, responseObject);
        }
        else {
            self.completionBlock (YES, responseObject);
        }

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Internet connection Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.completionBlock(NO, error);
    }];
    [op start];

}

//! Change Password
-(void)changePasswordWithOldPassword:(NSString *)oldPassword WithNewPassword:(NSString *)newPassword WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString * strPayload = [NSString stringWithFormat:@"pl={\n\"oldpassword\":\"%@\",\n\"newpassword\":\"%@\"}",oldPassword,newPassword];
    
    NSString * strPayloadFinal = [NSString stringWithFormat:@"%@&%@&auth=%@",CHANGE_PASS,strPayload,[[NSUserDefaults standardUserDefaults]objectForKey:@"OAUTH"]];
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@""];
    strPayloadFinal = [strPayloadFinal stringByTrimmingCharactersInSet:set];
    strPayloadFinal = [strPayloadFinal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            self.completionBlock(NO, nil);
        }
        else {
            self.completionBlock (YES, [responseObject objectForKey:@"response"]);
        }

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Internet connection Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.completionBlock(NO, error);
    }];
    [op start];

}

//! Redeem Coupons
-(void)redeemCouponsWithName:(NSString *)name WithMobile:(NSString *)mobile WithEmail:(NSString *)email WithCouponCode:(NSString *)code WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString * strPayload = [NSString stringWithFormat:@"pl={\n\"name\":\"%@\",\n\"mobile\":\"%@\",\n\"code\":\"%@\",\n\"email\":\"%@\"}",name,mobile,code,email];
    
    NSString * strPayloadFinal = [NSString stringWithFormat:@"%@&%@&auth=%@",REDEEM_COUPON,strPayload,[[NSUserDefaults standardUserDefaults]objectForKey:@"OAUTH"]];
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@""];
    strPayloadFinal = [strPayloadFinal stringByTrimmingCharactersInSet:set];
    strPayloadFinal = [strPayloadFinal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            self.completionBlock(NO, responseObject);
        }
        else {
            self.completionBlock (YES, responseObject);
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Internet connection Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.completionBlock(NO, error);
    }];
    [op start];

}

//! Get Account Info
-(void)getAccountInfoWithEmailId:(NSString *)emailId WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString * strPayload = [NSString stringWithFormat:@"pl={\n\"email\":\"%@\"}",emailId];
    
    NSString * strPayloadFinal = [NSString stringWithFormat:@"%@&%@&auth=%@",GET_ACCOUNT,strPayload,[[NSUserDefaults standardUserDefaults]objectForKey:@"OAUTH"]];
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@""];
    strPayloadFinal = [strPayloadFinal stringByTrimmingCharactersInSet:set];
    strPayloadFinal = [strPayloadFinal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            self.completionBlock(NO, nil);
        }
        else {
            self.completionBlock (YES, [responseObject objectForKey:@"response"]);
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Internet connection Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.completionBlock(NO, error);
    }];
    [op start];

}

//! Set Account Info
-(void)setAccountInfoWithFirstName:(NSString *)firstName WithLastName:(NSString *)lastName WithEmail:(NSString *)email WithAddress:(NSString *)address WithPostalCode:(NSString *)postalcode WithPhoneNo:(NSString *)phonenumber WithProfilePicture:(NSString *)profilePicture withPicture:(UIImage *)picture WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSData* imageData = UIImagePNGRepresentation(picture);

    NSLog(@"%@",imageData);
    
    NSString * str = [UIImagePNGRepresentation(picture) base64Encoding];
    
    NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:
                            firstName,@"fname",
                            lastName,@"lastName",
                            email,@"email",
                            address,@"address",
                            postalcode,@"postalcode",
                            phonenumber,@"phonenumber",
                            @"profile.png",@"profilepicurl",
                            str,@"profilepicdata",
                            [[NSUserDefaults standardUserDefaults]objectForKey:@"OAUTH"],@"auth",
                            nil];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:TEST parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
        
        NSString *jsonString =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",jsonString);
        
        NSError *error;
        id data1 = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        
        NSLog(@"%@",data1);
        
        self.completionBlock (YES, data1);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
//    [manager POST:SET_ACCOUNT parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFormData:imageData name:@"profilepicdata"];
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"Success: %@", responseObject);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];

    
//    NSString * strPayload = [NSString stringWithFormat:@"pl={\n\"fname\":\"%@\",\n\"lname\":\"%@\",\n\"email\":\"%@\",\n\"address\":\"%@\",\n\"postalcode\":\"%@\",\n\"phonenumber\":\"%@\",\n\"profilepicurl\":\"%@\",\n\"profilepicdata\":\"%@\"}",firstName,lastName,email,address,postalcode,phonenumber,@"L.png",str];
//    
//    NSString * strPayloadFinal = [NSString stringWithFormat:@"%@&%@&auth=%@",SET_ACCOUNT,strPayload,[[NSUserDefaults standardUserDefaults]objectForKey:@"OAUTH"]];
//    
//    NSLog(@"%@",strPayloadFinal);
//    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@""];
//    strPayloadFinal = [strPayloadFinal stringByTrimmingCharactersInSet:set];
//    strPayloadFinal = [strPayloadFinal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    
//    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
//                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
//
//    [request setHTTPMethod:@"POST"];
//    
//    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    op.responseSerializer = [AFJSONResponseSerializer serializer];
//    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"JSON responseObject: %@ ",responseObject);
//        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
//            self.completionBlock(NO, nil);
//        }
//        else {
//            self.completionBlock (YES, responseObject);
//        }
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"Error: %@", [error localizedDescription]);
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                        message:@"No Internet connection Please try again."
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//        self.completionBlock(NO, error);
//    }];
//    [op start];
 
}

//! Contact Us
-(void)contactUsWithName:(NSString *)name WithEmail:(NSString *)email WithMessage:(NSString *)message WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString * strPayload = [NSString stringWithFormat:@"pl={\n\"name\":\"%@\",\n\"email\":\"%@\",\n\"message\":\"%@\"}",name,email,message];
    
    NSString * strPayloadFinal = [NSString stringWithFormat:@"%@&%@&auth=%@",CONTACT_US,strPayload,[[NSUserDefaults standardUserDefaults]objectForKey:@"OAUTH"]];
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@""];
    strPayloadFinal = [strPayloadFinal stringByTrimmingCharactersInSet:set];
    strPayloadFinal = [strPayloadFinal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            self.completionBlock(NO, responseObject);
        }
        else {
            self.completionBlock (YES, responseObject);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Internet connection Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.completionBlock(NO, error);
    }];
    [op start];

}

//! Sending Order List
-(void)sendOrderHistoryWithIdNumber:(NSString *)idNumber WithDate:(NSString *)date WithMoney:(NSString *)money WithAddress:(NSString *)address WithProductIds:(NSString *)productId WithQuantity:(NSString *)quantity WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString * strPayload = [NSString stringWithFormat:@"pl={\n\"date\":\"%@\",\n\"productid\":\"%@\",\n\"money\":\"%@\",\n\"destinationaddress\":\"%@\",\n\"productids\":\"%@\",\n\"qnty\":\"%@\"}",date,idNumber,money,address,productId,quantity];
    
    NSString * strPayloadFinal = [NSString stringWithFormat:@"%@&%@&auth=%@",SEND_ORDER,strPayload,[[NSUserDefaults standardUserDefaults]objectForKey:@"OAUTH"]];
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@""];
    strPayloadFinal = [strPayloadFinal stringByTrimmingCharactersInSet:set];
    strPayloadFinal = [strPayloadFinal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",strPayloadFinal);
    
    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            self.completionBlock(NO, nil);
        }
        else {
            self.completionBlock (YES, responseObject);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Internet connection Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.completionBlock(NO, error);
    }];
    [op start];

}

//! Getting Order List
-(void)getOrderListWithEmailId:(NSString *)emailId WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString * strPayload = [NSString stringWithFormat:@"pl={\n\"email\":\"%@\"}",emailId];
    
    NSString * strPayloadFinal = [NSString stringWithFormat:@"%@&%@&auth=%@",GET_ORDER,strPayload,[[NSUserDefaults standardUserDefaults]objectForKey:@"OAUTH"]];
    
    NSLog(@"%@",strPayloadFinal);
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@""];
    strPayloadFinal = [strPayloadFinal stringByTrimmingCharactersInSet:set];
    strPayloadFinal = [strPayloadFinal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            self.completionBlock(NO, nil);
        }
        else {
            self.completionBlock (YES, responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Internet connection Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.completionBlock(NO, error);
    }];
    [op start];

}

-(void)registerForGuestWithName:(NSString *)name WithEmail:(NSString *)email WithMobile:(NSString *)mobile WithCompanyName:(NSString *)company WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString * strPayload = [NSString stringWithFormat:@"pl={\n\"name\":\"%@\",\n\"email\":\"%@\",\n\"mobile\":\"%@\",\n\"company\":\"%@\"}",name,email,mobile,company];
    
    NSString * strPayloadFinal = [NSString stringWithFormat:@"%@&%@",REGISTER_GUEST,strPayload];
    NSCharacterSet * set = [NSCharacterSet characterSetWithCharactersInString:@""];
    strPayloadFinal = [strPayloadFinal stringByTrimmingCharactersInSet:set];
    strPayloadFinal = [strPayloadFinal stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",strPayloadFinal);
    
    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            self.completionBlock(NO, nil);
        }
        else {
            self.completionBlock (YES, responseObject);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Internet connection Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.completionBlock(NO, error);
    }];
    [op start];

}


//! Get Latest Message
-(void)getLatestMessageWithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString * strPayloadFinal = [NSString stringWithFormat:@"%@",LAST_MESSAGE];
    
    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            self.completionBlock(NO, nil);
        }
        else {
            self.completionBlock (YES, responseObject);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Internet connection Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.completionBlock(NO, error);
    }];
    [op start];

}

//! Get All Messages
-(void)getAllLatestMessagesWithEmail:(NSString *)email WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"LOGINEMAIL"]);
    
    NSString * strPayloadFinal = [NSString stringWithFormat:ALL_MESSAGES,[[NSUserDefaults standardUserDefaults]objectForKey:@"LOGINEMAIL"]];
    
    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            self.completionBlock(NO, responseObject);
        }
        else {
            self.completionBlock (YES, responseObject);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Internet connection Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.completionBlock(NO, error);
    }];
    [op start];

}


//! Delete Message
-(void)deleteMessageWithMessageId:(NSString *)messageId WithCompletionBlock:(CompletionBlock)block
{
    self.completionBlock = block;
    
    NSString * strPayloadFinal = [NSString stringWithFormat:DELETE_MESSAGE,messageId];
    
    NSURL *URL = [NSURL URLWithString:strPayloadFinal];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData  timeoutInterval:10];
    
    [request setHTTPMethod:@"GET"];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    op.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON responseObject: %@ ",responseObject);
        if ([[responseObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            self.completionBlock(NO, responseObject);
        }
        else {
            self.completionBlock (YES, responseObject);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"No Internet connection Please try again."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        self.completionBlock(NO, error);
    }];
    [op start];

}

@end
