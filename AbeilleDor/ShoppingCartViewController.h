//
//  ShoppingCartViewController.h
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"

@interface ShoppingCartViewController : UIViewController<PayPalPaymentDelegate,PayPalFuturePaymentDelegate>
{
    IBOutlet UITableView * tblCart;
    IBOutlet UILabel * lblCartSubTotal;
    
    NSMutableArray * arrayImages;
    NSMutableArray * arrayProductName;
    NSMutableArray * arrayRating;
    NSMutableArray * arrayReviews;
    NSMutableArray * arrayProductId;
    NSMutableArray * arrayProductPrice;
    NSMutableArray * arrayProductQuantity;
}
-(IBAction)btnCheckoutClicked:(id)sender;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;

@end
