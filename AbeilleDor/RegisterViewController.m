//
//  RegisterViewController.m
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "RegisterViewController.h"
#import "SVProgressHUD.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"
#import "DisclaimerViewController.h"
#import "ValidataionConstant.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
    
    self.navigationItem.titleView = [self.navigationController setTitleView:@"Sign Up"];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    isAccept = NO;
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

//! Age Button Clicked
-(IBAction)btnAgeClicked:(id)sender
{
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];
    
    NSArray * array = [[NSArray alloc]initWithObjects:@"1 - 10",@"11 - 20",@"21 - 30",@"31 - 40",@"41 - 50",@"51 - 60",
                       @"61 - 70",@"71 - 80",@"81 - 90",@"91 - 100",nil];
    NSArray * arrayImage = [[NSArray alloc]init];
    
    if(dropDown == nil) {
        CGFloat f = 160;
        dropDown = [[NIDropDown alloc]showDropDownFromButton:sender WithHeight:&f WithContentArray:array WithImageArray:arrayImage WithDirection:@"down"];
        dropDown.tag = 11;
        dropDown.delegate = self;
        
        
    }
    else
    {
        [dropDown hideDropDown:sender];
        [self rel];
    }

}

//! Sex Button Clicked
-(IBAction)btnSexClicked:(id)sender
{
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];

    NSArray * array = [[NSArray alloc]initWithObjects:@"Male",@"Female",nil];
    NSArray * arrayImage = [[NSArray alloc]init];
    
    if(dropDown == nil) {
        CGFloat f = 80;
        dropDown = [[NIDropDown alloc]showDropDownFromButton:sender WithHeight:&f WithContentArray:array WithImageArray:arrayImage WithDirection:@"down"];
        dropDown.tag = 101;
        dropDown.delegate = self;
        
        
    }
    else
    {
        [dropDown hideDropDown:sender];
        [self rel];
    }

}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender withindex:(int)index
{
    if (sender.tag == 11) {
        NSLog(@"Age");
    }
    else {
        NSLog(@"Sex");
    }
}


-(void)rel
{
    dropDown = nil;
    
}

//! Disclaimer Clicked
-(IBAction)btnDisclaimerClicked:(id)sender
{
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];

    DisclaimerViewController * objDisclaimer = [[DisclaimerViewController alloc]init];
    [self.navigationController pushViewController:objDisclaimer animated:YES];
}

-(IBAction)btnAcceptTermsClicked:(id)sender
{
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];

    isAccept = YES;
    [btnAccept setBackgroundImage:[UIImage imageNamed:@"checkd_checkbox_1x.png"] forState:UIControlStateNormal];
}

//! Sign Up Button Clicked
-(IBAction)btnSignUpClicked:(id)sender
{
    NSLog(@"%@",btnAge.titleLabel.text);
    NSLog(@"%@",btnSex.titleLabel.text);
    
    NSError * error = nil;
    if ([ValidataionConstant validateEmail:txtEmail.text errorMessage:&error] && isAccept && [txtEmail.text length]>0 && [txtPassword.text length]>0 && [btnAge.titleLabel.text length]>0 && [btnSex.titleLabel.text length]>0) {
        
        [SVProgressHUD show];
        
        [[RequestManager sharedManager]registerUserWithEmail:txtEmail.text WithPassword:txtPassword.text WithAge:btnAge.titleLabel.text WithSex:btnSex.titleLabel.text WithCompletion:^(BOOL result, id resultObject) {
            
            if (result) {
                [SVProgressHUD dismiss];
                [[NSUserDefaults standardUserDefaults]setObject:txtEmail.text forKey:@"EMAIL"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Successfully Registered" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else {
                [SVProgressHUD dismiss];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[[resultObject objectForKey:@"response"]objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];

    }
    else {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid Email" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];

    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
