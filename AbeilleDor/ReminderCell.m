//
//  ReminderCell.m
//  AbeilleDor
//
//  Created by Admin on 16/03/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import "ReminderCell.h"

@implementation ReminderCell
@synthesize lblMessage;
@synthesize lblTime;
@synthesize lblDate;

+(CGFloat)heightForCellWithString:(NSString *)string
{
    CGSize maximumSize = CGSizeMake(160, 9999);
    UIFont *myFont = [UIFont fontWithName:@"Avenir-Heavy" size:14];
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
        
        lblMessage = [[UILabel alloc]init];
        lblMessage.frame = CGRectMake(15, 10, 160, 20);
        lblMessage.backgroundColor = [UIColor clearColor];
        lblMessage.textColor = [UIColor whiteColor];
        lblMessage.font = [UIFont fontWithName:@"Avenir-Heavy" size:14];
        lblMessage.textAlignment = NSTextAlignmentLeft;
        lblMessage.numberOfLines = 0;
        lblMessage.lineBreakMode = NSLineBreakByWordWrapping;
        
        lblTime = [[UILabel alloc]init];
        lblTime.frame = CGRectMake(15, 35, 80, 20);
        lblTime.backgroundColor = [UIColor clearColor];
        lblTime.textColor = [UIColor whiteColor];
        lblTime.font = [UIFont fontWithName:@"Avenir-Roman" size:13];
        lblTime.textAlignment = NSTextAlignmentLeft;
        
        lblDate = [[UILabel alloc]init];
        lblDate.frame = CGRectMake(100, 35, 160, 20);
        lblDate.backgroundColor = [UIColor clearColor];
        lblDate.textColor = [UIColor whiteColor];
        lblDate.font = [UIFont fontWithName:@"Avenir-Roman" size:13];
        lblDate.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:lblMessage];
        [self.contentView addSubview:lblTime];
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
