//
//  OrderHistoryViewController.h
//  AbeilleDor
//
//  Created by Roman Khan on 13/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHistoryViewController : UIViewController
{
    NSMutableArray * arrayOrderId;
    NSMutableArray * arrayDate;
    NSMutableArray * arrayMoney;
    NSMutableArray * arrayDestinationAddress;
    
    IBOutlet UITableView * tblOrder;
}

@end
