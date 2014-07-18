//
//  LoginViewController.m
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "UINavigationController+Extras.h"
#import "RegisterViewController.h"
#import "RegisterGuestViewController.h"
#import "ForgotPasswordViewController.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "SocialManager.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>

static NSString * const kClientId = @"151597012826-9hgdtpvj8nk48pc77fh84ppqsurg39vq.apps.googleusercontent.com";

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize btnGoogleSignInButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.titleView = [self.navigationController setTitleView:@"Login"];
    
    isRememberPassword = NO;
    
    NSString * strEmail = [[NSUserDefaults standardUserDefaults]objectForKey:@"LOGINEMAIL"];
    NSString * strPassword = [[NSUserDefaults standardUserDefaults]objectForKey:@"LOGINPASSWORD"];
    
    txtEmail.text = strEmail;
    txtPassword.text = strPassword;
    
    if ([strEmail isEqualToString:@""] && [strPassword isEqualToString:@""]) {
        [btnRememberMe setImage:[UIImage imageNamed:@"uncheck_checkbox_1x.png"] forState:UIControlStateNormal];
        isRememberPassword = NO;
    }
    else {
        [btnRememberMe setImage:[UIImage imageNamed:@"checkd_checkbox_1x.png"] forState:UIControlStateNormal];
        isRememberPassword = YES;
    }

    signIn = [GPPSignIn sharedInstance];
    
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    
    signIn.scopes=@[kGTLAuthScopePlusLogin,@"https://www.googleapis.com/auth/plus.profile.emails.read",kGTLAuthScopePlusMe,kGTLAuthScopePlusLogin,@"profile"];
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    //signIn.scopes = @[kGTLAuthScopePlusLogin];  // "https://www.googleapis.com/auth/plus.login" scope
    //signIn.scopes = @[kGTLAuthScopePlusLogin,@"profile"];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;

}

-(void)viewWillAppear:(BOOL)animated
{
    
 
}

