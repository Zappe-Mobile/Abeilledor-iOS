//
//  SocialManager.h
//  SocialIntegration
//
//  Created by Roman Khan on 31/01/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^completionBlock)(BOOL success, NSString *newsFeed, NSError *error);
typedef void (^successBlock)(BOOL success, NSError *error);

//! Block for completion of multiple tasks
typedef void (^CompletionBlock)(BOOL result, id resultObject);

@interface SocialManager : NSObject

@property (nonatomic, assign, readonly, getter = isFacebookAuthenticated) BOOL facebookAuthenticated;

+(instancetype)sharedInstance;

-(void)requestPublishPermissions:(successBlock)completionBlock;
-(void)postStoryToFacebook:(NSString *)storyText andLink:(NSString *)link andCompletionBlock:(successBlock)completionBlock;
-(void)openFacebookSessionWithBasicPermissionWithCompletionBlock:(successBlock)completionBlock;
-(void)fetchNewsFeedFromFacebookWithCompletionBlock:(completionBlock)completionBlock;
- (void)postToFacebookPageWithCompletionBlock:(completionBlock)block;
-(void)logoutFacebook;

@end
