//
//  CartCell.m
//  AbeilleDor
//
//  Created by Admin on 09/03/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import "CartCell.h"

@implementation CartCell
@synthesize viewBackground;
@synthesize imgProduct;
@synthesize viewSeparator;
@synthesize lblProductName;
@synthesize sliderQuantity;
@synthesize lblSliderValue;
@synthesize btnTrash;
@synthesize btnCart;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        viewBackground = [[UIView alloc]init];
        viewBackground.frame = CGRectMake(10, 10, 300, 100);
        viewBackground.backgroundColor = [UIColor whiteColor];
        viewBackground.layer.borderWidth = 1.0;
        viewBackground.layer.borderColor = [UIColor colorWithRed:106.0f/255.0f green:59.0f/255.0f blue:5.0f/255.0f alpha:0.4f].CGColor;

        imgProduct = [[UIImageView alloc]init];
        imgProduct.frame = CGRectMake(20, 20, 80, 80);
        
        viewSeparator = [[UIView alloc]init];
        viewSeparator.frame = CGRectMake(110, 20, 1, 80);
        
        lblProductName = [[UILabel alloc]init];
        lblProductName.backgroundColor = [UIColor clearColor];
        lblProductName.frame = CGRectMake(120, 20, 150, 40);
        lblProductName.textColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0];
        lblProductName.font = [UIFont fontWithName:@"Avenir-Roman" size:15];
        lblProductName.numberOfLines = 0;
        lblProductName.lineBreakMode = NSLineBreakByWordWrapping;
        lblProductName.textAlignment = NSTextAlignmentLeft;
        
        sliderQuantity = [[UISlider alloc]init];
        sliderQuantity.frame = CGRectMake(120, 70, 150, 10);
        sliderQuantity.minimumTrackTintColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0];
        sliderQuantity.maximumTrackTintColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:0.2];
        sliderQuantity.minimumValue = 0.0f;
        sliderQuantity.maximumValue = 10.0f;
        [sliderQuantity setThumbImage:[UIImage imageNamed:@"circle.png"] forState:UIControlStateNormal];
        sliderQuantity.continuous = YES;
        
        lblSliderValue = [[UILabel alloc]init];
        lblSliderValue.frame = CGRectMake(280, 65, 20, 15);
        lblSliderValue.backgroundColor = [UIColor clearColor];
        lblSliderValue.textColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0];
        lblSliderValue.font = [UIFont fontWithName:@"Avenir-Roman" size:14];
        lblSliderValue.textAlignment = NSTextAlignmentCenter;

        btnTrash = [UIButton buttonWithType: UIButtonTypeCustom];
        btnTrash.frame = CGRectMake(280, 20, 20, 20);
        
        btnCart = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCart.frame = CGRectMake(280, 75, 20, 20);
        [btnCart setBackgroundImage:[UIImage imageNamed:@"Cart_brown.png"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:viewBackground];
        [self.contentView addSubview:imgProduct];
        [self.contentView addSubview:viewSeparator];
        [self.contentView addSubview:lblProductName];
        [self.contentView addSubview:btnTrash];
        [self.contentView addSubview:sliderQuantity];
        [self.contentView addSubview:lblSliderValue];
        //[self.contentView addSubview:btnCart];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
