//
//  ProductsViewController.m
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "ProductsViewController.h"
#import "ProductDetailViewController.h"
#import "UINavigationController+Extras.h"
#import "ZCollectionContainerView.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "Reachability.h"
#import "SVProgressHUD.h"
#import "HomeViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "UIDevice+Extras.h"
#import "CustomBadge.h"
#import "ShoppingCartViewController.h"
#import "BBBadgeBarButtonItem.h"

@interface ProductsViewController ()
{
    CustomBadge * badge;
    UIButton * btnCart;
    UIBarButtonItem * leftBarBtnItem;
}
@property (strong, nonatomic) ZCollectionContainerView *collectionView;

@end

@implementation ProductsViewController

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
    
    
    self.navigationItem.titleView = [self.navigationController setTitleView:@"Abeille'dOr"];
    
    
    badge = [CustomBadge customBadgeWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"CART"]
                               withStringColor:[UIColor whiteColor]
                                withInsetColor:[UIColor redColor]
                                withBadgeFrame:YES
                           withBadgeFrameColor:[UIColor redColor]
                                     withScale:0.6
                                   withShining:YES];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(badgeCountUpdated:)
                                                 name:@"BADGECOUNT"
                                               object:nil];
    
    [self.navigationController.navigationBar setBackgroundImage:[self.navigationController setBrownBackgroundImage] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
    
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;

    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"ABEILLE"]) {
        
        self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"ABEILLE"];
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


    //[self dataStart];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.rightBarButtonItem = [self setRightBarButton];
    
    [self dataStart];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [badge removeFromSuperview];
}

- (void)badgeCountUpdated:(NSNotification *)notification
{
    BBBadgeBarButtonItem *barButton = (BBBadgeBarButtonItem *)self.navigationItem.rightBarButtonItem;
    barButton.badgeValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"CART"];
}


-(void)dataStart
{
    NSError * error;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription
                             entityForName:@"Product" inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]]];
    [fetchRequest setFetchLimit:1];
    
    
    // Check whether the entity exists or not
    if ([[NSManagedObjectContext MR_defaultContext] countForFetchRequest:fetchRequest error:&error])
        
    {
        [self loadDataWithArray:[DataManager loadAllProductsFromCoreData]];
        
    }
    else {
        
        if ([[Reachability reachabilityForInternetConnection]isReachable]) {
            //! Internet Available
            
            [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
            [[RequestManager sharedManager]loadAllAbeilleDorProductsWithCompletionBlock:^(BOOL result, id resultObject) {
                
                if (result) {
                    
                    [DataManager storeAllProducts:[resultObject objectForKey:@"response"] WithDataBlock:^(BOOL success, NSError *error) {
                        
                        if (success) {
                            [SVProgressHUD dismiss];
                            [self loadDataWithArray:[DataManager loadAllProductsFromCoreData]];
                        }
                        else {
                            
                        }
                        
                    }];
                }
                else {
                    
                    [SVProgressHUD dismiss];
                }
            }];

        }
        else {
           //! No Internet Avaialble
        }
        

    }

}

#pragma mark - Set Navigation Bar Color
//! Set Navigation Bar Color
-(void)setNavigationBarColor
{
    
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

- (void)btnAlternateLeftBarClicked
{
    UINavigationController * homeNav = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc]init]];
    self.sidePanelController.centerPanel = homeNav;

}

#pragma mark - Set Navigation Bar Right Button
//! Set Right Bar Button
- (UIBarButtonItem *)setRightBarButton
{
    btnCart = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCart.frame = CGRectMake(0, 0, 25, 25);
    [btnCart setImage:[UIImage imageNamed:@"cart_badge.png"] forState:UIControlStateNormal];
    [btnCart addTarget:self action:@selector(btnRightBarClicked) forControlEvents:UIControlEventTouchUpInside];
    
    BBBadgeBarButtonItem *barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:btnCart];
    // Set a value for the badge
    barButton.badgeValue = [[NSUserDefaults standardUserDefaults]objectForKey:@"CART"];
    
    barButton.badgeOriginX = 13;
    barButton.badgeOriginY = -9;
    
    return barButton;
}


#pragma mark - Navigation Bar Left Button Selector
//! Method invoked when left bar button clicked
- (void)btnRightBarClicked
{
    UINavigationController * homeNav = [[UINavigationController alloc] initWithRootViewController:[[ShoppingCartViewController alloc]init]];
    self.sidePanelController.centerPanel = homeNav;
}


-(void)loadDataWithArray:(NSArray *)array {
    
    arrayImages = [[NSMutableArray alloc]init];
    arrayProductName = [[NSMutableArray alloc]init];
    arrayRating = [[NSMutableArray alloc]init];
    arrayReviews = [[NSMutableArray alloc]init];
    arrayProductId = [[NSMutableArray alloc]init];
    arrayProductsCart = [[NSMutableArray alloc]init];
    arrayProductsWishlist = [[NSMutableArray alloc]init];
    arrayProductPrice = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<[array count]; i++) {
        
        NSManagedObject * info = [array objectAtIndex:i];
        
        [arrayImages addObject:[info valueForKey:@"productImageUrl"]];
        [arrayProductName addObject:[info valueForKey:@"productName"]];
        [arrayRating addObject:[info valueForKey:@"productRating"]];
        [arrayReviews addObject:[info valueForKey:@"productReviews"]];
        [arrayProductId addObject:[info valueForKey:@"productId"]];
        [arrayProductsCart addObject:[info valueForKey:@"isCart"]];
        [arrayProductsWishlist addObject:[info valueForKey:@"isWishlist"]];
        [arrayProductPrice addObject:[info valueForKey:@"productPrice"]];
    }
    
    _collectionView = [[NSBundle mainBundle] loadNibNamed:@"ZCollectionContainerView" owner:self options:nil][0];
    _collectionView.frame = CGRectMake(10, 10, 300, 544);
    [self.view addSubview:_collectionView];
        
    [_collectionView setCollectionDataWithProductId:arrayProductId WithProductName:arrayProductName WithProductImage:arrayImages WithProductRating:arrayRating WithProductReviews:arrayReviews WithCart:arrayProductsCart WithWishlist:arrayProductsWishlist WithProductPrice:arrayProductPrice WithTitle:@"Abeille d'Or"];

}

#pragma mark - News Item Selection in Collection View
- (void) didSelectItemFromCollectionView:(NSNotification *)notification
{
    NSArray * arrayTags = [notification object];
    
    NSInteger rowTag = [[arrayTags objectAtIndex:0]intValue]; // which row is pressed
    
    NSLog(@"%ld",(long)rowTag);
    
    NSInteger articleTag = [[arrayTags objectAtIndex:1]intValue];// which article is pressed in a particular row
    
    NSLog(@"%ld",(long)articleTag);

    ProductDetailViewController * objDetail = [[ProductDetailViewController alloc]init];
    objDetail.strProductId = [arrayProductId objectAtIndex:articleTag];
    [self.navigationController pushViewController:objDetail animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
