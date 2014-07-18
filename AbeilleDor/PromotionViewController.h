//
//  PromotionViewController.h
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@interface PromotionViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIButton * btnVideo;
    NSString *str;
    
    IBOutlet UITextField * txtName;
    IBOutlet UITextField * txtMobile;
    IBOutlet UITextField * txtEmail;
    IBOutlet UITextField * txtCode;
    IBOutlet UITextField * txtCustomerEmail;
    
    UIView * viewRedeem;
    
    UIWebView * videoView;
    UILabel * lblHeading;
}
-(IBAction)btnPlayClicked:(id)sender;
-(IBAction)btnRedeemClicked:(id)sender;
-(IBAction)btnSubmitClicked:(id)sender;
-(IBAction)btnCancelClicked:(id)sender;
@end
