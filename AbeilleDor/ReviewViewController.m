//
//  ReviewViewController.m
//  AbeilleDor
//
//  Created by Roman Khan on 11/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "ReviewViewController.h"
#import "RequestManager.h"
#import "UINavigationController+Extras.h"
#import "SVProgressHUD.h"
#import "ReviewCell.h"
#import "HomeViewController.h"
#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"
#import "DataManager.h"
#import "NSString+HTML.h"

#define kSectionCount 1
#define kRowHeight 50

@interface ReviewViewController ()

@end

@implementation ReviewViewController
@synthesize strProductId;
@synthesize arrayReviews;

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
    
    self.navigationItem.titleView = [self.navigationController setTitleView:@"Reviews"];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    self.navigationItem.rightBarButtonItem = [self setRightBarButton];
    
    isStarOne = NO;
    isStarTwo = NO;
    isStarThree = NO;
    isStarFour = NO;
    isStarFive = NO;
    
    arrayReviewName = [[NSMutableArray alloc]init];
    arrayReviewMessage = [[NSMutableArray alloc]init];
    arrayReviewRating = [[NSMutableArray alloc]init];
    
    NSLog(@"%@",strProductId);
    
    rating = @"0";
    
    for (NSDictionary * Dict in arrayReviews) {
        
        if ([Dict objectForKey:@"name"]==[NSNull null] || [[Dict objectForKey:@"name"]length]==0) {
            [arrayReviewName addObject:@"Anonymous"];
        }
        else {
            [arrayReviewName addObject:[[Dict objectForKey:@"name"]stringByConvertingHTMLToPlainText]];
        }
        [arrayReviewMessage addObject:[[Dict objectForKey:@"message"]stringByConvertingHTMLToPlainText]];
        [arrayReviewRating addObject:[Dict objectForKey:@"rating"]];
    }
    
    
    [self loadAllReviews];
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

#pragma mark - Set Navigation Bar Right Button
//! Set Right Bar Button
- (UIBarButtonItem *)setRightBarButton
{
    UIButton * btnSettings = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSettings.frame = CGRectMake(0, 0, 25, 25);
    [btnSettings setImage:[UIImage imageNamed:@"Home_New.png"] forState:UIControlStateNormal];
    [btnSettings addTarget:self action:@selector(btnRightBarClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * barBtnItem = [[UIBarButtonItem alloc]initWithCustomView:btnSettings];
    
    return barBtnItem;
}

#pragma mark - Navigation Bar Left Button Selector
//! Method invoked when left bar button clicked
- (void)btnRightBarClicked
{
    UINavigationController * homeNav = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc]init]];
    self.sidePanelController.centerPanel = homeNav;
}

-(IBAction)segmentedControlClicked:(id)sender
{
    if (segCtl.selectedSegmentIndex == 0) {
        
        [self loadAllReviews];
    }
    else {
        
        [self setReviews];
    }
}

-(void)loadAllReviews
{
    [UIView transitionWithView:viewWriteReview duration:0.6 options:UIViewAnimationOptionTransitionNone animations:^{
        [viewWriteReview setAlpha:0];
    } completion:^(BOOL finished) {
        [viewWriteReview removeFromSuperview];
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    }];
    
    viewAllReviews = [self getTemplateView:@"AllReviews" for:self];
    [viewAllReviews setAlpha:0];
    
    viewAllReviews.layer.cornerRadius = 5.0;
    
    CGRect rect = viewAllReviews.frame;
    rect.origin.x = rect.origin.x;
    rect.origin.y = rect.origin.y;
    [viewAllReviews setFrame:rect];
    
    [viewContainer addSubview:viewAllReviews];
    
    [UIView beginAnimations:nil context:NULL];
    
    [viewAllReviews setUserInteractionEnabled:YES];
    
    [UIView setAnimationDuration:.5];
    
    [viewAllReviews setAlpha:1];
    
    [UIView commitAnimations];
    
    
}

