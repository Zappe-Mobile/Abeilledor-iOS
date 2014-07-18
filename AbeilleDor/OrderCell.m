//
//  OrderCell.m
//  AbeilleDor
//
//  Created by Admin on 20/03/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell
@synthesize viewBackground;
@synthesize lblOrderId;
@synthesize lblDate;
@synthesize lblMoney;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        viewBackground = [[UIView alloc]init];
        viewBackground.frame = CGRectMake(10, 10, 300, 60);
        viewBackground.backgroundColor = [UIColor whiteColor];
        viewBackground.layer.borderWidth = 1.0;
        viewBackground.layer.borderColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0f].CGColor;

        lblOrderId = [[UILabel alloc]init];
        lblOrderId.frame = CGRectMake(20, 20, 280, 20);
        lblOrderId.backgroundColor = [UIColor clearColor];
        lblOrderId.textColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
        lblOrderId.textAlignment = NSTextAlignmentLeft;
        lblOrderId.font = [UIFont fontWithName:@"Avenir-Roman" size:13];
        
        lblDate = [[UILabel alloc]init];
        lblDate.frame = CGRectMake(20, 45, 150, 15);
        lblDate.backgroundColor = [UIColor clearColor];
        lblDate.textColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
        lblDate.textAlignment = NSTextAlignmentLeft;
        lblDate.font = [UIFont fontWithName:@"Avenir-Roman" size:13];
        
        [self.contentView addSubview:viewBackground];
        [self.contentView addSubview:lblOrderId];
        [self.contentView addSubview:lblDate];
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
