//
//  MessageViewController.m
//  AbeilleDor
//
//  Created by Admin on 24/03/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import "MessageViewController.h"
#import "UINavigationController+Extras.h"
#import "JASidePanelController.h"
#import "HomeViewController.h"
#import "UIViewController+JASidePanel.h"
#import "DataManager.h"
#import "RequestManager.h"
#import "Message.h"
#import "MessageCell.h"
#import "SVProgressHUD.h"

#define kSectionCount 1
#define kRowHeight 70

@interface MessageViewController ()
{
    IBOutlet UITextView * txtView;
    IBOutlet UITableView * tblView;
    IBOutlet UILabel * lblNoMessage;
    
    NSMutableArray * arrayMessages;
    NSMutableArray * arrayTime;
    
    NSMutableArray * arrayUniqueMessages;
    NSMutableArray * arrayUniqueTime;
    NSMutableArray * arrayMessageId;
    
    //CGFloat height;
}
@end

@implementation MessageViewController

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
    
    self.navigationItem.titleView = [self.navigationController setTitleView:@"Messages"];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    //! Notification for Push Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayPushMessage:)
                                                 name:@"PUSHMESSAGE"
                                               object:nil];
    
    lblNoMessage.hidden = YES;
    
    
    [SVProgressHUD show];
    [[RequestManager sharedManager]getAllLatestMessagesWithEmail:@"" WithCompletionBlock:^(BOOL result, id resultObject) {
       
        [SVProgressHUD dismiss];
        if (result) {
            
            NSLog(@"%@",resultObject);
            if ([resultObject objectForKey:@"response"]!= NULL && ![[resultObject objectForKey:@"response"] isEqual:[NSNull null]]) {
                
                [DataManager StoreMessageData:[resultObject objectForKey:@"response"] WithDataBlock:^(BOOL success, NSError *error) {
                    
                    if (success) {
                        
                        [self setMessages:[DataManager loadAllMessages]];
                    }
                    else {
                        
                    }
                }];

            }
            else {
                lblNoMessage.hidden = NO;
            }
        }
        else {
            
        }
    }];
    
}

- (void)displayPushMessage:(NSNotification *)notification
{
    txtView.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"PUSHMESSAGE"];
    [txtView sizeToFit];
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
    //return kRowHeight;
    
//    CGSize maximumLabelSize = CGSizeMake(180, 999);
//    NSString *str = [arrayMessages objectAtIndex:indexPath.row];
//
//    CGSize expectedLabelSize = [str sizeWithFont:[UIFont fontWithName:@"Avenir-Roman" size:13] constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
//    
//    //adjust the label the the new height.
//    CGRect newFrame = CGRectMake(0, 0, 180, 20);
//    newFrame.size.height = expectedLabelSize.height;
//    
//    return newFrame.size.height+20;
 
    NSLog(@"%f",[MessageCell heightForCellWithString:[arrayMessages objectAtIndex:indexPath.row]]);
    return [MessageCell heightForCellWithString:[arrayMessages objectAtIndex:indexPath.row]]+70;
    
    
    
//    CGFloat height;
    
    
//    NSString *str1 = [arrayMessages objectAtIndex:indexPath.row];
//    
//    UIFont *fontText = [UIFont fontWithName:@"Avenir-Roman" size:13];
//    
//    CGRect size1 = [str1 boundingRectWithSize:CGSizeMake(180, 999) options:(NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:fontText} context:nil];
//    
//    
//    height = size1.size.height;
//    
//    NSLog(@"%f",height);
//    height +=10;
    
//    if (height <= 40) {
//        height = 45;
//    }
    //return height;

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
    return [arrayMessages count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:CellIdentifier] ;
    }
    
    cell.clipsToBounds = YES;
    //for dynamic data
    
//    NSString *str1 = [arrayMessages objectAtIndex:indexPath.row];
//    UIFont *fontText = [UIFont fontWithName:@"Avenir-Roman" size:13];
//    CGRect size1 = [str1 boundingRectWithSize:CGSizeMake(180, 999) options:(NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:fontText} context:nil];
//    
//    [cell.lblOrderId setText:str1];
    cell.lblOrderId.frame = CGRectMake(20, 20, 180, 20+[MessageCell heightForCellWithString:[arrayMessages objectAtIndex:indexPath.row]]);
//    
//    CGFloat height = size1.size.height;
//    CGFloat newHeight = height + 10.0;
//    
    cell.viewBackground.frame = CGRectMake(10, 10, 300, 60+[MessageCell heightForCellWithString:[arrayMessages objectAtIndex:indexPath.row]]);
//
    cell.lblDate.frame = CGRectMake(20, 45+[MessageCell heightForCellWithString:[arrayMessages objectAtIndex:indexPath.row]], 150, 15);
    

    cell.lblOrderId.text = [arrayMessages objectAtIndex:indexPath.row];
    [cell.lblOrderId sizeToFit];
    
    cell.lblDate.text = [arrayTime objectAtIndex:indexPath.row];
    
    cell.btnDelete.tag = indexPath.row;
    [cell.btnDelete addTarget:self action:@selector(removeMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)setMessages:(NSArray *)messageArray
{
    arrayMessages = [[NSMutableArray alloc]init];
    arrayTime = [[NSMutableArray alloc]init];
    arrayMessageId = [[NSMutableArray alloc]init];
    
    for (Message * Object in messageArray) {
        
        if (![arrayMessageId containsObject:Object.messageId]) {
            
            [arrayMessageId addObject:Object.messageId];
            [arrayMessages addObject:Object.message];
            [arrayTime addObject:Object.time];
        }
    }
    
    if ([arrayMessageId containsObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"LASTMESSAGE"]]) {
        
        NSInteger index = [arrayMessageId indexOfObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"LASTMESSAGE"]];
        
        [arrayMessageId removeObjectAtIndex:index];
        [arrayMessages removeObjectAtIndex:index];
        [arrayTime removeObjectAtIndex:index];
    }
    
    if ([arrayMessageId count]==0) {
        lblNoMessage.hidden = NO;
    }
    else {
        lblNoMessage.hidden = YES;
    }
    
    [tblView reloadData];
}

- (void)removeMessage:(UIButton *)sender
{
    [SVProgressHUD show];
    [[RequestManager sharedManager]deleteMessageWithMessageId:[arrayMessageId objectAtIndex:sender.tag] WithCompletionBlock:^(BOOL result, id resultObject) {
        
        [SVProgressHUD dismiss];
        if (result) {
            
            [DataManager removeMessageWithMessageId:[arrayMessageId objectAtIndex:sender.tag] WithDataBlock:^(BOOL success, NSError *error) {
                
                if (success) {
                    
                    [self setMessages:[DataManager loadAllMessages]];
                }
                else {
                    
                }
            }];

        }
        else {
            
        }
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