-(void)setReviews
{
    [UIView transitionWithView:viewAllReviews duration:0.6 options:UIViewAnimationOptionTransitionNone animations:^{
        [viewAllReviews setAlpha:0];
    } completion:^(BOOL finished) {
        [viewAllReviews removeFromSuperview];
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    }];
    
    viewWriteReview = [self getTemplateView:@"SetReview" for:self];
    [viewWriteReview setAlpha:0];
    
    viewWriteReview.layer.cornerRadius = 5.0;
    
    CGRect rect = viewWriteReview.frame;
    rect.origin.x = rect.origin.x;
    rect.origin.y = rect.origin.y;
    [viewWriteReview setFrame:rect];
    
    [viewContainer addSubview:viewWriteReview];
    
    [UIView beginAnimations:nil context:NULL];
    
    [viewWriteReview setUserInteractionEnabled:YES];
    
    [UIView setAnimationDuration:.5];
    
    [viewWriteReview setAlpha:1];
    
    [UIView commitAnimations];
    
}

#pragma mark - Table View Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //! Return the number of sections.
    return kSectionCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    //! This will create a "Invisible" footer
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tv viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrayReviewName count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    ReviewCell *cell = (ReviewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[ReviewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier] ;
    }
    
    //For Dynamic Data
    cell.lblMessage.text = [arrayReviewMessage objectAtIndex:indexPath.row];
    cell.lblName.text = [arrayReviewName objectAtIndex:indexPath.row];
    //cell.textLabel.textColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(IBAction)btnStarOneClicked:(id)sender
{
    if (!isStarOne) {
        [btnStarOne setBackgroundImage:[UIImage imageNamed:@"filled_star.png"] forState:UIControlStateNormal];
        isStarOne = YES;
        rating = @"1";
    }
    else {
        [btnStarOne setBackgroundImage:[UIImage imageNamed:@"empty_star.png"] forState:UIControlStateNormal];
        [btnStarTwo setBackgroundImage:[UIImage imageNamed:@"empty_star.png"] forState:UIControlStateNormal];
        [btnStarThree setBackgroundImage:[UIImage imageNamed:@"empty_star.png"] forState:UIControlStateNormal];
        [btnStarFour setBackgroundImage:[UIImage imageNamed:@"empty_star.png"] forState:UIControlStateNormal];
        [btnStarFive setBackgroundImage:[UIImage imageNamed:@"empty_star.png"] forState:UIControlStateNormal];
        isStarOne = NO;

    }
}

-(IBAction)btnStarTwoClicked:(id)sender
{
    if (!isStarTwo) {
        [btnStarOne setBackgroundImage:[UIImage imageNamed:@"filled_star.png"] forState:UIControlStateNormal];
        [btnStarTwo setBackgroundImage:[UIImage imageNamed:@"filled_star.png"] forState:UIControlStateNormal];
        isStarTwo = YES;
        rating = @"2";
    }
    else {
        [btnStarTwo setBackgroundImage:[UIImage imageNamed:@"empty_star.png"] forState:UIControlStateNormal];
        [btnStarThree setBackgroundImage:[UIImage imageNamed:@"empty_star.png"] forState:UIControlStateNormal];
        [btnStarFour setBackgroundImage:[UIImage imageNamed:@"empty_star.png"] forState:UIControlStateNormal];
        [btnStarFive setBackgroundImage:[UIImage imageNamed:@"empty_star.png"] forState:UIControlStateNormal];
        isStarTwo = NO;
    }
}

-(IBAction)btnStarThreeClicked:(id)sender
{
    if (!isStarThree) {
        [btnStarOne setBackgroundImage:[UIImage imageNamed:@"filled_star.png"] forState:UIControlStateNormal];
        [btnStarTwo setBackgroundImage:[UIImage imageNamed:@"filled_star.png"] forState:UIControlStateNormal];
        [btnStarThree setBackgroundImage:[UIImage imageNamed:@"filled_star.png"] forState:UIControlStateNormal];
        isStarThree = YES;
        rating = @"3";
    }
    else {
        [btnStarThree setBackgroundImage:[UIImage imageNamed:@"empty_star.png"] forState:UIControlStateNormal];
        [btnStarFour setBackgroundImage:[UIImage imageNamed:@"empty_star.png"] forState:UIControlStateNormal];
        [btnStarFive setBackgroundImage:[UIImage imageNamed:@"empty_star.png"] forState:UIControlStateNormal];
        isStarThree = NO;
    }
}

