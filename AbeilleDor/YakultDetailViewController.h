//
//  YakultDetailViewController.h
//  AbeilleDor
//
//  Created by Roman Khan on 06/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class Yakult;
@interface YakultDetailViewController : UIViewController<UITextViewDelegate>
{
    UIView * viewQA;
    
    IBOutlet UIScrollView * objScrollView;
    IBOutlet UIImageView * imgProduct;
    IBOutlet UILabel * lblProductName;
    IBOutlet UILabel * lblProductPrice;
    IBOutlet UITextView * txtProductDesc;
    IBOutlet UIButton * btnReview;
    IBOutlet UIButton * btnQA;
    
    IBOutlet UITextField * txtEmail;
    IBOutlet UITextView * txtQuery;
    
    IBOutlet UIImageView * imgStarOne;
    IBOutlet UIImageView * imgStarTwo;
    IBOutlet UIImageView * imgStarThree;
    IBOutlet UIImageView * imgStarFour;
    IBOutlet UIImageView * imgStarFive;
    
    IBOutlet UIButton * btnAddToWishlist;
    
    Yakult * objProduct;

}
@property (nonatomic, strong) NSString * strProductId;
-(IBAction)btnReviewClicked:(id)sender;
-(IBAction)btnQAClicked:(id)sender;
-(IBAction)btnAddToWishlistClicked:(id)sender;
-(IBAction)btnCancelClicked:(id)sender;
-(IBAction)btnSubmitClicked:(id)sender;

@end
