//
//  ProductDetailViewController.h
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Product;
@interface ProductDetailViewController : UIViewController
{
    IBOutlet UIScrollView * objScrollView;
    IBOutlet UIImageView * imgProduct;
    IBOutlet UILabel * lblProductName;
    IBOutlet UILabel * lblProductPrice;
    IBOutlet UITextView * txtProductDesc;
    IBOutlet UIButton * btnReview;
    
    IBOutlet UIImageView * imgStarOne;
    IBOutlet UIImageView * imgStarTwo;
    IBOutlet UIImageView * imgStarThree;
    IBOutlet UIImageView * imgStarFour;
    IBOutlet UIImageView * imgStarFive;
    
    IBOutlet UIButton * btnAddToCart;
    IBOutlet UIButton * btnAddToWishlist;
    
    Product * objProduct;
}
@property (nonatomic, strong) NSString * strProductId;
-(IBAction)btnReviewClicked:(id)sender;

-(IBAction)btnAddToCartClicked:(id)sender;
-(IBAction)btnAddToWishlistClicked:(id)sender;
@end
