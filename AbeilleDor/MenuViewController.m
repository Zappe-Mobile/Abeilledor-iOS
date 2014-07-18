//
//  MenuViewController.m
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "MenuViewController.h"
#import "HomeViewController.h"
#import "AboutUsViewController.h"
#import "ProductsViewController.h"
#import "YakultViewController.h"
#import "PromotionViewController.h"
#import "ShoppingCartViewController.h"
#import "WishlistViewController.h"
#import "WhereToBuyViewController.h"
#import "MedicationReminderViewController.h"
#import "ContactUsViewController.h"
#import "TermsConditionsViewController.h"
#import "PrivacyPolicyViewController.h"
#import "MyAccountViewController.h"
#import "MessageViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "AppDelegate.h"
#import "UIDevice+Extras.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

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
    
    arrayMenu = [[NSMutableArray alloc]initWithObjects:@"Home", @"About Us", @"Products - Abeille d'Or", @"Products - Yakult",
                 @"Promotion/Event", @"Shopping Cart", @"Wishlist", @"Where To Buy", @"Medication Reminder",
                 @"Contact Us",@"Messages",@"My Account", @"Terms & Conditions", @"Privacy Policies",  @"Sign Out", nil];
    

    
}

#pragma mark - Table View Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrayMenu count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:117.0f/255.0f green:86.0f/255.0f blue:51.0f/255.0f alpha:1.0];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    if ([[UIDevice currentDevice]IS_OS_6]) {
        cell.textLabel.text= [NSString stringWithFormat:@"\n \n \n \n \n \n \n \n %@",[arrayMenu objectAtIndex:indexPath.row]];
    }
    else {
        cell.textLabel.text= [arrayMenu objectAtIndex:indexPath.row];
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir-Roman" size:14];
    
    //cell.imageView.image = [UIImage imageNamed:[arrayMenuImages objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            //! Home Screen
            UINavigationController * homeNav = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc]init]];
            self.sidePanelController.centerPanel = homeNav;
        }
            break;
            
        case 1:
        {
            //! About Us Screen
            UINavigationController * aboutNav = [[UINavigationController alloc] initWithRootViewController:[[AboutUsViewController alloc]init]];
            self.sidePanelController.centerPanel = aboutNav;
        }
            break;
        case 2:
        {
            //! Products Screen - Abeille d'Or
            UINavigationController * productNav = [[UINavigationController alloc] initWithRootViewController:[[ProductsViewController alloc]init]];
            self.sidePanelController.centerPanel = productNav;
        }
            break;
        case 3:
        {
            //! Products Screen - Yakult
            UINavigationController * productNav = [[UINavigationController alloc] initWithRootViewController:[[YakultViewController alloc]init]];
            self.sidePanelController.centerPanel = productNav;
        }
            break;
        case 4:
        {
            //! Promotion/Events Screen
            UINavigationController * promotionNav = [[UINavigationController alloc] initWithRootViewController:[[PromotionViewController alloc]init]];
            self.sidePanelController.centerPanel = promotionNav;
        }
            break;
        case 5:
        {
            //! Shopping Cart Screen
            UINavigationController * shoppingNav = [[UINavigationController alloc] initWithRootViewController:[[ShoppingCartViewController alloc]init]];
            self.sidePanelController.centerPanel = shoppingNav;
        }
            break;
        case 6:
        {
            //! Wishlist Screen
            UINavigationController * wishlistNav = [[UINavigationController alloc] initWithRootViewController:[[WishlistViewController alloc]init]];
            self.sidePanelController.centerPanel = wishlistNav;
            
        }
            break;
        case 7:
        {
            //! Where To Buy Screen
            UINavigationController * wheretobuyNav = [[UINavigationController alloc] initWithRootViewController:[[WhereToBuyViewController alloc]init]];
            self.sidePanelController.centerPanel = wheretobuyNav;
            
        }
            break;
        case 8:
        {
            //! Medication Reminder Screen
            UINavigationController * medicationNav = [[UINavigationController alloc] initWithRootViewController:[[MedicationReminderViewController alloc]init]];
            self.sidePanelController.centerPanel = medicationNav;

        }
            break;
        case 9:
        {
            //! Contact Us Screen
            UINavigationController * contactusNav = [[UINavigationController alloc] initWithRootViewController:[[ContactUsViewController alloc]init]];
            self.sidePanelController.centerPanel = contactusNav;

        }
            break;
        case 10:
        {
            //! Messages Screen
            UINavigationController * messagesNav = [[UINavigationController alloc] initWithRootViewController:[[MessageViewController alloc]init]];
            self.sidePanelController.centerPanel = messagesNav;

        }
            break;
        case 11:
        {
            //! My Account Screen
            UINavigationController * accountNav = [[UINavigationController alloc] initWithRootViewController:[[MyAccountViewController alloc]init]];
            self.sidePanelController.centerPanel = accountNav;


        }
            break;
        case 12:
        {
            //! Terms & Conditions Screen
            UINavigationController * termsNav = [[UINavigationController alloc] initWithRootViewController:[[TermsConditionsViewController alloc]init]];
            self.sidePanelController.centerPanel = termsNav;


        }
            break;
        case 13:
        {
            //! Privacy Policies Screen
            UINavigationController * privacyNav = [[UINavigationController alloc] initWithRootViewController:[[PrivacyPolicyViewController alloc]init]];
            self.sidePanelController.centerPanel = privacyNav;

        }
            break;
        case 14:
        {
            //! Sign Out
            [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"OAUTH"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] cleanAndResetupDB];
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] setController:NO];

        }
            break;
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
