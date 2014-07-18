//
//  ReviewCell.h
//  AbeilleDor
//
//  Created by Admin on 16/03/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel * lblMessage;
@property (nonatomic, strong) IBOutlet UILabel * lblName;
@property (nonatomic, strong) IBOutlet UIImageView * imgStarOne;
@property (nonatomic, strong) IBOutlet UIImageView * imgStarTwo;
@property (nonatomic, strong) IBOutlet UIImageView * imgStarThree;
@property (nonatomic, strong) IBOutlet UIImageView * imgStarFour;
@property (nonatomic, strong) IBOutlet UIImageView * imgStarFive;

@end
