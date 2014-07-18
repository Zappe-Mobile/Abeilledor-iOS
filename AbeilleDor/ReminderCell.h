//
//  ReminderCell.h
//  AbeilleDor
//
//  Created by Admin on 16/03/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel * lblMessage;
@property (nonatomic, strong) IBOutlet UILabel * lblTime;
@property (nonatomic, strong) IBOutlet UILabel * lblDate;

+(CGFloat)heightForCellWithString:(NSString *)string;
@end
