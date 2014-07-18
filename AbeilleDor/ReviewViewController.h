//
//  ReviewViewController.h
//  AbeilleDor
//
//  Created by Roman Khan on 11/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewViewController : UIViewController
{
    IBOutlet UISegmentedControl * segCtl;
    IBOutlet UIView * viewContainer;
    IBOutlet UITableView * tblReminder;
    
    UIView * viewAllReviews;
    UIView * viewWriteReview;
    
    IBOutlet UITextView * txtMessage;
    IBOutlet UITextField * txtName;
    
    IBOutlet UIButton * btnStarOne;
    IBOutlet UIButton * btnStarTwo;
    IBOutlet UIButton * btnStarThree;
    IBOutlet UIButton * btnStarFour;
    IBOutlet UIButton * btnStarFive;
    
    BOOL isStarOne;
    BOOL isStarTwo;
    BOOL isStarThree;
    BOOL isStarFour;
    BOOL isStarFive;
    
    NSString * rating;
    
    NSMutableArray * arrayReviews;
    
    NSMutableArray * arrayReviewName;
    NSMutableArray * arrayReviewMessage;
    NSMutableArray * arrayReviewRating;
}
@property (nonatomic, strong) NSString * strProductId;
@property (nonatomic, strong) NSMutableArray * arrayReviews;

-(IBAction)segmentedControlClicked:(id)sender;
-(IBAction)btnStarOneClicked:(id)sender;
-(IBAction)btnStarTwoClicked:(id)sender;
-(IBAction)btnStarThreeClicked:(id)sender;
-(IBAction)btnStarFourClicked:(id)sender;
-(IBAction)btnStarFiveClicked:(id)sender;
-(IBAction)btnSubmitClicked:(id)sender;

@end
