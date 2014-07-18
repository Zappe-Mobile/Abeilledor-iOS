//
//  CartCell.h
//  AbeilleDor
//
//  Created by Admin on 09/03/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CartCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView * viewBackground;
@property (nonatomic, strong) IBOutlet UIImageView * imgProduct;
@property (nonatomic, strong) IBOutlet UIView * viewSeparator;
@property (nonatomic, strong) IBOutlet UILabel * lblProductName;
@property (nonatomic, strong) IBOutlet UISlider * sliderQuantity;
@property (nonatomic, strong) IBOutlet UILabel * lblSliderValue;
@property (nonatomic, strong) IBOutlet UIButton * btnTrash;
@property (nonatomic, strong) IBOutlet UIButton * btnCart;
@end
