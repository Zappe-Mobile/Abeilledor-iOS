//
//  WishlistViewController.m
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "WishlistViewController.h"
#import "UINavigationController+Extras.h"
#import "DataManager.h"
#import "CartCell.h"
#import "HomeViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "RequestManager.h"
#import "ALToastView.h"
#import "SVProgressHUD.h"

#define kSectionCount 1
#define kRowHeight 110

@interface WishlistViewController ()

@end

@implementation WishlistViewController

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
    
    self.navigationItem.titleView = [self.navigationController setTitleView:@"Wishlist"];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    [self populateDataForWishlistFromArray:[DataManager loadAllProductsFromWishlist]];
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
    return [arrayProductName count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    CartCell *cell = (CartCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[CartCell alloc] initWithStyle:UITableViewCellStyleDefault
                               reuseIdentifier:CellIdentifier] ;
    }
    //for dynamic data
    
    cell.lblProductName.text = [arrayProductName objectAtIndex:indexPath.row];
    cell.sliderQuantity.hidden = YES;
    
    if ([[arrayProductType objectAtIndex:indexPath.row]isEqualToString:@"abeilledor"]) {
        
        UIButton * btnCart = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCart.frame = CGRectMake(276, 71, 24, 24);
        btnCart.tag = indexPath.row;
        [btnCart setBackgroundImage:[UIImage imageNamed:@"Cart_brown.png"] forState:UIControlStateNormal];
        [btnCart addTarget:self action:@selector(btnCartClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnCart];
        
        cell.viewBackground.layer.borderColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0f].CGColor;
        cell.viewSeparator.backgroundColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
        cell.btnTrash.tag = indexPath.row;
        [cell.btnTrash addTarget:self action:@selector(btnTrashClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnTrash setBackgroundImage:[UIImage imageNamed:@"Trash_brown.png"] forState:UIControlStateNormal];
    }
    
    else {
        
        UIButton * btnCart = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCart.frame = CGRectMake(266, 71, 36, 24);
        btnCart.tag = indexPath.row;
        [btnCart setBackgroundColor:[UIColor colorWithRed:170.0f/255.0f green:0.0f/255.0f blue:27.0f/255.0f alpha:1.0f]];
        [btnCart setTitle:@"Q&A" forState:UIControlStateNormal];
        [btnCart.titleLabel setFont:[UIFont fontWithName:@"Avenir-Heavy" size:12]];
        [btnCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnCart.layer.cornerRadius = 5.0;
        [btnCart addTarget:self action:@selector(btnQAClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnCart];

        cell.viewBackground.layer.borderColor = [UIColor colorWithRed:170.0f/255.0f green:0.0f/255.0f blue:27.0f/255.0f alpha:1.0f].CGColor;
        cell.viewSeparator.backgroundColor = [UIColor colorWithRed:170.0f/255.0f green:0.0f/255.0f blue:27.0f/255.0f alpha:1.0f];
        cell.btnTrash.tag = indexPath.row;
        [cell.btnTrash addTarget:self action:@selector(btnTrashClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnTrash setBackgroundImage:[UIImage imageNamed:@"Trash_Darkred.png"] forState:UIControlStateNormal];

    }
    
    
    NSURL * url = [NSURL URLWithString:[arrayImages objectAtIndex:indexPath.row]];
    
    [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            cell.imgProduct.image = image;
        }
        else {
            cell.imgProduct.image = [UIImage imageNamed:@"default_placeholder-image.png"];
        }
    }];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    //    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f blue:255.0/255.0f alpha:0.1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)btnTrashClicked:(UIButton *)sender
{
    [DataManager removeItemFromWishlistWithProductId:[arrayProductId objectAtIndex:sender.tag] WithDataBlock:^(BOOL success, NSError *error) {
        
        if (success) {
            if ([[arrayProductType objectAtIndex:sender.tag]isEqualToString:@"abeilledor"])
            {
                [DataManager updateAndRemoveWishlistProductWithProductId:[arrayProductId objectAtIndex:sender.tag] WithDataBlock:^(BOOL success, NSError *error) {
                    
                    if (success) {
                        [self populateDataForWishlistFromArray:[DataManager loadAllProductsFromWishlist]];
                    }
                    else {
                    }
                }];

            }
            else {
                
                [DataManager updateAndRemoveWishlistYakultWithProductId:[arrayProductId objectAtIndex:sender.tag] WithDataBlock:^(BOOL success, NSError *error) {
                    
                    if (success) {
                        [self populateDataForWishlistFromArray:[DataManager loadAllProductsFromWishlist]];
                    }
                    else {
                        
                    }
                }];
                
            }

           
        }
        else {
            
        }
    }];

}

-(void)btnCartClicked:(UIButton *)sender
{
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[arrayProductId objectAtIndex:sender.tag] forKey:@"productId"];
    [dict setObject:[arrayProductName objectAtIndex:sender.tag] forKey:@"productName"];
    [dict setObject:[arrayImages objectAtIndex:sender.tag] forKey:@"productImage"];
    [dict setObject:[arrayRating objectAtIndex:sender.tag] forKey:@"productRating"];
    [dict setObject:[arrayReviews objectAtIndex:sender.tag] forKey:@"productReviews"];
    [dict setObject:[arrayProductPrice objectAtIndex:sender.tag] forKey:@"productPrice"];
    [dict setObject:@"1" forKey:@"productQuantity"];

    
    NSLog(@"%@",dict);
    
    [ALToastView toastInView:self.view withText:@"Item Added to Cart"];
    
    [DataManager addProductsToCart:dict WithDataBlock:^(BOOL success, NSError *error) {
        
        //! Items Added to Cart
        
        if (success) {
            
            [DataManager updateAddCartProductWithProductId:[arrayProductId objectAtIndex:sender.tag] WithDataBlock:^(BOOL success, NSError *error) {
                
                if (success) {
                    
                    [DataManager removeItemFromWishlistWithProductId:[arrayProductId objectAtIndex:sender.tag] WithDataBlock:^(BOOL success, NSError *error) {
                        
                        if (success) {
                            
                            [self populateDataForWishlistFromArray:[DataManager loadAllProductsFromWishlist]];
                        }
                        else {
                            
                        }
                    }];
                }
                else {
                    
                }
                
            }];
        }
        //! Storage Failure
        else {
          
            [DataManager removeItemFromWishlistWithProductId:[arrayProductId objectAtIndex:sender.tag] WithDataBlock:^(BOOL success, NSError *error) {
                
                if (success) {
                    
                    [self populateDataForWishlistFromArray:[DataManager loadAllProductsFromWishlist]];
                }
                else {
                    
                }
            }];

        }
    }];

}

-(void)btnQAClicked:(UIButton *)sender
{
    tagValue = sender.tag;
    
    viewQA = [self getTemplateView:@"WishlistQA" for:self];
    [viewQA setAlpha:0];
    
    viewQA.layer.cornerRadius = 5.0;
    
    CGRect rect = viewQA.frame;
    rect.origin.x = rect.origin.x;
    rect.origin.y = rect.origin.y;
    [viewQA setFrame:rect];
    
    [self.navigationController.view addSubview:viewQA];
    
    [UIView beginAnimations:nil context:NULL];
    
    [viewQA setUserInteractionEnabled:YES];
    
    [UIView setAnimationDuration:.5];
    
    [viewQA setAlpha:1];
    
    [UIView commitAnimations];
    
    txtEmail.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"LOGINEMAIL"];

}

