//
//  HomeViewController.h
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
{
    IBOutlet UIButton * btnAbeilledor;
    IBOutlet UIButton * btnYakult;
}
-(IBAction)btnAbeilledorClicked:(id)sender;
-(IBAction)btnYakultClicked:(id)sender;
@end
