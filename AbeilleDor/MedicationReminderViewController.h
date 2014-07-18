//
//  MedicationReminderViewController.h
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NIDropDown.h"

@interface MedicationReminderViewController : UIViewController<NIDropDownDelegate>
{
    IBOutlet UISegmentedControl * segCtl;
    IBOutlet UIView * viewContainer;
    IBOutlet UITableView * tblReminder;
    IBOutlet UIScrollView * objScrollView;
    
    UIView * viewGetReminder;
    UIView * viewSetReminder;
    
    NSInteger indexSelected;
    
    IBOutlet UIView *disableViewOverlay;
    IBOutlet UIDatePicker *pickerView;
    IBOutlet UIView *viewPickerContainer;
    IBOutlet UIBarButtonItem *btnDone,*btnClose;
    
    NIDropDown *dropDown;
    
    NSMutableArray * arrayReminders;
    
    IBOutlet UIButton * btnStartDate;
    IBOutlet UIButton * btnEndDate;
    IBOutlet UIButton * btnSave;
    
    UIButton * btnFirst;
    UIButton * btnSecond;
    UIButton * btnThird;
    UIButton * btnFourth;
    
    UITextField * txtFirst;
    UITextField * txtSecond;
    UITextField * txtThird;
    UITextField * txtFourth;
    
    UITextView * txtViewFirst;
    UITextView * txtViewSecond;
    UITextView * txtViewThird;
    UITextView * txtViewFourth;
    
    UIView * viewFirstReminder;
    UIView * viewSecondReminder;
    UIView * viewThirdReminder;
    UIView * viewFourthReminder;
    
    BOOL isFirstSelected;
    BOOL isSecondSelected;
    BOOL isThirdSelected;
    BOOL isFourthSelected;
    
    NSDate * dateFirstSelected;
    NSDate * dateSecondSelected;
    NSDate * dateThirdSelected;
    NSDate * dateFourthSelected;
    
    NSMutableArray * arrayReminderStartDate;
    NSMutableArray * arrayReminderEndDate;
    NSMutableArray * arrayReminderMessage;
    NSMutableArray * arrayReminderTime;
    
    NSDate * startDate;
    NSDate * endDate;
    NSDate * nextDate;
}
-(IBAction)segmentedControlClicked:(id)sender;

-(IBAction)btnStartDateClicked:(id)sender;
-(IBAction)btnEndDateClicked:(id)sender;
-(IBAction)btnFrequencyClicked:(id)sender;
-(IBAction)btnSaveClicked:(id)sender;

-(void)navigate;
-(IBAction)action:(UIBarButtonItem *)sender;
-(void)hidePickerViewAnimated:(bool)k;

@end
