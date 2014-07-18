//
//  WhereToBuyViewController.m
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "WhereToBuyViewController.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "AnnotatingPin.h"
#import "NIDropDown.h"
#import "HomeViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "NSString+HTML.h"
#import "SVProgressHUD.h"

@interface WhereToBuyViewController ()
{
    IBOutlet UILabel * lblStoreName;
}
@end

@implementation WhereToBuyViewController

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
    
    self.navigationItem.titleView = [self.navigationController setTitleView:@"Where To Buy"];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    btnData.layer.borderWidth = 1.0;
    btnData.layer.borderColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0].CGColor;
    btnData.layer.cornerRadius = 5.0;
    
    
    NSError * error;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription
                             entityForName:@"WhereToBuy" inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]]];
    [fetchRequest setFetchLimit:1];
    
    
    // Check whether the entity exists or not
    if ([[NSManagedObjectContext MR_defaultContext] countForFetchRequest:fetchRequest error:&error])
        
    {
        [self loadDataWithArray:[DataManager loadAllDataFromWhereToBuy]];
        
    }
    else {
        
    [SVProgressHUD show];
    [[RequestManager sharedManager]loadWhereToBuyWithLatitude:@"" WithLongitude:@"" WithCompletionBlock:^(BOOL result, id resultObject) {
        
        [SVProgressHUD dismiss];
        if (result) {
            
            NSLog(@"%@",resultObject);
            [DataManager storeWhereToBuyInfo:[resultObject objectForKey:@"response"] WithDataBlock:^(BOOL success, NSError *error) {
                
                if (success) {
                    
                    [self loadDataWithArray:[DataManager loadAllDataFromWhereToBuy]];
                }
                else {
                    
                }
                
            }];
        }
        else {
            
        }
    }];
        
    }
}

#pragma mark - Set Navigation Bar Left Button
//! Set Left Bar Button
- (UIBarButtonItem *)setLeftBarButton
{
    UIButton * btnSettings = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSettings.frame = CGRectMake(0, 0, 25, 25);
    [btnSettings setImage:[UIImage imageNamed:@"Home_New.png"] forState:UIControlStateNormal];
    [btnSettings addTarget:self action:@selector(btnLeftBarClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barBtnItem = [[UIBarButtonItem alloc]initWithCustomView:btnSettings];
    
    return barBtnItem;
}

#pragma mark - Navigation Bar Left Button Selector
//! Method invoked when left bar button clicked
- (void)btnLeftBarClicked
{
    UINavigationController * homeNav = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc]init]];
    self.sidePanelController.centerPanel = homeNav;
}


-(IBAction)segCtlClicked:(id)sender
{
    
}

-(IBAction)btnDataClicked:(id)sender
{
    //NSArray * array = [[NSArray alloc]initWithObjects:@"1 Time Per Day",@"2 Times Per Day",@"3 Times Per Day",@"4 Times Per Day",nil];
    NSArray * arrayImage = [[NSArray alloc]init];
    
    if(dropDown == nil) {
        CGFloat f = 160;
        dropDown = [[NIDropDown alloc]showDropDownFromButton:sender WithHeight:&f WithContentArray:arrayName WithImageArray:arrayImage WithDirection:@"down"];
        dropDown.delegate = self;
        
        
    }
    else
    {
        [dropDown hideDropDown:sender];
        [self rel];
    }

}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender withindex:(int)index
{
    float latitudeOne = [[arrayLatitude objectAtIndex:index] floatValue];
    float longitudeOne = [[arrayLongitude objectAtIndex:index] floatValue];
    
    MKCoordinateSpan span;
    span.latitudeDelta = 2.5;
    span.longitudeDelta = 2.5;
    
    CLLocationCoordinate2D locationOne;
    
    locationOne.latitude = latitudeOne ;
    locationOne.longitude = longitudeOne;
    
    MKCoordinateRegion region;
    region.center.latitude = latitudeOne;
    region.center.longitude = longitudeOne;
    
    region.span = span;
    
    [objMapView setRegion:region animated:TRUE];
    
    lblStoreName.text = [NSString stringWithFormat:@"%@\n%@",[arrayName objectAtIndex:index],[arrayAddress objectAtIndex:index]];


}


-(void)rel
{
    dropDown = nil;
    
}


-(void)loadDataWithArray:(NSArray *)array
{
    arrayName = [[NSMutableArray alloc]init];
    arrayAddress = [[NSMutableArray alloc]init];
    arrayLatitude = [[NSMutableArray alloc]init];
    arrayLongitude = [[NSMutableArray alloc]init];
    arrayIdentifier = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<[array count]; i++) {
        
        NSManagedObject * info = [array objectAtIndex:i];
        
        [arrayName addObject:[info valueForKey:@"storeName"]];
        [arrayAddress addObject:[[info valueForKey:@"storeAddress"]stringByConvertingHTMLToPlainText]];
        [arrayLatitude addObject:[info valueForKey:@"storeLatitude"]];
        [arrayLongitude addObject:[info valueForKey:@"storeLongitude"]];
        [arrayIdentifier addObject:[info valueForKey:@"storeIdentifier"]];
        
    }
    
    [btnData setTitle:[arrayName objectAtIndex:0] forState:UIControlStateNormal];

    
    lblStoreName.text = [NSString stringWithFormat:@"%@%@",[arrayName objectAtIndex:0],[arrayAddress objectAtIndex:0]];
    
    [self setMapView];
}

-(void)setMapView
{
    
    NSLog(@"%@",arrayName);
    NSLog(@"%@",arrayAddress);
    NSLog(@"%@",arrayLatitude);
    NSLog(@"%@",arrayLongitude);
    NSLog(@"%@",arrayIdentifier);
    
    
    for (int k = 0; k<[arrayLatitude count]; k++) {
        
        float latitudeOne = [[arrayLatitude objectAtIndex:k] floatValue];
        float longitudeOne = [[arrayLongitude objectAtIndex:k] floatValue];
        
        MKCoordinateSpan span;
        span.latitudeDelta=44.5;
        span.longitudeDelta=44.5;
        
        CLLocationCoordinate2D locationOne;
        
        locationOne.latitude = latitudeOne ;
        locationOne.longitude = longitudeOne;
        
        MKCoordinateRegion region;
        region.center.latitude = latitudeOne;
        region.center.longitude = longitudeOne;
        
        region.span = span;
        
        
        AnnotatingPin * addAnnotation = [[AnnotatingPin alloc] initWithTitle:[arrayName objectAtIndex:k] subttitle:[arrayAddress objectAtIndex:k] andCoordinate:locationOne tag:@"1"];
        [objMapView addAnnotation:addAnnotation];
        
        [objMapView setRegion:region animated:TRUE];
        
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
