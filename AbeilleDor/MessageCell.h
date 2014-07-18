//
//  MessageCell.h
//  AbeilleDor
//
//  Created by rkhan-mbook on 24/05/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView * viewBackground;
@property (nonatomic, strong) IBOutlet UILabel * lblOrderId;
@property (nonatomic, strong) IBOutlet UILabel * lblDate;
@property (nonatomic, strong) IBOutlet UILabel * lblMoney;
@property (nonatomic, strong) IBOutlet UIButton * btnDelete;

+(CGFloat)heightForCellWithString:(NSString *)string;
@end
