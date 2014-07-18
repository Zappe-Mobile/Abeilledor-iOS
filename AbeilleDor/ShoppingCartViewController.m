//
//  ShoppingCartViewController.m
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "UINavigationController+Extras.h"
#import "DataManager.h"
#import "CartCell.h"
#import "HomeViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "RequestManager.h"
#import "Cart.h"
#import "SVProgressHUD.h"

#define kSectionCount 1
#define kRowHeight 110
#define kPayPalEnvironment PayPalEnvironmentProduction

@interface ShoppingCartViewController ()

@end

@implementation ShoppingCartViewController

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
    
    self.navigationItem.titleView = [self.navigationController setTitleView:@"Shopping Cart"];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    [self populateDataForCartFromArray:[DataManager loadAllProductsFromCart]];

    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.languageOrLocale = @"en";
    _payPalConfig.merchantName = @"Abeille d'Or (Singapore) Pte Ltd";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    // use default environment, should be Production in real life
    self.environment = kPayPalEnvironment;
    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"AWwMcRB_3boXKTB6Z-Ie6Wd9YLI4gF-zE9wUA3EcCbUTzB13mi3T7RQxVWkA",
                PayPalEnvironmentSandbox : @"AfIKyRCaQJZyM7iD9kAR3oOZbXCgMcHp1QlXAxAYXoKHL26i5y6QT8OwOn1Q"}];
    [PayPalMobile preconnectWithEnvironment:self.environment];

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


#pragma mark - Table View Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return kSectionCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrayProductName count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    CartCell *cell = (CartCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[CartCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier] ;
    }
    //for dynamic data
    
    cell.lblProductName.text = [arrayProductName objectAtIndex:indexPath.row];
    
    NSURL * url = [NSURL URLWithString:[arrayImages objectAtIndex:indexPath.row]];
    
    [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            cell.imgProduct.image = image;
        }
        else {
            cell.imgProduct.image = [UIImage imageNamed:@"default_placeholder-image.png"];
        }
    }];

    cell.lblSliderValue.text = [arrayProductQuantity objectAtIndex:indexPath.row];
    
    cell.sliderQuantity.tag = indexPath.row;
    cell.sliderQuantity.value = [[arrayProductQuantity objectAtIndex:indexPath.row]floatValue];
    [cell.sliderQuantity addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    cell.btnTrash.tag = indexPath.row;
    [cell.btnTrash addTarget:self action:@selector(btnTrashClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnTrash setBackgroundImage:[UIImage imageNamed:@"Trash_brown.png"] forState:UIControlStateNormal];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
//    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:0.1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)btnTrashClicked:(UIButton *)sender
{
    
    NSString * str = [[NSUserDefaults standardUserDefaults]objectForKey:@"CART"];
    int x = [str intValue];
    x = x-1;
    str = [NSString stringWithFormat:@"%d",x];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:str forKey:@"CART"];
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BADGECOUNT" object:str];

    [DataManager removeItemFromCartWithProductId:[arrayProductId objectAtIndex:sender.tag] WithDataBlock:^(BOOL success, NSError *error) {
        
        if (success) {
            
            NSLog(@"Item Removed");
            [DataManager updateProductsListForRemovalFromShoppingCartWithProductId:[arrayProductId objectAtIndex:sender.tag] WithDataBlock:^(BOOL success, NSError *error) {
                
                if (success) {
                  
                        [self populateDataForCartFromArray:[DataManager loadAllProductsFromCart]];
                }else {
                    
                }
            }];
            
        }
        else {
            
        }
    }];
    
}

-(void)sliderValueChanged:(UISlider *)sender
{
    float x = sender.value;
    int result = (int)roundf(x);
    NSString * str = [NSString stringWithFormat:@"%d",result];
    
    if ([str isEqualToString:@"0"]) {
        str = @"1";
        sender.value = 1.0f;
    }
    
    [arrayProductQuantity replaceObjectAtIndex:sender.tag withObject:str];
    
    [DataManager updateCartWithProductId:[arrayProductId objectAtIndex:sender.tag] WithProductQuantity:[arrayProductQuantity objectAtIndex:sender.tag] WithDataBlock:^(BOOL success, NSError *error) {
        
        if (success) {
            
        }
        else {
            
        }
    }];
    
    float paymentValue= 0.0;
    if ([arrayProductName count]>0) {
        
        for (int a = 0; a<[arrayProductPrice count]; a++) {
            
            NSString * strPrice = [arrayProductPrice objectAtIndex:a];
            float x = [strPrice floatValue];
            
            NSString * strQuantity = [arrayProductQuantity objectAtIndex:a];
            int y = [strQuantity intValue];
            
            float z = (float)x*y;
            
            paymentValue = paymentValue + z;
        }
    }
    
    NSString *strPayment = [NSString stringWithFormat:@"%.2f", paymentValue];
    lblCartSubTotal.text = [NSString stringWithFormat:@"Cart Total : %@",strPayment];

    
    [tblCart reloadData];
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

//! Populate Data
-(void)populateDataForCartFromArray:(NSArray *)array
{
    NSLog(@"%@",array);
    
    arrayImages = [[NSMutableArray alloc]init];
    arrayProductName = [[NSMutableArray alloc]init];
    arrayRating = [[NSMutableArray alloc]init];
    arrayReviews = [[NSMutableArray alloc]init];
    arrayProductId = [[NSMutableArray alloc]init];
    arrayProductPrice = [[NSMutableArray alloc]init];
    arrayProductQuantity = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<[array count]; i++) {
        
        NSManagedObject * info = [array objectAtIndex:i];
        
        [arrayImages addObject:[info valueForKey:@"productImageUrl"]];
        [arrayProductName addObject:[info valueForKey:@"productName"]];
        [arrayRating addObject:[info valueForKey:@"productRating"]];
        [arrayReviews addObject:[info valueForKey:@"productReviews"]];
        [arrayProductId addObject:[info valueForKey:@"productId"]];
        [arrayProductPrice addObject:[info valueForKey:@"productPrice"]];
        [arrayProductQuantity addObject:[info valueForKey:@"productQuantity"]];
    }
    
    NSLog(@"%@",arrayProductName);
    
    float paymentValue= 0.0;
    if ([arrayProductName count]>0) {
        
        for (int a = 0; a<[arrayProductPrice count]; a++) {
            
            NSString * strPrice = [arrayProductPrice objectAtIndex:a];
            float x = [strPrice floatValue];
            
            NSString * strQuantity = [arrayProductQuantity objectAtIndex:a];
            int y = [strQuantity intValue];
            
            float z = (float)x*y;
            
            paymentValue = paymentValue + z;
        }
    }

    
    NSString *strPayment = [NSString stringWithFormat:@"%.2f", paymentValue];
    lblCartSubTotal.text = [NSString stringWithFormat:@"Cart Total : %@",strPayment];
    
    [tblCart reloadData];
}

-(IBAction)btnCheckoutClicked:(id)sender
{
    float paymentValue= 0.0;
    if ([arrayProductName count]>0) {
        
        for (int a = 0; a<[arrayProductPrice count]; a++) {
            
            NSString * strPrice = [arrayProductPrice objectAtIndex:a];
            float x = [strPrice floatValue];
            
            NSString * strQuantity = [arrayProductQuantity objectAtIndex:a];
            int y = [strQuantity intValue];
            
            float z = (float)x*y;
            
            paymentValue = paymentValue + z;
        }
        
        
        NSLog(@"%f",paymentValue);
        PayPalPayment *payment = [[PayPalPayment alloc] init];
        NSString *str = [NSString stringWithFormat:@"%.2f", paymentValue];
        payment.amount = [[NSDecimalNumber alloc] initWithString:str];
        payment.currencyCode = @"SGD";
        payment.shortDescription = @"Payment";
        
        if (!payment.processable) {
            // This particular payment will always be processable. If, for
            // example, the amount was negative or the shortDescription was
            // empty, this payment wouldn't be processable, and you'd want
            // to handle that here.
        }
        
        // Update payPalConfig re accepting credit cards.
        self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
        
        PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                    configuration:self.payPalConfig
                                                                                                         delegate:self];
        [self presentViewController:paymentViewController animated:YES completion:nil];

    }
    else {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No Items to Checkout" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];

    }
}