#pragma mark - Asynchronous Image Download
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

-(void)populateDataForWishlistFromArray:(NSArray *)array
{
    arrayImages = [[NSMutableArray alloc]init];
    arrayProductName = [[NSMutableArray alloc]init];
    arrayRating = [[NSMutableArray alloc]init];
    arrayReviews = [[NSMutableArray alloc]init];
    arrayProductId = [[NSMutableArray alloc]init];
    arrayProductType = [[NSMutableArray alloc]init];
    arrayProductPrice = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<[array count]; i++) {
        
        NSManagedObject * info = [array objectAtIndex:i];
        
        [arrayImages addObject:[info valueForKey:@"productImageUrl"]];
        [arrayProductName addObject:[info valueForKey:@"productName"]];
        [arrayRating addObject:[info valueForKey:@"productRating"]];
        [arrayReviews addObject:[info valueForKey:@"productReviews"]];
        [arrayProductId addObject:[info valueForKey:@"productId"]];
        [arrayProductType addObject:[info valueForKey:@"productType"]];
        [arrayProductPrice addObject:[info valueForKey:@"productPrice"]];
        
    }
    
    NSLog(@"%@",arrayProductType);
    
    [tblWishlist reloadData];
}

-(IBAction)btnCancelClicked:(id)sender
{
    [UIView transitionWithView:viewQA duration:0.6 options:UIViewAnimationOptionTransitionNone animations:^{
        [viewQA setAlpha:0];
    } completion:^(BOOL finished) {
        [viewQA removeFromSuperview];
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    }];

}

-(IBAction)btnSubmitClicked:(id)sender
{
    [SVProgressHUD showWithStatus:@"Loading" maskType:SVProgressHUDMaskTypeBlack];
    [[RequestManager sharedManager]sendQueryWithProductId:[arrayProductId objectAtIndex:tagValue] WithEmailId:txtEmail.text WithQuery:txtQuery.text WithCompletionBlock:^(BOOL result, id resultObject) {
        
        [SVProgressHUD dismiss];
        if (result) {
            txtQuery.text = @"";
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Query Sent Successfully" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:[[resultObject objectForKey:@"response"] objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
            txtQuery.text = @"";

        }
    }];

}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


#pragma mark - View Loading Template Methods
- (UIView *)getTemplateView:(NSString*)template for:(id)s
{
    
    return [self getTemplateView:template for:s atIndex:0];
    
}

- (UIView *)getTemplateView:(NSString*)template for:(id)s atIndex:(int)index
{
    
    BOOL isIpad = ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad);
    
    if(isIpad){
        
        template = [NSString stringWithFormat:@"%@",template];
        
    }else{
        
        template = [NSString stringWithFormat:@"%@",template];
        
    }
    
    NSArray * ViewAry = [[NSBundle mainBundle] loadNibNamed:template owner:s options:nil];
    
    return [ViewAry objectAtIndex:index];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
