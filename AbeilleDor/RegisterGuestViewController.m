//
//  RegisterGuestViewController.m
//  AbeilleDor
//
//  Created by Admin on 28/03/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import "RegisterGuestViewController.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"

@interface RegisterGuestViewController ()

@end

@implementation RegisterGuestViewController

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
    
    self.navigationItem.titleView = [self.navigationController setTitleView:@"Guest Registration"];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];

}

#pragma mark - Set Navigation Bar Left Button
//! Set Left Bar Button
- (UIBarButtonItem *)setLeftBarButton
{
    UIButton * btnSettings = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSettings.frame = CGRectMake(0, 0, 20, 20);
    [btnSettings setImage:[UIImage imageNamed:@"navbar_btn_back@2x.png"] forState:UIControlStateNormal];
    [btnSettings addTarget:self action:@selector(btnLeftBarClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barBtnItem = [[UIBarButtonItem alloc]initWithCustomView:btnSettings];
    
    return barBtnItem;
}

#pragma mark - Navigation Bar Left Button Selector
//! Method invoked when left bar button clicked
- (void)btnLeftBarClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnSubmitClicked:(id)sender
{
    [[RequestManager sharedManager]registerForGuestWithName:txtName.text WithEmail:txtEmail.text WithMobile:txtMobile.text WithCompanyName:txtCompany.text WithCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            
            txtName.text = @"";
            txtEmail.text = @"";
            txtMobile.text = @"";
            txtCompany.text = @"";
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Guest account has been successfully registered" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else {
            
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
