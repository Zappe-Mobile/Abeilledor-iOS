//
//  CartButton.m
//  AbeilleDor
//
//  Created by Admin on 28/04/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import "CartButton.h"
#import "CustomBadge.h"

@implementation CartButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.frame = CGRectMake(0, 0, 25, 25);
        self.backgroundColor = [UIColor whiteColor];
        self = [CartButton buttonWithType:UIButtonTypeRoundedRect];
        [self addSubview:[CustomBadge customBadgeWithString:@"1"]];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
