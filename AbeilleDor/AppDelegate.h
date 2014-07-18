//
//  AppDelegate.h
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <GooglePlus/GooglePlus.h>

@class JASidePanelController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,GPPDeepLinkDelegate>
{
    BOOL Value;
    AVAudioPlayer * player;
}
-(void)setController:(BOOL)value;
- (void)cleanAndResetupDB;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) JASidePanelController *viewController;
@property (strong, nonatomic) NSMutableData * responseData;
@end