#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment {
    NSLog(@"PayPal Payment Success!");
    NSLog(@"%@",completedPayment);
    //    self.resultText = [completedPayment description];
    //    [self showSuccess];
    //
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Proof of payment validation
- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment {
    //TO DO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Payment Successfully Processed" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil,nil];
    [alert show];
    
    NSLog(@"%@",[[completedPayment.confirmation objectForKey:@"response"]objectForKey:@"id"]);
    NSLog(@"%@",completedPayment.localizedAmountForDisplay);
    
    NSString * productIdResult = [arrayProductId componentsJoinedByString:@","];
    NSString * quantityResult = [arrayProductQuantity componentsJoinedByString:@","];

    NSLog(@"%@",productIdResult);
    NSLog(@"%@",quantityResult);
    
    [SVProgressHUD show];
    
    [[RequestManager sharedManager]sendOrderHistoryWithIdNumber:[[completedPayment.confirmation objectForKey:@"response"]objectForKey:@"id"] WithDate:@"" WithMoney:completedPayment.localizedAmountForDisplay WithAddress:@"" WithProductIds:productIdResult WithQuantity:quantityResult WithCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            
            [SVProgressHUD dismiss];
            
            
            
            for (int x = 0; x <[arrayProductId count]; x++) {
                
                [DataManager updateProductsListForRemovalFromShoppingCartWithProductId:[arrayProductId objectAtIndex:x] WithDataBlock:^(BOOL success, NSError *error) {
                    
                    if (success) {
                        
                        [DataManager removeAllItemsFromCartWithDataBlock:^(BOOL success, NSError *error) {
                            
                            if (success) {
                                
                                [self populateDataForCartFromArray:[DataManager loadAllProductsFromCart]];
                            }
                            else {
                                
                            }
                        }];

                    }
                    else {
                        
                    }
                }];
                
            }

        }
        else {
            [SVProgressHUD dismiss];
        }
    }];
    
    
    NSString * str = [[NSUserDefaults standardUserDefaults]objectForKey:@"CART"];
    int x = [str intValue];
    x = 0;
    str = [NSString stringWithFormat:@"%d",x];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:str forKey:@"CART"];
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BADGECOUNT" object:str];


}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    NSLog(@"PayPal Payment Canceled");
    //    self.resultText = nil;
    //    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalFuturePaymentDidCancel:(PayPalFuturePaymentViewController *)futurePaymentViewController
{
    
    
}

- (void)payPalFuturePaymentViewController:(PayPalFuturePaymentViewController *)futurePaymentViewController
                didAuthorizeFuturePayment:(NSDictionary *)futurePaymentAuthorization
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