//! Login Method
-(IBAction)btnLoginClicked:(id)sender
{
    if (isRememberPassword) {
        [[NSUserDefaults standardUserDefaults] setObject:txtEmail.text forKey:@"LOGINEMAIL"];
        [[NSUserDefaults standardUserDefaults] setObject:txtPassword.text forKey:@"LOGINPASSWORD"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LOGINEMAIL"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"LOGINPASSWORD"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if ([txtEmail.text length]>0 && [txtPassword.text length]>0) {
        
        [SVProgressHUD show];
        [[RequestManager sharedManager]loginUserWithEmail:txtEmail.text WithPassword:txtPassword.text WithAuthorizedBy:@"" WithCompletion:^(BOOL result, id resultObject) {
            
            if (result) {
                
                NSLog(@"%@",resultObject);
                if ([[resultObject objectForKey:@"status"]isEqualToString:@"failure"]) {
                    
                    [SVProgressHUD dismiss];
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:[[resultObject objectForKey:@"response"] objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else {
                    [[DataManager sharedManager]saveAuthToken:resultObject WithSuccessBlock:^(BOOL result) {
                        
                        if (result) {
                            
                            [SVProgressHUD dismiss];
                            [(AppDelegate *)[[UIApplication sharedApplication] delegate] setController:YES];
                        }
                        else {
                            
                        }
                    }];
                }
            }
            else {
                
                [SVProgressHUD dismiss];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:[[resultObject objectForKey:@"response"] objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
            }
        }];

    }
    else {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please fill in the details" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];

    }

}

//! Forgot Password Button Clicked
-(IBAction)btnForgotPasswordClicked:(id)sender
{
    ForgotPasswordViewController * objForgot = [[ForgotPasswordViewController alloc]init];
    [self.navigationController pushViewController:objForgot animated:YES];
}

//! Login Via Facebook Clicked
-(IBAction)btnLoginViaFacebookClicked:(id)sender
{
    [[SocialManager sharedInstance]openFacebookSessionWithBasicPermissionWithCompletionBlock:^(BOOL success, NSError *error) {
        
        if (success) {
        
                    [[SocialManager sharedInstance]postToFacebookPageWithCompletionBlock:^(BOOL success, NSString *newsFeed, NSError *error) {
                        
                        if (success) {
                            
                            NSLog(@"%@",newsFeed);
                        }
                        else {
                            
                        }
                    }];

                }
                else {
                    
                }
            }];
            
 
/*            [[SocialManager sharedInstance] fetchNewsFeedFromFacebookWithCompletionBlock:^(BOOL success, NSString *newsFeed, NSError *error) {
                
                if (success) {
                    
                    NSLog(@"%@",newsFeed);
                    [[NSUserDefaults standardUserDefaults] setObject:newsFeed forKey:@"LOGINEMAIL"];
                    [[NSUserDefaults standardUserDefaults] synchronize];

                    [SVProgressHUD show];
                    [[RequestManager sharedManager]loginUserWithEmail:newsFeed WithPassword:@"" WithAuthorizedBy:@"facebook" WithCompletion:^(BOOL result, id resultObject) {
                        
                        if (result) {
                            NSLog(@"%@",resultObject);
                            if ([[resultObject objectForKey:@"status"]isEqualToString:@"failure"]) {
                                
                                [SVProgressHUD dismiss];
                                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:[[resultObject objectForKey:@"response"] objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                [alert show];
                            }
                            else {
                                [[DataManager sharedManager]saveAuthToken:resultObject WithSuccessBlock:^(BOOL result) {
                                    
                                    if (result) {
                                        
                                        [SVProgressHUD dismiss];
                                        [(AppDelegate *)[[UIApplication sharedApplication] delegate] setController:YES];
                                    }
                                    else {
                                        
                                    }
                                }];
                            }
                        }
                        else {
                            
                            [SVProgressHUD dismiss];
                        }

                    }];
                }
                else {
                    
                    
                }
                
           }];
*/
     
    
    
    
}

//! Login Via Google Plus Clicked
-(IBAction)btnLoginViaGoogleClicked:(id)sender
{
    
    //[signIn trySilentAuthentication];
    [[SocialManager sharedInstance]openFacebookSessionWithBasicPermissionWithCompletionBlock:^(BOOL success, NSError *error) {
        
        if (success) {
            [[SocialManager sharedInstance]postToFacebookPageWithCompletionBlock:^(BOOL success, NSString *newsFeed, NSError *error) {
                
                if (success) {
                    
                    NSLog(@"%@",newsFeed);
                }
                else {
                    
                }
            }];
        }
        else {
            
        }
    }];
    
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    NSLog(@"Received error %@ and auth object %@",error, auth);
    [self reportAuthStatus];
}

- (void)reportAuthStatus {
    if ([GPPSignIn sharedInstance].authentication) {
        NSLog(@"Status Authenticated");
    } else {
        // To authenticate, use Google+ sign-in button.
        NSLog(@"Status Not Authenticated");
    }
    [self refreshUserInfo];
}

// Update the interface elements containing user data to reflect the
// currently signed in user.
- (void)refreshUserInfo {
    if ([GPPSignIn sharedInstance].authentication == nil) {
        
        //[signIn authenticate];
        return;
    }
    
    NSString * strEmail = [GPPSignIn sharedInstance].userEmail;
    NSLog(@"%@",strEmail);
    
    [[NSUserDefaults standardUserDefaults] setObject:strEmail forKey:@"LOGINEMAIL"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [SVProgressHUD show];
    [[RequestManager sharedManager]loginUserWithEmail:strEmail WithPassword:@"" WithAuthorizedBy:@"gmail" WithCompletion:^(BOOL result, id resultObject) {
        
        if (result) {
            
        if ([[resultObject objectForKey:@"status"]isEqualToString:@"failure"]) {
            
            [SVProgressHUD dismiss];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:[[resultObject objectForKey:@"response"] objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else {
            [[DataManager sharedManager]saveAuthToken:resultObject WithSuccessBlock:^(BOOL result) {
                
                if (result) {
                    
                    [SVProgressHUD dismiss];
                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setController:YES];
                }
                else {
                    
                }
            }];
        }
    }
     else {
         
         [SVProgressHUD dismiss];
     }

     
    }];
    
    // The googlePlusUser member will be populated only if the appropriate
    // scope is set when signing in.
}

//! Remember Me Button Clicked
-(IBAction)btnRememberMeClicked:(id)sender
{
    if (!isRememberPassword) {
        
        [btnRememberMe setImage:[UIImage imageNamed:@"checkd_checkbox_1x.png"] forState:UIControlStateNormal];
        isRememberPassword = YES;
    }
    else {
        [btnRememberMe setImage:[UIImage imageNamed:@"uncheck_checkbox_1x.png"] forState:UIControlStateNormal];
        
        isRememberPassword = NO;
    }
 
}

//! Register User
-(IBAction)btnRegisterClicked:(id)sender
{
    RegisterViewController * objRegister = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:objRegister animated:YES];
}

//! Register Guest User
-(IBAction)btnRegisterAsGuestClicked:(id)sender
{
    RegisterGuestViewController * objGuest = [[RegisterGuestViewController alloc]init];
    [self.navigationController pushViewController:objGuest animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
