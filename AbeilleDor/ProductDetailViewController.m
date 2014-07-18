//
//  ProductDetailViewController.m
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "UINavigationController+Extras.h"
#import "DataManager.h"
#import "Product.h"
#import "NSString+HTML.h"
#import "ReviewViewController.h"
#import "RequestManager.h"
#import "ALToastView.h"
#import "SVProgressHUD.h"
#import "HomeViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController
@synthesize strProductId;

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
    
    self.navigationItem.titleView = [self.navigationController setTitleView:@"Product Detail"];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    self.navigationItem.rightBarButtonItem = [self setRightBarButton];
    
    imgStarOne.hidden = YES;
    imgStarTwo.hidden = YES;
    imgStarThree.hidden = YES;
    imgStarFour.hidden = YES;
    imgStarFive.hidden = YES;
    
    objScrollView.contentSize = CGSizeMake(320, 450);
    
    NSLog(@"%@",strProductId);
    
    NSArray * object = [DataManager loadProductDetailForProductId:strProductId];
    
    NSLog(@"%@",object);
    
    objProduct = [object objectAtIndex:0];
    
    NSLog(@"%@",objProduct.isCart);
    
    if ([objProduct.isCart isEqualToString:@"1"]) {
        [btnAddToCart setTitle:@"Added To Cart" forState:UIControlStateNormal];
        btnAddToCart.userInteractionEnabled = NO;
    }
    else {
        [btnAddToCart setTitle:@"Add To Cart" forState:UIControlStateNormal];
        btnAddToCart.userInteractionEnabled = YES;
    }
    
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
    
    NSLog(@"%@",objProduct.productRating);
    
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

-(void)viewWillAppear:(BOOL)animated
{
    
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


#pragma mark - Set Navigation Bar Right Button
//! Set Right Bar Button
- (UIBarButtonItem *)setRightBarButton
{
    UIButton * btnSettings = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSettings.frame = CGRectMake(0, 0, 25, 25);
    [btnSettings setImage:[UIImage imageNamed:@"Home_New.png"] forState:UIControlStateNormal];
    [btnSettings addTarget:self action:@selector(btnRightBarClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barBtnItem = [[UIBarButtonItem alloc]initWithCustomView:btnSettings];
    
    return barBtnItem;
}

#pragma mark - Navigation Bar Left Button Selector
//! Method invoked when left bar button clicked
- (void)btnRightBarClicked
{
    UINavigationController * homeNav = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc]init]];
    self.sidePanelController.centerPanel = homeNav;
}


-(IBAction)btnReviewClicked:(id)sender
{
    [SVProgressHUD show];
    [[RequestManager sharedManager]loadAllReviewsWithProductId:strProductId WithCompletionBlock:^(BOOL result, id resultObject) {
        
        if (result) {
            [SVProgressHUD dismiss];
            NSLog(@"%@",resultObject);
            if ([[resultObject objectForKey:@"status"]isEqualToString:@"failure"]) {
                
                ReviewViewController * objReview = [[ReviewViewController alloc]init];
                objReview.strProductId = strProductId;
//                objReview.arrayReviews = [resultObject objectForKey:@"response"];
                [self.navigationController pushViewController:objReview animated:YES];

            }
            else {
                ReviewViewController * objReview = [[ReviewViewController alloc]init];
                objReview.strProductId = strProductId;
                objReview.arrayReviews = [resultObject objectForKey:@"response"];
                [self.navigationController pushViewController:objReview animated:YES];
            }

        }
        else {
            [SVProgressHUD dismiss];
            ReviewViewController * objReview = [[ReviewViewController alloc]init];
            objReview.strProductId = strProductId;
            [self.navigationController pushViewController:objReview animated:YES];

        }
    }];
    
    
//    ReviewViewController * objReview = [[ReviewViewController alloc]init];
//    objReview.strProductId = strProductId;
//    [self.navigationController pushViewController:objReview animated:YES];
//
}

-(IBAction)btnAddToCartClicked:(id)sender
{
    
    if ([objProduct.isCart isEqualToString:@"0"]) {
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict setObject:objProduct.productId forKey:@"productId"];
        [dict setObject:objProduct.productName forKey:@"productName"];
        [dict setObject:objProduct.productImageUrl forKey:@"productImage"];
        [dict setObject:objProduct.productRating forKey:@"productRating"];
        [dict setObject:objProduct.productReviews forKey:@"productReviews"];
        [dict setObject:objProduct.productPrice forKey:@"productPrice"];
        [dict setObject:@"1" forKey:@"productQuantity"];
        
        NSString * str = [[NSUserDefaults standardUserDefaults]objectForKey:@"CART"];
        int x = [str intValue];
        x = x+1;
        str = [NSString stringWithFormat:@"%d",x];
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:str forKey:@"CART"];
        [defaults synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BADGECOUNT" object:str];
        
        
        [ALToastView toastInView:self.view withText:@"Item Added to Cart"];
        
        [DataManager addProductsToCart:dict WithDataBlock:^(BOOL success, NSError *error) {
            
            //! Items Added to Cart
            if (success) {
                
                [btnAddToCart setTitle:@"Added To Cart" forState:UIControlStateNormal];
                btnAddToCart.userInteractionEnabled = NO;
                [DataManager updateAddCartProductWithProductId:objProduct.productId WithDataBlock:^(BOOL success, NSError *error) {
                    
                    //! Entity Product Updated
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

}



-(IBAction)btnAddToWishlistClicked:(id)sender
{
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setObject:strProductId forKey:@"productId"];
    [dict setObject:lblProductName.text forKey:@"productName"];
    [dict setObject:objProduct.productImageUrl forKey:@"productImage"];
    [dict setObject:objProduct.productRating forKey:@"productRating"];
    [dict setObject:objProduct.productReviews forKey:@"productReviews"];
    [dict setObject:objProduct.productPrice forKey:@"productPrice"];
    [dict setObject:@"abeilledor" forKey:@"productType"];
    
    [ALToastView toastInView:self.view withText:@"Item Added to Wishlist"];
    
    [DataManager addProductsToWishlist:dict WithDataBlock:^(BOOL success, NSError *error) {
        
        //! Items Added to Wishlist
        if (success) {
            
            [btnAddToWishlist setTitle:@"Added To Wishlist" forState:UIControlStateNormal];
            btnAddToWishlist.userInteractionEnabled = NO;
            [DataManager updateAddWishlistProductWithProductId:strProductId WithDataBlock:^(BOOL success, NSError *error) {
                
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
