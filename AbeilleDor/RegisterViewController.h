//
//  RegisterViewController.h
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIDropDown.h"

@interface RegisterViewController : UIViewController<NIDropDownDelegate>
{
    IBOutlet UITextField * txtEmail;
    IBOutlet UITextField * txtPassword;
    IBOutlet UIButton * btnSex;
    IBOutlet UIButton * btnAge;
    IBOutlet UIButton * btnAccept;
    
    NIDropDown * dropDown;
    BOOL isAccept;
}

//! Selectors
-(IBAction)btnAgeClicked:(id)sender;
-(IBAction)btnSexClicked:(id)sender;
-(IBAction)btnSignUpClicked:(id)sender;
-(IBAction)btnDisclaimerClicked:(id)sender;
-(IBAction)btnAcceptTermsClicked:(id)sender;
@end
