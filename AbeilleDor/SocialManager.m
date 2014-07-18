//
//  SocialManager.m
//  SocialIntegration
//
//  Created by Roman Khan on 31/01/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "SocialManager.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

static NSString *const publish_actions = @"publish_actions";

@interface SocialManager()

@property (nonatomic, assign, readwrite, getter = isFacebookAuthenticated) BOOL facebookAuthenticated;
@property (nonatomic, copy, readwrite) successBlock sBlock;
@property (nonatomic, copy, readwrite) CompletionBlock cBlock;
@end

@implementation SocialManager
@synthesize sBlock;
@synthesize cBlock;

+ (instancetype)sharedInstance
{
    static SocialManager *_sharedSocialManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSocialManager = [[SocialManager alloc] init];
    });
    
    return _sharedSocialManager;
}

-(id)init
{
    self = [super init];
    if (self) {
        

    }
    return self;
}


#pragma mark - Facebook Related Methods
-(BOOL)isFacebookAuthenticated
{
    if(FBSession.activeSession.accessTokenData.accessToken != nil)
        return YES;
    else
        return NO;
}

-(void)openFacebookSessionWithBasicPermissionWithCompletionBlock:(successBlock)completionBlock
{
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"read_stream",@"email",@"status_update"] allowLoginUI:NO completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self sessionStateChanged:session state:status error:error andCompletionBlock:completionBlock];
            });
        }];
        
    }
    else
    {
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"read_stream",@"email",@"status_update"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self sessionStateChanged:session state:status error:error andCompletionBlock:completionBlock];
            });
        }];
        
    }
}


- (void)requestPublishPermissions:(successBlock)completionBlock
{
    if([[[FBSession activeSession] permissions] indexOfObject:publish_actions] != NSNotFound) {
        completionBlock(YES,nil);
        return;
    }
    
    if([[FBSession activeSession] isOpen] == NO) {
        // error
        [self openFacebookSessionWithBasicPermissionWithCompletionBlock:^(BOOL success, NSError *error) {
            
            if(success)
            {
                [FBSession.activeSession requestNewPublishPermissions:@[publish_actions] defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [FBSession setActiveSession:session];
                        [self sessionStateChanged:session state:session.state error:error andCompletionBlock:completionBlock];
                    });
                }];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Permission Error!" message:@"Unable to get permission from Facebook! \n Try again later!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
            
        }];
    }
    else
    {
        [FBSession.activeSession requestNewPublishPermissions:@[publish_actions] defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error) {
            [FBSession setActiveSession:session];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self sessionStateChanged:session state:session.state error:error andCompletionBlock:completionBlock];
            });
        }];
    }
}


- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error andCompletionBlock:(successBlock)completionBlock
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        
        NSLog(@"Session opened");
        //facebookSession = @"Session opened";
        // Show the user the logged-in UI
        if(completionBlock)
            completionBlock(YES,nil);
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        //facebookSession = @"Session closed";
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self openFacebookSessionWithBasicPermissionWithCompletionBlock:completionBlock];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        if(completionBlock)
            completionBlock(NO,nil);
    }
}

-(void)fetchNewsFeedFromFacebookWithCompletionBlock:(completionBlock)completionBlock
{
    NSAssert(self.isFacebookAuthenticated, @"Open an authenticated session first using openFacebookSessionWithBasicPermissionWithCompletionBlock");
    
    [self getUserFeedFromServerWithCompletionBlock:completionBlock];
}

-(void)getUserFeedFromServerWithCompletionBlock:(completionBlock)completionBlock
{
    [FBRequestConnection startWithGraphPath:@"/me" parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if(!error)
        {
            if(completionBlock)
            {
                NSLog(@"%@",result);
//                NSArray *filteredPosts = [self parseFacebookFeedWithDictionary:result];
//                NSLog(@"%@",filteredPosts);
                completionBlock(YES,[result objectForKey:@"email"],nil);
            }
        }
        else
        {
            if(completionBlock)
                completionBlock(NO,nil,error);
        }
    }];
}


- (void)postToFacebookPageWithCompletionBlock:(completionBlock)block
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"This is a test message", @"message",
                            nil
                            ];
    
    [FBRequestConnection startWithGraphPath:@"/1462340954014022/feed" parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if(!error)
        {
            if(block)
            {
                NSLog(@"%@",result);
                block(YES,result,nil);
            }
        }
        else
        {
            NSLog(@"%@",[error localizedDescription]);
            if(block)
                block(NO,nil,error);
        }

        
    }];
    
    
//    [FBRequestConnection startWithGraphPath:@"/{object-id}/likes"
//                                 parameters:nil
//                                 HTTPMethod:@"POST"
//                          completionHandler:^(
//                                              FBRequestConnection *connection,
//                                              id result,
//                                              NSError *error
//                                              ) {
//                              /* handle the result */
//                          }];
}

-(NSArray *)parseFacebookFeedWithDictionary:(NSDictionary *)feedDict
{
    NSMutableArray *filteredPosts = [NSMutableArray array];
    
    if(feedDict != nil)
    {
        
        
    }
    return filteredPosts;
}

-(void)postStoryToFacebook:(NSString *)storyText andLink:(NSString *)link andCompletionBlock:(successBlock)completionBlock
{
    [FBSession openActiveSessionWithAllowLoginUI:NO];
    
    FBRequest *postRequest = [FBRequest requestForPostStatusUpdate:link];
    
    [postRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if(!error)
            completionBlock(YES,nil);
        else
            completionBlock(NO,error);
    }];
    
}

-(void)logoutFacebook
{
    [[FBSession activeSession] closeAndClearTokenInformation];
}
@end
