//
//  PhotoPickerView.m
//  AbeilleDor
//
//  Created by rkhan-mbook on 27/06/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import "PhotoPickerView.h"
#import "MyAccountViewController.h"

@interface PhotoPickerView ()
{
    
}
@end

@implementation PhotoPickerView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)cameraButtonClicked:(id)sender
{
    [(MyAccountViewController *)delegate selectPickerOption:@"1"];
}

- (IBAction)galleryButtonClicked:(id)sender
{
    [(MyAccountViewController *)delegate selectPickerOption:@"2"];
}

- (IBAction)closeButtonClicked:(id)sender
{
    [(MyAccountViewController *)delegate selectPickerOption:@"3"];
}
@end
