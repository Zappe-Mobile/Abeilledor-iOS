//
//  PromotionViewController.m
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "PromotionViewController.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"
#import "DMEThumbnailer.h"
#import "HomeViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "RequestManager.h"
#import "Reachability.h"
#import "SVProgressHUD.h"

@interface PromotionViewController ()

@end

@implementation PromotionViewController

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
    
    self.navigationItem.titleView = [self.navigationController setTitleView:@"Promotion"];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    btnVideo.layer.borderWidth = 1.0;
    btnVideo.layer.borderColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0].CGColor;
    [btnVideo setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    btnVideo.enabled = NO;
    
    
    [[RequestManager sharedManager]loadPromotionVideoWithCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            
            NSDictionary * dict = [resultObject objectForKey:@"response"];
            
            NSLog(@"%@",dict);
            
            str = [dict valueForKey:@"video"];
            
            
            
            NSLog(@"%@",str);
            
            str = [NSString stringWithFormat:@"http:%@",str];
            
            NSLog(@"%@",str);
            
            //NSURL *videoURL = [NSURL URLWithString:str];
            
            
            //NSString *videoURL = @"http://youtu.be/Wq_CtkKrt1o";
            
            videoView = [[UIWebView alloc] initWithFrame:CGRectMake(25, 44, 270, 200)];
            videoView.backgroundColor = [UIColor clearColor];
            videoView.opaque = NO;
            videoView.delegate = self;
            [self.view addSubview:videoView];
            
            
            NSString *videoHTML = [NSString stringWithFormat:@"\
                                   <html>\
                                   <head>\
                                   <style type=\"text/css\">\
                                   iframe {position:absolute; top:50%%; margin-top:-130px;}\
                                   body {background-color:#000; margin:0;}\
                                   </style>\
                                   </head>\
                                   <body>\
                                   <iframe width=\"100%%\" height=\"240px\" src=\"%@\" frameborder=\"0\" allowfullscreen></iframe>\
                                   </body>\
                                   </html>", str];
            
            [videoView loadHTMLString:videoHTML baseURL:nil];
            
            lblHeading = [[UILabel alloc]init];
            lblHeading.frame = CGRectMake(25, 20, 270, 15);
            lblHeading.backgroundColor = [UIColor clearColor];
            lblHeading.textColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0];
            lblHeading.text = [dict valueForKey:@"heading"];
            lblHeading.font = [UIFont fontWithName:@"Avenir-Roman" size:14];
            [self.view addSubview:lblHeading];
            
//            [[DMEThumbnailer sharedInstance]generateVideoThumbnail:str widthSize:CGSizeMake(270, 200) completionBlock:^(UIImage *__autoreleasing *thumb) {
//                
//                [btnVideo setBackgroundImage:*thumb forState:UIControlStateNormal];
//                btnVideo.enabled = YES;
//                
//            }];
            
        }
        else {
            
        }
    }];
}

#pragma mark - Set Navigation Bar Left Button
//! Set Left Bar Button
- (UIBarButtonItem *)setLeftBarButton
{
    UIButton * btnSettings = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSettings.frame = CGRectMake(0, 0, 25, 25);
    [btnSettings setImage:[UIImage imageNamed:@"Home_New.png"] forState:UIControlStateNormal];
    [btnSettings addTarget:self action:@selector(btnLeftBarClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barBtnItem = [[UIBarButtonItem alloc]initWithCustomView:btnSettings];
    
    return barBtnItem;
}

#pragma mark - Navigation Bar Left Button Selector
//! Method invoked when left bar button clicked
- (void)btnLeftBarClicked
{
    UINavigationController * homeNav = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc]init]];
    self.sidePanelController.centerPanel = homeNav;
}


-(IBAction)btnPlayClicked:(id)sender
{
    NSURL *videoURL = [NSURL URLWithString:str] ;
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc]initWithContentURL:videoURL];
    [self presentMoviePlayerViewControllerAnimated:player];

}

-(IBAction)btnRedeemClicked:(id)sender
{
    viewRedeem = [self getTemplateView:@"Redeem" for:self];
    [viewRedeem setAlpha:0];
    
    viewRedeem.layer.cornerRadius = 5.0;
    
    CGRect rect = viewRedeem.frame;
    rect.origin.x = rect.origin.x;
    rect.origin.y = rect.origin.y;
    [viewRedeem setFrame:rect];
    
    [self.navigationController.view addSubview:viewRedeem];
    
    [UIView beginAnimations:nil context:NULL];
    
    [viewRedeem setUserInteractionEnabled:YES];
    
    [UIView setAnimationDuration:.5];
    
    [viewRedeem setAlpha:1];
    
    [UIView commitAnimations];
    
    txtEmail.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"LOGINEMAIL"];

}

-(IBAction)btnSubmitClicked:(id)sender
{
    if ([[Reachability reachabilityForInternetConnection]isReachable]) {
        
        if ([txtName.text length]>0 && [txtCode.text length]>0 && [txtMobile.text length]>0 && [txtEmail.text length]>0) {
            
            NSLog(@"%@",txtEmail.text);
            
            [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
            [[RequestManager sharedManager]redeemCouponsWithName:txtName.text WithMobile:txtMobile.text WithEmail:txtEmail.text WithCouponCode:txtCode.text WithCompletionBlock:^(BOOL result, id resultObject) {
                
                [SVProgressHUD dismiss];
                if (result) {
                    
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Coupon Redeemed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    txtName.text = @"";
                    txtCode.text = @"";
                    txtMobile.text = @"";
                    
                }
                else {
                    
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:[[resultObject objectForKey:@"response"] objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                    
                    txtName.text = @"";
                    txtCode.text = @"";
                    txtMobile.text = @"";

                }
                
            }];

        }
        else {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please fill in all data" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];

        }

    }
    else {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Internet Connection Not Available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];

    }
}

-(IBAction)btnCancelClicked:(id)sender
{
    [UIView transitionWithView:viewRedeem duration:0.6 options:UIViewAnimationOptionTransitionNone animations:^{
        [viewRedeem setAlpha:0];
    } completion:^(BOOL finished) {
        [viewRedeem removeFromSuperview];
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    }];
    
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - View Loading Template Methods
- (UIView *)getTemplateView:(NSString*)template for:(id)s
{
    
    return [self getTemplateView:template for:s atIndex:0];
    
}

- (UIView *)getTemplateView:(NSString*)template for:(id)s atIndex:(int)index
{
    
    BOOL isIpad = ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad);
    
    if(isIpad){
        
        template = [NSString stringWithFormat:@"%@",template];
        
    }else{
        
        template = [NSString stringWithFormat:@"%@",template];
        
    }
    
    NSArray * ViewAry = [[NSBundle mainBundle] loadNibNamed:template owner:s options:nil];
    
    return [ViewAry objectAtIndex:index];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
