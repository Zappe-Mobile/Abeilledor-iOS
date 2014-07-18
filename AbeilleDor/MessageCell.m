//
//  MessageCell.m
//  AbeilleDor
//
//  Created by rkhan-mbook on 24/05/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell
@synthesize viewBackground;
@synthesize lblOrderId;
@synthesize lblDate;
@synthesize lblMoney;
@synthesize btnDelete;

+(CGFloat)heightForCellWithString:(NSString *)string
{
    
    CGSize maximumSize = CGSizeMake(180, 9999);
    UIFont *myFont = [UIFont fontWithName:@"Avenir-Roman" size:13];
    CGSize myStringSize = [string sizeWithFont:myFont
                               constrainedToSize:maximumSize
                                   lineBreakMode:NSLineBreakByWordWrapping];
    
    NSLog(@"%f",myStringSize.height);
    return myStringSize.height;
}

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
        lblOrderId.frame = CGRectMake(20, 20, 180, 20);
        lblOrderId.backgroundColor = [UIColor clearColor];
        lblOrderId.textColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
        lblOrderId.textAlignment = NSTextAlignmentLeft;
        lblOrderId.numberOfLines = 0;
        lblOrderId.lineBreakMode = NSLineBreakByWordWrapping;
        lblOrderId.font = [UIFont fontWithName:@"Avenir-Roman" size:13];
        
        lblDate = [[UILabel alloc]init];
        lblDate.frame = CGRectMake(20, 45, 150, 15);
        lblDate.backgroundColor = [UIColor clearColor];
        lblDate.textColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
        lblDate.textAlignment = NSTextAlignmentLeft;
        lblDate.font = [UIFont fontWithName:@"Avenir-Roman" size:13];
        
        btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDelete.frame = CGRectMake(220, 20, 80, 25);
        btnDelete.backgroundColor = [UIColor colorWithRed:106.0f/255.0f green:59.0f/255.0f blue:5.0f/255.0f alpha:1.0f];
        [btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
        [btnDelete.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:13]];
        
        [self.contentView addSubview:viewBackground];
        [self.contentView addSubview:lblOrderId];
        [self.contentView addSubview:lblDate];
        [self.contentView addSubview:btnDelete];
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
