//
//  OrderHistoryViewController.m
//  AbeilleDor
//
//  Created by Roman Khan on 13/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "OrderHistoryViewController.h"
#import "UINavigationController+Extras.h"
#import "RequestManager.h"
#import "DataManager.h"
#import "OrderCell.h"
#import "SVProgressHUD.h"

#define kSectionCount 1
#define kRowHeight 70

@interface OrderHistoryViewController ()

@end

@implementation OrderHistoryViewController

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
    
    self.navigationItem.titleView = [self.navigationController setTitleView:@"Order History"];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];

    
    NSError * error;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription
                             entityForName:@"Order" inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]]];
    [fetchRequest setFetchLimit:1];
    
    
    // Check whether the entity exists or not
    if ([[NSManagedObjectContext MR_defaultContext] countForFetchRequest:fetchRequest error:&error])
        
    {
        //[self populateDataForOrderHistoryFromArray:[DataManager loadAllOrderHistory]];
        [DataManager removeAllOrderFromCoreDataWithDataBlock:^(BOOL success, NSError *error) {
            
            if (success) {
                
                [[RequestManager sharedManager]getOrderListWithEmailId:[[NSUserDefaults standardUserDefaults]objectForKey:@"LOGINEMAIL"] WithCompletionBlock:^(BOOL result, id resultObject) {
                    
                    if (result) {
                        
                        [DataManager storeOrderHistory:[resultObject objectForKey:@"response"] WithDataBlock:^(BOOL success, NSError *error) {
                            
                            if (success) {
                                
                                [self populateDataForOrderHistoryFromArray:[DataManager loadAllOrderHistory]];
                            }
                            else {
                                
                            }
                        }];
                    }
                    else {
                        
                    }
                }];

            }
            else {
                
            }
        }];
        
    }
    else {

    [SVProgressHUD show];
    [[RequestManager sharedManager]getOrderListWithEmailId:[[NSUserDefaults standardUserDefaults]objectForKey:@"LOGINEMAIL"] WithCompletionBlock:^(BOOL result, id resultObject) {
        
        [SVProgressHUD dismiss];
        if (result) {
            
            [DataManager storeOrderHistory:[resultObject objectForKey:@"response"] WithDataBlock:^(BOOL success, NSError *error) {
               
                if (success) {
                    
                    [self populateDataForOrderHistoryFromArray:[DataManager loadAllOrderHistory]];
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

#pragma mark - Navigation Bar Left Button Selector
//! Method invoked when left bar button clicked
- (void)btnLeftBarClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table View Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return kSectionCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrayOrderId count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    OrderCell *cell = (OrderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[OrderCell alloc] initWithStyle:UITableViewCellStyleDefault
                               reuseIdentifier:CellIdentifier] ;
    }
    //for dynamic data
    
    cell.lblOrderId.text = [NSString stringWithFormat:@"Payment Id : %@",[arrayOrderId objectAtIndex:indexPath.row]];
    
    cell.lblDate.text = [arrayDate objectAtIndex:indexPath.row];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)populateDataForOrderHistoryFromArray:(NSArray *)array
{
    arrayOrderId = [[NSMutableArray alloc]init];
    arrayDestinationAddress = [[NSMutableArray alloc]init];
    arrayMoney = [[NSMutableArray alloc]init];
    arrayDate = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<[array count]; i++) {
        
        NSManagedObject * info = [array objectAtIndex:i];
        
        [arrayDate addObject:[info valueForKey:@"date"]];
        [arrayDestinationAddress addObject:[info valueForKey:@"destinationAddress"]];
        [arrayMoney addObject:[info valueForKey:@"money"]];
        [arrayOrderId addObject:[info valueForKey:@"orderid"]];
        
    }
    
    [tblOrder reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
