//
//  ContactUsViewController.h
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "EAMTextView.h"

@interface ContactUsViewController : UIViewController
{
    IBOutlet MKMapView * objMapView;
    IBOutlet UIScrollView * objScrollView;
    
    IBOutlet UITextField * txtName;
    IBOutlet UITextField * txtEmail;
    IBOutlet EAMTextView * txtMessage;
}
-(IBAction)btnSendClicked:(id)sender;
@end
