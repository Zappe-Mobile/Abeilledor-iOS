//
//  OrderCell.h
//  AbeilleDor
//
//  Created by Admin on 20/03/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView * viewBackground;
@property (nonatomic, strong) IBOutlet UILabel * lblOrderId;
@property (nonatomic, strong) IBOutlet UILabel * lblDate;
@property (nonatomic, strong) IBOutlet UILabel * lblMoney;
@end
