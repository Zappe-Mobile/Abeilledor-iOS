//
//  ContactUsViewController.m
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "ContactUsViewController.h"
#import "UINavigationController+Extras.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "HomeViewController.h"
#import "RequestManager.h"
#import "SVProgressHUD.h"

@interface ContactUsViewController ()

@end

@implementation ContactUsViewController

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
    
    self.navigationItem.titleView = [self.navigationController setTitleView:@"Contact Us"];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    objScrollView.contentSize = CGSizeMake(320, 750);
    
    txtMessage.placeholder = @"Message";
    
    MKCoordinateSpan span;
    span.latitudeDelta=0.05;
    span.longitudeDelta=0.05;
    
    MKCoordinateRegion region;
    region.center.latitude = 1.29196;
    region.center.longitude = 103.8502;
    
    region.span = span;
    
    [objMapView setRegion:region];

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

//! Send Button Method
-(IBAction)btnSendClicked:(id)sender
{
    [SVProgressHUD showWithStatus:@"Processing" maskType:SVProgressHUDMaskTypeBlack];
    [[RequestManager sharedManager]contactUsWithName:txtName.text WithEmail:txtEmail.text WithMessage:txtMessage.text WithCompletionBlock:^(BOOL result, id resultObject) {
        
        [SVProgressHUD dismiss];
        if (result) {
            NSLog(@"%@",resultObject);
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Successfully Sent" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
            txtName.text = @"";
            txtEmail.text = @"";
            txtMessage.text = @"";

            
        }
        else {
           
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:[[resultObject objectForKey:@"response"] objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
            txtName.text = @"";
            txtEmail.text = @"";
            txtMessage.text = @"";

        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
