//
//  YakultDetailViewController.m
//  AbeilleDor
//
//  Created by Roman Khan on 06/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "YakultDetailViewController.h"
#import "UINavigationController+Extras.h"
#import "Yakult.h"
#import "DataManager.h"
#import "NSString+HTML.h"
#import "ReviewViewController.h"
#import "RequestManager.h"
#import "ALToastView.h"
#import "SVProgressHUD.h"

@interface YakultDetailViewController ()

@end

@implementation YakultDetailViewController
@synthesize strProductId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.titleView = [self.navigationController setTitleView:@"Product Detail"];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    imgStarOne.hidden = YES;
    imgStarTwo.hidden = YES;
    imgStarThree.hidden = YES;
    imgStarFour.hidden = YES;
    imgStarFive.hidden = YES;
    
    objScrollView.contentSize = CGSizeMake(320, 450);
    
    btnQA.layer.cornerRadius = 5.0;
    
    NSLog(@"%@",strProductId);
    
    NSArray * object = [DataManager loadYakultProductDetailForProductId:strProductId];
    
    NSLog(@"%@",object);
    
    objProduct = [object objectAtIndex:0];
    
    if ([objProduct.isWishlist isEqualToString:@"1"]) {
        [btnAddToWishlist setTitle:@"Added To Wishlist" forState:UIControlStateNormal];
        btnAddToWishlist.userInteractionEnabled = NO;
    }
    else {
        [btnAddToWishlist setTitle:@"Add To Wishlist" forState:UIControlStateNormal];
        btnAddToWishlist.userInteractionEnabled = YES;
    }

    
    NSURL * url = [NSURL URLWithString:objProduct.productImageUrl];
    
    [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            imgProduct.image = image;
        }
        else {
            imgProduct.image = [UIImage imageNamed:@"default_placeholder-image.png"];
        }
    }];
    
    NSString * strReview = [NSString stringWithFormat:@"Review(%@)",objProduct.productReviews];
    
    [btnReview setTitle:strReview forState:UIControlStateNormal];
    
    lblProductName.text = objProduct.productName;
    
    txtProductDesc.text = [objProduct.productDescription stringByConvertingHTMLToPlainText];
    
    lblProductPrice.text = objProduct.productPrice;

    
    if ([objProduct.productRating isEqualToString:@"0"]) {
        
        
    }
    else if ([objProduct.productRating isEqualToString:@"1"]) {
        
        imgStarOne.hidden = NO;
    }
    else if ([objProduct.productRating isEqualToString:@"2"]) {
        
        imgStarOne.hidden = NO;
        imgStarTwo.hidden = NO;
    }
    else if ([objProduct.productRating isEqualToString:@"3"]) {
        
        imgStarOne.hidden = NO;
        imgStarTwo.hidden = NO;
        imgStarThree.hidden = NO;
    }
    else if ([objProduct.productRating isEqualToString:@"4"]) {
        
        imgStarOne.hidden = NO;
        imgStarTwo.hidden = NO;
        imgStarThree.hidden = NO;
        imgStarFour.hidden = NO;
    }
    else if ([objProduct.productRating isEqualToString:@"5"]) {
        
        imgStarOne.hidden = NO;
        imgStarTwo.hidden = NO;
        imgStarThree.hidden = NO;
        imgStarFour.hidden = NO;
        imgStarFive.hidden = NO;
    }

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

#pragma mark - Review Controller
//! Navigate to Review Controller
-(IBAction)btnReviewClicked:(id)sender
{
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    [[RequestManager sharedManager]loadAllReviewsWithProductId:strProductId WithCompletionBlock:^(BOOL result, id resultObject) {
        
        [SVProgressHUD dismiss];
        if (result) {
            ReviewViewController * objReview = [[ReviewViewController alloc]init];
            objReview.strProductId = strProductId;
            objReview.arrayReviews = [resultObject objectForKey:@"response"];
            [self.navigationController pushViewController:objReview animated:YES];
        }
        else {
            ReviewViewController * objReview = [[ReviewViewController alloc]init];
            objReview.strProductId = strProductId;
            [self.navigationController pushViewController:objReview animated:YES];
        }
    }];

}

#pragma mark - Add to Wishlist
//! Selector for Adding to Wishlist
-(IBAction)btnAddToWishlistClicked:(id)sender
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setObject:strProductId forKey:@"productId"];
    [dict setObject:lblProductName.text forKey:@"productName"];
    [dict setObject:objProduct.productImageUrl forKey:@"productImage"];
    [dict setObject:objProduct.productRating forKey:@"productRating"];
    [dict setObject:objProduct.productReviews forKey:@"productReviews"];
    [dict setObject:objProduct.productPrice forKey:@"productPrice"];
    [dict setObject:@"yakult" forKey:@"productType"];
    
    [ALToastView toastInView:self.view withText:@"Item Added to Wishlist"];
    
    [DataManager addProductsToWishlist:dict WithDataBlock:^(BOOL success, NSError *error) {
        
        //! Items Added to Wishlist
        if (success) {
            
            [DataManager updateAddWishlistYakultWithProductId:strProductId WithDataBlock:^(BOOL success, NSError *error) {
                
                if (success) {
                    
                }
                else {
                    
                }
            }];

        }
        //! Storage Failure
        else {
            
        }
    }];

}



#pragma mark - Q&A Popup
//! Popup for Q&A Posting
-(IBAction)btnQAClicked:(id)sender
{
    viewQA = [self getTemplateView:@"YakultQA" for:self];
    [viewQA setAlpha:0];
    
    viewQA.layer.cornerRadius = 5.0;
    
    CGRect rect = viewQA.frame;
    rect.origin.x = rect.origin.x;
    rect.origin.y = rect.origin.y;
    [viewQA setFrame:rect];
    
    [self.navigationController.view addSubview:viewQA];
    
    [UIView beginAnimations:nil context:NULL];
    
    [viewQA setUserInteractionEnabled:YES];
    
    [UIView setAnimationDuration:.5];
    
    [viewQA setAlpha:1];
    
    [UIView commitAnimations];
    
    txtEmail.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"LOGINEMAIL"];
}

#pragma mark - Q&A Popup Cancel
//! Selector for Q&A Popup Cancel
-(IBAction)btnCancelClicked:(id)sender
{
    [UIView transitionWithView:viewQA duration:0.6 options:UIViewAnimationOptionTransitionNone animations:^{
        [viewQA setAlpha:0];
    } completion:^(BOOL finished) {
        [viewQA removeFromSuperview];
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    }];
 
}

#pragma mark - Q&A Webservice Submit
//! Submit Button for Q&A
//! Webservice Request for Yakult Products Q&A
-(IBAction)btnSubmitClicked:(id)sender
{
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    [[RequestManager sharedManager]sendQueryWithProductId:strProductId WithEmailId:txtEmail.text WithQuery:txtQuery.text WithCompletionBlock:^(BOOL result, id resultObject) {
        
        [SVProgressHUD dismiss];
        if (result) {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Query Sent Successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
            txtQuery.text = @"";
        }
        else {
           
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:[[resultObject objectForKey:@"response"] objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
            txtQuery.text = @"";

        }
    }];
}

#pragma mark - TextField Delegate Methods
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - TextView Delegate Methods
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
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

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
