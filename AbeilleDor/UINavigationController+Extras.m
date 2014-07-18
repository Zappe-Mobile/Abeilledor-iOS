//
//  UINavigationController+Extras.m
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import "UINavigationController+Extras.h"

@implementation UINavigationController (Extras)

-(UILabel *)setTitleView:(NSString *)title
{
    UILabel * lblTitle = [[UILabel alloc]init];
    lblTitle.frame = CGRectMake(0, 0, 40, 25);
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.text = title;
    lblTitle.font = [UIFont fontWithName:@"Avenir-Medium" size:20];
    
    return lblTitle;
    
}

-(UIImage *)setBrownBackgroundImage
{
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor colorWithRed:106.0f/255.0f green:59.0f/255.0f blue:5.0f/255.0f alpha:1.0f] set];
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    
    UIImage *navBarBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return navBarBackgroundImage;
}

-(UIImage *)setRedBackgroundImage
{
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor colorWithRed:170.0f/255.0f green:0.0f/255.0f blue:27.0f/255.0f alpha:1.0] set];
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    
    UIImage *navBarBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return navBarBackgroundImage;
}

@end
