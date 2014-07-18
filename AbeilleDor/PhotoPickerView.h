//
//  PhotoPickerView.h
//  AbeilleDor
//
//  Created by rkhan-mbook on 27/06/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAccountViewController.h"

@interface PhotoPickerView : UIView

@property id<PhotoPickerProtocol> delegate;
@end
