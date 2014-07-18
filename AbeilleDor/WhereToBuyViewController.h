//
//  WhereToBuyViewController.h
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NIDropDown.h"

@interface WhereToBuyViewController : UIViewController<NIDropDownDelegate>
{
    IBOutlet MKMapView * objMapView;
    IBOutlet UISegmentedControl * segCtl;
    IBOutlet UIButton * btnData;
    
    NSMutableArray * arrayLatitude;
    NSMutableArray * arrayLongitude;
    NSMutableArray * arrayName;
    NSMutableArray * arrayAddress;
    NSMutableArray * arrayIdentifier;
    
    NIDropDown *dropDown;
}
-(IBAction)segCtlClicked:(id)sender;
-(IBAction)btnDataClicked:(id)sender;
@end
