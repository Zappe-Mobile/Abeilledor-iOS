//
//  ReviewCell.m
//  AbeilleDor
//
//  Created by Admin on 16/03/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import "ReviewCell.h"

@implementation ReviewCell
@synthesize lblName;
@synthesize lblMessage;
@synthesize imgStarOne;
@synthesize imgStarTwo;
@synthesize imgStarThree;
@synthesize imgStarFour;
@synthesize imgStarFive;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        lblMessage = [[UILabel alloc]init];
        lblMessage.frame = CGRectMake(15, 5, 220, 20);
        lblMessage.backgroundColor = [UIColor clearColor];
        lblMessage.textColor = [UIColor whiteColor];
        lblMessage.font = [UIFont fontWithName:@"Avenir-Heavy" size:14];
        lblMessage.textAlignment = NSTextAlignmentLeft;
        
        lblName = [[UILabel alloc]init];
        lblName.frame = CGRectMake(15, 30, 150, 15);
        lblName.backgroundColor = [UIColor clearColor];
        lblName.textColor = [UIColor whiteColor];
        lblName.font = [UIFont fontWithName:@"Avenir-Roman" size:13];
        lblName.textAlignment = NSTextAlignmentLeft;
        
        imgStarOne = [[UIImageView alloc]init];
        imgStarOne.frame = CGRectMake(170, 30, 12, 12);
        imgStarOne.backgroundColor = [UIColor clearColor];
        
        imgStarTwo = [[UIImageView alloc]init];
        imgStarTwo.frame = CGRectMake(186, 30, 12, 12);
        imgStarTwo.backgroundColor = [UIColor clearColor];
        
        imgStarThree = [[UIImageView alloc]init];
        imgStarThree.frame = CGRectMake(202, 30, 12, 12);
        imgStarThree.backgroundColor = [UIColor clearColor];
        
        imgStarFour = [[UIImageView alloc]init];
        imgStarFour.frame = CGRectMake(218, 30, 12, 12);
        imgStarFour.backgroundColor = [UIColor clearColor];
        
        imgStarFive = [[UIImageView alloc]init];
        imgStarFive.frame = CGRectMake(234, 30, 12, 12);
        imgStarFive.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:lblMessage];
        [self.contentView addSubview:lblName];
        [self.contentView addSubview:imgStarOne];
        [self.contentView addSubview:imgStarTwo];
        [self.contentView addSubview:imgStarThree];
        [self.contentView addSubview:imgStarFour];
        [self.contentView addSubview:imgStarFive];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
