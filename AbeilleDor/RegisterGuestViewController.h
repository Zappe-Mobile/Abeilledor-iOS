//
//  RegisterGuestViewController.h
//  AbeilleDor
//
//  Created by Admin on 28/03/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterGuestViewController : UIViewController
{
    IBOutlet UITextField * txtName;
    IBOutlet UITextField * txtEmail;
    IBOutlet UITextField * txtMobile;
    IBOutlet UITextField * txtCompany;
    IBOutlet UIButton * btnSubmit;
}
-(IBAction)btnSubmitClicked:(id)sender;
@end
