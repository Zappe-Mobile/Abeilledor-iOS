//
//  WishlistViewController.h
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WishlistViewController : UIViewController
{
    IBOutlet UITableView * tblWishlist;
    
    NSMutableArray * arrayImages;
    NSMutableArray * arrayProductName;
    NSMutableArray * arrayRating;
    NSMutableArray * arrayReviews;
    NSMutableArray * arrayProductId;
    NSMutableArray * arrayProductType;
    NSMutableArray * arrayProductPrice;
    
    UIView * viewQA;
    IBOutlet UITextField * txtEmail;
    IBOutlet UITextView * txtQuery;
    
    NSInteger tagValue;

}
-(IBAction)btnCancelClicked:(id)sender;
-(IBAction)btnSubmitClicked:(id)sender;
@end
