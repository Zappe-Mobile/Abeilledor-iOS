//
//  ForgotPasswordViewController.h
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController
{
    IBOutlet UITextField * txtEmail;
}

//! Selectors
-(IBAction)btnSubmitClicked:(id)sender;
@end
