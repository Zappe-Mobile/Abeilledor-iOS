//
//  ChangePasswordViewController.h
//  AbeilleDor
//
//  Created by Roman Khan on 13/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController
{
    IBOutlet UITextField * txtOldPassword;
    IBOutlet UITextField * txtNewPassword;
    IBOutlet UITextField * txtConfirmPassword;
}
-(IBAction)btnSubmitClicked:(id)sender;
@end
