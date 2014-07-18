//
//  YakultViewController.m
//  AbeilleDor
//
//  Created by Roman Khan on 06/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "YakultViewController.h"
#import "YakultDetailViewController.h"
#import "UINavigationController+Extras.h"
#import "ZCollectionContainerView.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "SVProgressHUD.h"
#import "HomeViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

@interface YakultViewController ()

@property (strong, nonatomic) ZCollectionContainerView *collectionView;

@end

@implementation YakultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.titleView = [self.navigationController setTitleView:@"Yakult"];
    
    
    [self.navigationController.navigationBar setBackgroundImage:[self.navigationController setRedBackgroundImage] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;

    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"YAKULT"]) {
        self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"YAKULT"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else {
        self.navigationItem.leftBarButtonItem = [self setAlternateLeftBarButton];
    }
    
    //! Add observer that will allow the nested collection cell to trigger the view controller select row at index path
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didSelectItemFromCollectionView:)
                                                 name:@"CollectionViewSelection"
                                               object:nil];

    
    [self dataStart];

}

#pragma mark - Webservice Request
-(void)dataStart
{
    NSError * error;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription
                             entityForName:@"Yakult" inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]]];
    [fetchRequest setFetchLimit:1];
    
    
    // Check whether the entity exists or not
    if ([[NSManagedObjectContext MR_defaultContext] countForFetchRequest:fetchRequest error:&error])
        
    {
        [self loadDataWithArray:[DataManager loadAllYakultProductsFromCoreData]];
        
    }
    else {
        
        [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
        [[RequestManager sharedManager]loadAllYakultProductsWithCompletionBlock:^(BOOL result, id resultObject) {
            
            if (result) {
                
                [DataManager storeAllYakultProducts:[resultObject objectForKey:@"response"] WithDataBlock:^(BOOL success, NSError *error) {
                    
                    if (success) {
                        [SVProgressHUD dismiss];
                        [self loadDataWithArray:[DataManager loadAllYakultProductsFromCoreData]];
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
    btnSettings.frame = CGRectMake(0, 0, 20, 20);
    [btnSettings setImage:[UIImage imageNamed:@"navbar_btn_back@2x.png"] forState:UIControlStateNormal];
    [btnSettings addTarget:self action:@selector(btnLeftBarClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barBtnItem = [[UIBarButtonItem alloc]initWithCustomView:btnSettings];
    
    return barBtnItem;
}

#pragma mark - Set Alternate Navigation Bar Left Button
//! Set Alternate Left Bar Button
- (UIBarButtonItem *)setAlternateLeftBarButton
{
    UIButton * btnSettings = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSettings.frame = CGRectMake(0, 0, 25, 25);
    [btnSettings setImage:[UIImage imageNamed:@"Home_New.png"] forState:UIControlStateNormal];
    [btnSettings addTarget:self action:@selector(btnAlternateLeftBarClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barBtnItem = [[UIBarButtonItem alloc]initWithCustomView:btnSettings];
    
    return barBtnItem;
    
}

#pragma mark - Navigation Bar Left Button Selector
//! Method invoked when left bar button clicked
- (void)btnLeftBarClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation Bar Alternate Left Button Selector
//! Method invoked when alternate left bar button clicked
- (void)btnAlternateLeftBarClicked
{
    UINavigationController * homeNav = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc]init]];
    self.sidePanelController.centerPanel = homeNav;
    
}

#pragma mark - Load Data into Collection
-(void)loadDataWithArray:(NSArray *)array {
    
    arrayImages = [[NSMutableArray alloc]init];
    arrayProductName = [[NSMutableArray alloc]init];
    arrayRating = [[NSMutableArray alloc]init];
    arrayReviews = [[NSMutableArray alloc]init];
    arrayProductId = [[NSMutableArray alloc]init];
    arrayProductCart = [[NSMutableArray alloc]init];
    arrayProductWishlist = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<[array count]; i++) {
        
        NSManagedObject * info = [array objectAtIndex:i];
        
        [arrayImages addObject:[info valueForKey:@"productImageUrl"]];
        [arrayProductName addObject:[info valueForKey:@"productName"]];
        [arrayRating addObject:[info valueForKey:@"productRating"]];
        [arrayReviews addObject:[info valueForKey:@"productReviews"]];
        [arrayProductId addObject:[info valueForKey:@"productId"]];
        [arrayProductWishlist addObject:[info valueForKey:@"isWishlist"]];
        [arrayProductCart addObject:@""];
        
    }
    
    _collectionView = [[NSBundle mainBundle] loadNibNamed:@"ZCollectionContainerView" owner:self options:nil][0];
    _collectionView.frame = CGRectMake(10, 10, 300, 544);
    [self.view addSubview:_collectionView];
    
    [_collectionView setCollectionDataWithProductId:arrayProductId WithProductName:arrayProductName WithProductImage:arrayImages WithProductRating:arrayRating WithProductReviews:arrayReviews WithCart:arrayProductCart WithWishlist:arrayProductWishlist WithProductPrice:arrayProductCart WithTitle:@"Yakult"];
    
}


#pragma mark - News Item Selection in Collection View
- (void) didSelectItemFromCollectionView:(NSNotification *)notification
{
    NSArray * arrayTags = [notification object];
    
    //NSInteger rowTag = [[arrayTags objectAtIndex:0]intValue]; // which row is pressed
    
    NSInteger articleTag = [[arrayTags objectAtIndex:1]intValue];// which article is pressed in a particular row
    
    YakultDetailViewController * objDetail = [[YakultDetailViewController alloc]init];
    objDetail.strProductId = [arrayProductId objectAtIndex:articleTag];
    [self.navigationController pushViewController:objDetail animated:YES];
    
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
