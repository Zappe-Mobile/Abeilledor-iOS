//
//  MyAccountViewController.m
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "MyAccountViewController.h"
#import "UINavigationController+Extras.h"
#import "HomeViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "RequestManager.h"
#import "SVProgressHUD.h"
#import "ChangePasswordViewController.h"
#import "OrderHistoryViewController.h"
#import "PhotoPickerView.h"

@interface MyAccountViewController () <UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIImageView * profileImage;
    PhotoPickerView * pickerView;
    
    UIImagePickerController * cameraPicker;
    NSString * pickerValue;
}
@end

@implementation MyAccountViewController

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
    
    self.navigationItem.titleView = [self.navigationController setTitleView:@"My Account"];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]init];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = self;
    [tapGesture addTarget:self action:@selector(profileImageClicked:)];
    [profileImage addGestureRecognizer:tapGesture];
    
    
    [SVProgressHUD show];
    [[RequestManager sharedManager]getAccountInfoWithEmailId:@"" WithCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            [SVProgressHUD dismiss];
            NSLog(@"%@",resultObject);
            txtEmail.text = [resultObject objectForKey:@"email"];
            txtFirstName.text = [resultObject objectForKey:@"fname"];
            txtLastName.text = [resultObject objectForKey:@"lname"];
            txtAddress.text = [resultObject objectForKey:@"address"];
            txtPostalCode.text = [resultObject objectForKey:@"postalcode"];
            txtContactNo.text = [resultObject objectForKey:@"phonenumber"];
            
            NSURL * url = [NSURL URLWithString:[resultObject objectForKey:@"profilepicurl"]];
            
            [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
                if (succeeded) {
                    profileImage.image = image;
                }
                else {
                    profileImage.image = [UIImage imageNamed:@"photo_frame.png"];
                }
            }];

        }
        else {
            [SVProgressHUD dismiss];
        }
    }];
}


- (void)profileImageClicked:(UIGestureRecognizer *)sender
{
    pickerView = [[NSBundle mainBundle] loadNibNamed:@"PhotoPickerView" owner:self options:nil][0];
    pickerView.delegate = self;
    [self.view addSubview:pickerView];

}

- (void)selectPickerOption:(NSString *)picker
{
    if ([picker isEqualToString:@"1"]) {
        
        cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraPicker.delegate = self;
        
        [pickerView removeFromSuperview];
        [self presentViewController:cameraPicker animated:YES completion:nil];

    }
    else if ([picker isEqualToString:@"2"]) {
        
        cameraPicker = [[UIImagePickerController alloc] init];
        cameraPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        cameraPicker.delegate = self;
        
        [pickerView removeFromSuperview];
        [self presentViewController:cameraPicker animated:YES completion:nil];

    }
    else {
        [pickerView removeFromSuperview];
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    
    UIImage * imageOne = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    profileImage.image = imageOne;
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

-(IBAction)btnSubmitClicked:(id)sender
{
    //UIImage * img = [UIImage imageNamed:@"product_abeilledor.png"];
    [SVProgressHUD show];
    [[RequestManager sharedManager]setAccountInfoWithFirstName:txtFirstName.text WithLastName:txtLastName.text WithEmail:txtEmail.text WithAddress:txtAddress.text WithPostalCode:txtPostalCode.text WithPhoneNo:txtContactNo.text WithProfilePicture:@"" withPicture:profileImage.image WithCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            [SVProgressHUD dismiss];
            NSLog(@"%@",resultObject);
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:[[resultObject objectForKey:@"response"]objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        
        }
        else {
            [SVProgressHUD dismiss];
        }
    }];
}

-(IBAction)btnChangePasswordClicked:(id)sender
{
    ChangePasswordViewController * objChange = [[ChangePasswordViewController alloc]init];
    [self.navigationController pushViewController:objChange animated:YES];
}

-(IBAction)btnOrderHistoryClicked:(id)sender
{
    OrderHistoryViewController * objOrder = [[OrderHistoryViewController alloc]init];
    [self.navigationController pushViewController:objOrder animated:YES];
}

#pragma mark - Asynchronous Image Download
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