-(IBAction)btnStarFourClicked:(id)sender
{
    if (!isStarFour) {
        [btnStarOne setBackgroundImage:[UIImage imageNamed:@"filled_star.png"] forState:UIControlStateNormal];
        [btnStarTwo setBackgroundImage:[UIImage imageNamed:@"filled_star.png"] forState:UIControlStateNormal];
        [btnStarThree setBackgroundImage:[UIImage imageNamed:@"filled_star.png"] forState:UIControlStateNormal];
        [btnStarFour setBackgroundImage:[UIImage imageNamed:@"filled_star.png"] forState:UIControlStateNormal];
        isStarFour = YES;
        rating = @"4";
    }
    else {
        [btnStarFour setBackgroundImage:[UIImage imageNamed:@"empty_star.png"] forState:UIControlStateNormal];
        [btnStarFour setBackgroundImage:[UIImage imageNamed:@"empty_star.png"] forState:UIControlStateNormal];
        isStarFour = NO;
    }
}

-(IBAction)btnStarFiveClicked:(id)sender
{
    if (!isStarFive) {
        [btnStarOne setBackgroundImage:[UIImage imageNamed:@"filled_star.png"] forState:UIControlStateNormal];
        [btnStarTwo setBackgroundImage:[UIImage imageNamed:@"filled_star.png"] forState:UIControlStateNormal];
        [btnStarThree setBackgroundImage:[UIImage imageNamed:@"filled_star.png"] forState:UIControlStateNormal];
        [btnStarFour setBackgroundImage:[UIImage imageNamed:@"filled_star.png"] forState:UIControlStateNormal];
        [btnStarFive setBackgroundImage:[UIImage imageNamed:@"filled_star.png"] forState:UIControlStateNormal];
        isStarFive = YES;
        rating = @"5";
    }
    else {
        [btnStarFive setBackgroundImage:[UIImage imageNamed:@"empty_star.png"] forState:UIControlStateNormal];
        isStarFive = NO;

    }
}

-(IBAction)btnSubmitClicked:(id)sender
{
    
    if ([txtMessage.text length]>0 && [txtName.text length]>0 && [rating length]>0) {
        
        [SVProgressHUD show];
        [[RequestManager sharedManager]rateProductWithProductId:strProductId WithRating:rating WithMessage:txtMessage.text WithName:txtName.text WithCompletionBlock:^(BOOL result, id resultObject) {
            
            if (result) {
                [SVProgressHUD dismiss];
                NSLog(@"%@",resultObject);
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Review Posted Successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                
                [arrayReviewName addObject:txtName.text];
                [arrayReviewMessage addObject:txtMessage.text];
                [arrayReviewRating addObject:rating];
                
                txtMessage.text = @"";
                txtName.text = @"";
                rating = @"0";
                
                [btnStarOne setBackgroundImage:[UIImage imageNamed:@"empty_star.png"] forState:UIControlStateNormal];
                [btnStarTwo setBackgroundImage:[UIImage imageNamed:@"empty_star.png"] forState:UIControlStateNormal];
                [btnStarThree setBackgroundImage:[UIImage imageNamed:@"empty_star.png"] forState:UIControlStateNormal];
                [btnStarFour setBackgroundImage:[UIImage imageNamed:@"empty_star.png"] forState:UIControlStateNormal];
                [btnStarFive setBackgroundImage:[UIImage imageNamed:@"empty_star.png"] forState:UIControlStateNormal];
                
                [DataManager updateProductsListForAddingOfReviewWithProductId:strProductId WithDataBlock:^(BOOL success, NSError *error) {
                    
                    if (success) {
                        
                    }
                    else {
                        
                    }
                }];
                
                [tblReminder reloadData];
                
                
            }
            else {
                [SVProgressHUD dismiss];
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Review Not Submitted.Please try Again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];

            }
        }];

    }
    else {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please fill in all fields" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];

    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    NSInteger restrictedLength=100;
    
    NSString *temp=textView.text;
    
    if([[textView text] length] > restrictedLength){
        textView.text=[temp substringToIndex:[temp length]-1];
    }
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
