//
//  LoginViewController.h
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>

@class GPPSignInButton;
@interface LoginViewController : UIViewController<GPPSignInDelegate>
{
    IBOutlet UITextField * txtEmail;
    IBOutlet UITextField * txtPassword;
    
    BOOL isRememberPassword;
    
    IBOutlet UIButton * btnRememberMe;
    IBOutlet GPPSignInButton * btnGoogleSignInButton;
    
    GPPSignIn *signIn;
}
@property (nonatomic,strong) IBOutlet GPPSignInButton * btnGoogleSignInButton;
//! Selectors
-(IBAction)btnLoginClicked:(id)sender;
-(IBAction)btnForgotPasswordClicked:(id)sender;
-(IBAction)btnLoginViaFacebookClicked:(id)sender;
-(IBAction)btnLoginViaGoogleClicked:(id)sender;
-(IBAction)btnRememberMeClicked:(id)sender;
-(IBAction)btnRegisterClicked:(id)sender;
-(IBAction)btnRegisterAsGuestClicked:(id)sender;
@end
