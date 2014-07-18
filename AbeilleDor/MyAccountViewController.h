//
//  MyAccountViewController.h
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoPickerProtocol <NSObject>

-(void)selectPickerOption:(NSString *)picker;

@end

@interface MyAccountViewController : UIViewController <PhotoPickerProtocol>
{
    IBOutlet UITextField * txtFirstName;
    IBOutlet UITextField * txtLastName;
    IBOutlet UITextField * txtEmail;
    IBOutlet UITextField * txtAddress;
    IBOutlet UITextField * txtPostalCode;
    IBOutlet UITextField * txtContactNo;
}
-(IBAction)btnSubmitClicked:(id)sender;
-(IBAction)btnChangePasswordClicked:(id)sender;
-(IBAction)btnOrderHistoryClicked:(id)sender;
@end
