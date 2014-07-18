//
//  HomeViewController.m
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "HomeViewController.h"
#import "ProductsViewController.h"
#import "YakultViewController.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "MedicationReminderViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.titleView = [self.navigationController setTitleView:@"Home"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(btnSelectTableClicked)
                                                 name:@"TABLESELECT"
                                               object:nil];
    
}

-(void)btnSelectTableClicked
{
    UINavigationController * medicationNav = [[UINavigationController alloc] initWithRootViewController:[[MedicationReminderViewController alloc]init]];
    self.sidePanelController.centerPanel = medicationNav;

}

-(void)viewWillAppear:(BOOL)animated
{
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor colorWithRed:106.0f/255.0f green:59.0f/255.0f blue:5.0f/255.0f alpha:1.0f] set];
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    
    UIImage *navBarBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    [self.navigationController.navigationBar setBackgroundImage:navBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;

}

-(IBAction)btnAbeilledorClicked:(id)sender
{
    NSLog(@"Abeilledor");
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"ABEILLE"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    ProductsViewController * objProduct = [[ProductsViewController alloc]init];
    [self.navigationController pushViewController:objProduct animated:YES];
}

-(IBAction)btnYakultClicked:(id)sender
{
    NSLog(@"Yakult");
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"YAKULT"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    YakultViewController * objYakult = [[YakultViewController alloc]init];
    [self.navigationController pushViewController:objYakult animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
