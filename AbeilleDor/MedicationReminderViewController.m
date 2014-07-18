//
//  MedicationReminderViewController.m
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "MedicationReminderViewController.h"
#import "UINavigationController+Extras.h"
#import "NIDropDown.h"
#import "MKLocalNotificationsScheduler.h"
#import "HomeViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "DataManager.h"
#import "ReminderCell.h"
#import "JRNLocalNotificationCenter.h"

#define kSectionCount 1
#define kRowHeight 60

@interface MedicationReminderViewController ()

@end

@implementation MedicationReminderViewController

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
    
    self.navigationItem.titleView = [self.navigationController setTitleView:@"Medication Reminder"];
    self.navigationItem.leftBarButtonItem = [self setLeftBarButton];
    
    [viewPickerContainer setHidden:YES];
    [disableViewOverlay setHidden:YES];
    
    isFirstSelected = NO;
    isSecondSelected = NO;
    isThirdSelected = NO;
    isFourthSelected = NO;

    arrayReminders = [[NSMutableArray alloc]init];
    
    [self fetchAllReminders:[DataManager loadAllDataFromMedicationReminders]];
    
    [self loadAllReminders];
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
    NSLog(@"%f",[ReminderCell heightForCellWithString:[arrayReminderMessage objectAtIndex:indexPath.row]]);
    return [ReminderCell heightForCellWithString:[arrayReminderMessage objectAtIndex:indexPath.row]]+60;
    
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
    return [arrayReminderMessage count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor clearColor];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    ReminderCell *cell = (ReminderCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[ReminderCell alloc] initWithStyle:UITableViewCellStyleDefault
                               reuseIdentifier:CellIdentifier] ;
    }
    
    //for dynamic data
    cell.lblMessage.text = [arrayReminderMessage objectAtIndex:indexPath.row];
    cell.lblMessage.frame = CGRectMake(15, 10, 160, 20+[ReminderCell heightForCellWithString:[arrayReminderMessage objectAtIndex:indexPath.row]]);
    [cell.lblMessage sizeToFit];
    
    cell.lblTime.text = [arrayReminderTime objectAtIndex:indexPath.row];
    cell.lblTime.frame = CGRectMake(15, 35+[ReminderCell heightForCellWithString:[arrayReminderMessage objectAtIndex:indexPath.row]], 80, 20);
    
    cell.lblDate.text = [NSString stringWithFormat:@"%@ - %@",[arrayReminderStartDate objectAtIndex:indexPath.row],[arrayReminderEndDate objectAtIndex:indexPath.row]];
    cell.lblDate.frame = CGRectMake(100, 35+[ReminderCell heightForCellWithString:[arrayReminderMessage objectAtIndex:indexPath.row]], 160, 20);
    
    UIButton * btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDelete.frame = CGRectMake(200, 10, 60, 20);
    btnDelete.backgroundColor = [UIColor whiteColor];
    btnDelete.tag = indexPath.row;
    [btnDelete setTitle:@"Delete" forState:UIControlStateNormal];
    [btnDelete setTitleColor:[UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [btnDelete.titleLabel setFont:[UIFont fontWithName:@"Avenir-Heavy" size:12]];
    [btnDelete addTarget:self action:@selector(btnDeleteClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btnDelete];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)btnDeleteClicked:(UIButton *)sender
{
    [DataManager removeItemFromRemindersWithMessage:[arrayReminderMessage objectAtIndex:sender.tag] WithStartDate:[arrayReminderStartDate objectAtIndex:sender.tag] WithEndDate:[arrayReminderEndDate objectAtIndex:sender.tag] WithTime:[arrayReminderTime objectAtIndex:sender.tag] WithDataBlock:^(BOOL success, NSError *error) {
        
        if (success) {
            
            [self fetchAllReminders:[DataManager loadAllDataFromMedicationReminders]];
        }
        else {
            
        }
        
    }];
    
//    NSString * strMessage = [arrayReminderMessage objectAtIndex:sender.tag];
//    NSString * strTime = [arrayReminderTime objectAtIndex:sender.tag];
    NSString * strStartDate = [arrayReminderStartDate objectAtIndex:sender.tag];
    NSString * strEndDate = [arrayReminderEndDate objectAtIndex:sender.tag];
    
    NSLog(@"%@",strStartDate);
    
    NSArray * arrayStart = [strStartDate componentsSeparatedByString:@"-"];
    
    NSString * strStartDay = [arrayStart objectAtIndex:0];
    NSString * strStartMonth = [arrayStart objectAtIndex:1];
    NSString * strStartYear = [arrayStart objectAtIndex:2];
    
    
    NSArray * arrayEnd = [strEndDate componentsSeparatedByString:@"-"];
    
    NSString * strEndDay = [arrayEnd objectAtIndex:0];
    NSString * strEndMonth = [arrayEnd objectAtIndex:1];
    NSString * strEndyear = [arrayEnd objectAtIndex:2];
    
    int startDayInt = [strStartDay intValue];
    int startMonthInt = [strStartMonth intValue];
    int startYearInt = [strStartYear intValue];
    
    int endDayInt = [strEndDay intValue];
    int endMonthInt = [strEndMonth intValue];
    int endYearInt = [strEndyear intValue];
    
    
    if (startMonthInt == endMonthInt) {
        //Month is same
        
        for (int x = startDayInt; startDayInt<=endDayInt; startDayInt++) {
            
            NSString * str = [NSString stringWithFormat:@"%d-%d-%d",x,startMonthInt,startYearInt];
            [[JRNLocalNotificationCenter defaultCenter]cancelLocalNotificationForKey:str];
        }
        
    }
    else if (startMonthInt != endMonthInt && startYearInt == endYearInt) {
        //Month is Different & Year Same
        
        
        
    }
    else if (startMonthInt != endMonthInt && startYearInt != endYearInt) {
        //start month & start year are both different
        
        
    }

    
//    int startInteger = [strStartDate intValue];
//    int endInteger = [strEndDate intValue];
//    
//    for (int x = startInteger; startInteger<=endInteger; startInteger++) {
//        
//        NSString * str = [NSString stringWithFormat:@"%d-"]
//    }
    
}

-(IBAction)action:(UIBarButtonItem *)sender
{
    
    if([sender tag] == 1){
        
        NSDate *myDate = pickerView.date;
        NSLog(@"%@",myDate);
        
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* compoNents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit|NSCalendarCalendarUnit|NSTimeZoneCalendarUnit fromDate:myDate]; // Get necessary date components
        
        
        NSInteger month = [compoNents month]; //gives you month
        NSInteger day = [compoNents day]; //gives you day
        NSInteger year = [compoNents year]; // gives you year
        
        NSInteger hour = [compoNents hour];
        NSInteger minute = [compoNents minute];
        //NSInteger second = [compoNents second];
        
        
        NSString * strMonth = [NSString stringWithFormat:@"%ld",(long)month];
        NSString * strDay = [NSString stringWithFormat:@"%ld",(long)day];
        NSString * strYear = [NSString stringWithFormat:@"%ld",(long)year];
        
        NSString * strHour = [NSString stringWithFormat:@"%ld",(long)hour];
        NSString * strMinute = [NSString stringWithFormat:@"%ld",(long)minute];
        
        NSString * strDate = [NSString stringWithFormat:@"%@-%@-%@",strDay,strMonth,strYear];
        NSString * strTime = [NSString stringWithFormat:@"%@:%@",strHour,strMinute];
        
        if (indexSelected == 1) {
            startDate = pickerView.date;
            [btnStartDate setTitle:strDate forState:UIControlStateNormal];
        }
        else if (indexSelected == 2) {
            endDate = pickerView.date;
            [btnEndDate setTitle:strDate forState:UIControlStateNormal];
        }
        else if (indexSelected == 3) {
            
            dateFirstSelected = pickerView.date;
            NSLog(@"%@",strDate);
            [btnFirst setTitle:strTime forState:UIControlStateNormal];
        }
        else if (indexSelected == 4) {
            
            dateSecondSelected = pickerView.date;
            [btnSecond setTitle:strTime forState:UIControlStateNormal];
        }
        else if (indexSelected == 5) {
            
            dateThirdSelected = pickerView.date;
            [btnThird setTitle:strTime forState:UIControlStateNormal];
        }
        else {
            
            dateFourthSelected = pickerView.date;
            [btnFourth setTitle:strTime forState:UIControlStateNormal];
        }
        
        
        
        [self hidePickerViewAnimated:YES];
        
    }else {
        [self hidePickerViewAnimated:YES];
    }
}

-(void)navigate
{
    [viewPickerContainer setHidden:NO];
    [disableViewOverlay setHidden:NO];
    [self hidePickerViewAnimated:NO];
}

-(void)hidePickerViewAnimated:(bool)k
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        // for iphone
        if (k) {
            
            CGRect frame = CGRectMake(0, 0, 320, 479);
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1];
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:viewPickerContainer cache:YES];
            frame.origin.y += 768;
            viewPickerContainer.frame = frame;
            [UIView commitAnimations];
            
        } else {
            [self.view addSubview:viewPickerContainer];
            CGRect frame = CGRectMake(0, 768, 320, 479);
            [viewPickerContainer setFrame:frame];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1];
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:viewPickerContainer cache:YES];
            frame.origin.y -= 680;
            viewPickerContainer.frame = frame;
            [UIView commitAnimations];
            
        }
        
        
    } else {
        
        //for ipad
        if (k) {
            
            CGPoint frame = viewPickerContainer.center;
            
            
            [UIView beginAnimations:nil context:nil];
            //            [UIView setAnimationDuration:0.5];
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:viewPickerContainer cache:YES];
            
            [viewPickerContainer setAlpha:0];
            if (index == 1) {
                [UIView setAnimationDuration:0.5];
                frame.y += 44;
            }
            else {
                [UIView setAnimationDuration:1.5];
                frame.y -= 308;
            }
            [viewPickerContainer setCenter:frame];
            
            [UIView commitAnimations];
            
        } else {
            
            
            CGPoint frame = viewPickerContainer.center;
            
            [viewPickerContainer setCenter:frame];
            
            [self.view addSubview:viewPickerContainer];
            [viewPickerContainer setAlpha:0];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:viewPickerContainer cache:YES];
            
            [viewPickerContainer setAlpha:1];
            if (index == 1) {
                [UIView setAnimationDuration:0.5];
                frame.y -= 44;
            }
            else {
                [UIView setAnimationDuration:1.5];
                frame.y += 308;
            }
            
            [viewPickerContainer setCenter:frame];
            
            [UIView commitAnimations];
        }
        
    }
    
    
    if (!k) {
        
        
        [self.view insertSubview:disableViewOverlay belowSubview:viewPickerContainer];
        disableViewOverlay.alpha = 0;
        
        [UIView transitionWithView:disableViewOverlay duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
            disableViewOverlay.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
        
        
        
        
    } else {
        
        
        [UIView transitionWithView:disableViewOverlay duration:1 options:UIViewAnimationOptionTransitionNone animations:^{
            disableViewOverlay.alpha = 0.1;
        } completion:^(BOOL finished) {
            
            [viewPickerContainer removeFromSuperview];
            [disableViewOverlay removeFromSuperview];
            
        }];
        
    }
    
    
}


-(IBAction)segmentedControlClicked:(id)sender
{
    if (segCtl.selectedSegmentIndex == 0) {
        
        [self loadAllReminders];
    }
    else {
        
        [self loadSetReminder];
    }
}

-(void)loadAllReminders
{
    [UIView transitionWithView:viewSetReminder duration:0.6 options:UIViewAnimationOptionTransitionNone animations:^{
        [viewSetReminder setAlpha:0];
    } completion:^(BOOL finished) {
        [viewSetReminder removeFromSuperview];
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    }];

    viewGetReminder = [self getTemplateView:@"GetReminders" for:self];
    [viewGetReminder setAlpha:0];
    
    viewGetReminder.layer.cornerRadius = 5.0;
    
    CGRect rect = viewGetReminder.frame;
    rect.origin.x = rect.origin.x;
    rect.origin.y = rect.origin.y;
    [viewGetReminder setFrame:rect];
    
    [viewContainer addSubview:viewGetReminder];
    
    [UIView beginAnimations:nil context:NULL];
    
    [viewGetReminder setUserInteractionEnabled:YES];
    
    [UIView setAnimationDuration:.5];
    
    [viewGetReminder setAlpha:1];
    
    [UIView commitAnimations];
    
    [self fetchAllReminders:[DataManager loadAllDataFromMedicationReminders]];
}

-(void)loadSetReminder
{
    [UIView transitionWithView:viewGetReminder duration:0.6 options:UIViewAnimationOptionTransitionNone animations:^{
        [viewGetReminder setAlpha:0];
    } completion:^(BOOL finished) {
        [viewGetReminder removeFromSuperview];
        [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    }];

    viewSetReminder = [self getTemplateView:@"SetReminders" for:self];
    [viewSetReminder setAlpha:0];
    
    viewSetReminder.layer.cornerRadius = 5.0;
    
    CGRect rect = viewSetReminder.frame;
    rect.origin.x = rect.origin.x;
    rect.origin.y = rect.origin.y;
    [viewSetReminder setFrame:rect];
    
    [viewContainer addSubview:viewSetReminder];
    
    [UIView beginAnimations:nil context:NULL];
    
    [viewSetReminder setUserInteractionEnabled:YES];
    
    [UIView setAnimationDuration:.5];
    
    [viewSetReminder setAlpha:1];
    
    [UIView commitAnimations];

}

#pragma mark - Set Reminder Methods
-(IBAction)btnStartDateClicked:(id)sender
{
    pickerView.datePickerMode = UIDatePickerModeDate;
    [pickerView setMinimumDate: [NSDate date]];
    indexSelected = 1;
    [self navigate];
}

-(IBAction)btnEndDateClicked:(id)sender
{
    pickerView.datePickerMode = UIDatePickerModeDate;
    [pickerView setMinimumDate: [NSDate date]];
    indexSelected = 2;
    [self navigate];
}

-(IBAction)btnFrequencyClicked:(id)sender
{
    NSArray * array = [[NSArray alloc]initWithObjects:@"1 Time Per Day",@"2 Times Per Day",@"3 Times Per Day",@"4 Times Per Day",nil];
    NSArray * arrayImage = [[NSArray alloc]init];
    
    if(dropDown == nil) {
        CGFloat f = 160;
        dropDown = [[NIDropDown alloc]showDropDownFromButton:sender WithHeight:&f WithContentArray:array WithImageArray:arrayImage WithDirection:@"down"];
        dropDown.delegate = self;
        
        
    }
    else
    {
        [dropDown hideDropDown:sender];
        [self rel];
    }

}

-(IBAction)btnSaveClicked:(id)sender
{
    if (isFirstSelected) {
        
        NSString *string = btnFirst.titleLabel.text;
        NSLog(@"%@",string);
        
        NSArray * array = [string componentsSeparatedByString:@":"];
        
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:startDate];
        [components setHour:[[array objectAtIndex:0]intValue]];
        [components setMinute:[[array objectAtIndex:1]intValue]];
        NSDate *date = [calendar dateFromComponents:components];
        
        
        NSCalendar *calendar1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components1 = [calendar1 components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:endDate];
        [components1 setHour:[[array objectAtIndex:0]intValue]];
        [components1 setMinute:[[array objectAtIndex:1]intValue]];
        NSDate *date1 = [calendar1 dateFromComponents:components1];

        
        NSLog(@"%@",date);
        
        NSLog(@"%ld",(long)components.year);
        NSLog(@"%ld",(long)components.month);
        NSLog(@"%ld",(long)components.day);
        

        for (nextDate = date ; [nextDate compare:date1] < 0 ; nextDate = [nextDate dateByAddingTimeInterval:24*60*60] ) {
            // use date
            
            NSLog(@"%@",nextDate);
        
            NSDateComponents *components2 = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:nextDate];

            
            //[[MKLocalNotificationsScheduler sharedInstance]scheduleNotificationOn:date text:txtFirst.text action:@"View" sound:nil launchImage:nil andInfo:nil];
            
            NSString * str = [NSString stringWithFormat:@"%ld-%ld-%ld %@:%@",(long)components2.day,(long)components2.month,(long)components2.year,[array objectAtIndex:0],[array objectAtIndex:1]];
            
        NSLog(@"%@",str);
            
            NSDictionary * dict = [[NSDictionary alloc]initWithObjectsAndKeys:txtViewFirst.text,@"TEXT",nil];
        
        [[JRNLocalNotificationCenter defaultCenter]postNotificationOn:nextDate forKey:str alertBody:txtViewFirst.text userInfo:dict];

        }
        
        [DataManager storeMedicationRemindersWithStartDate:btnStartDate.titleLabel.text WithEndDate:btnEndDate.titleLabel.text WithMessage:txtViewFirst.text WithTime:btnFirst.titleLabel.text WithDataBlock:^(BOOL success, NSError *error) {
            
            if (success) {
                
            }
            else {
                
            }
        }];
        
        isFirstSelected = NO;
    }
    
    if (isSecondSelected) {
        
        NSString *string = btnSecond.titleLabel.text;
        NSLog(@"%@",string);
        
        NSArray * array = [string componentsSeparatedByString:@":"];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:startDate];
        [components setHour:[[array objectAtIndex:0]intValue]];
        [components setMinute:[[array objectAtIndex:1]intValue]];
        
        NSDate *date = [calendar dateFromComponents:components];
        
        NSCalendar *calendar1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components1 = [calendar1 components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:endDate];
        [components1 setHour:[[array objectAtIndex:0]intValue]];
        [components1 setMinute:[[array objectAtIndex:1]intValue]];
        
        NSDate *date1 = [calendar1 dateFromComponents:components1];
        
        
        NSLog(@"%@",date);

        for ( nextDate = date ; [nextDate compare:date1] < 0 ; nextDate = [nextDate dateByAddingTimeInterval:24*60*60] ) {
            // use date
            NSLog(@"Reminder Set");
            NSLog(@"%@",nextDate);
        
            //[[MKLocalNotificationsScheduler sharedInstance]scheduleNotificationOn:date text:txtSecond.text action:@"View" sound:nil launchImage:nil andInfo:nil];
            
            NSDictionary * dict = [[NSDictionary alloc]initWithObjectsAndKeys:txtViewFirst.text,@"TEXT",nil];

            [[JRNLocalNotificationCenter defaultCenter]postNotificationOn:nextDate forKey:@"" alertBody:txtViewSecond.text userInfo:dict];

            
        }
        
        [DataManager storeMedicationRemindersWithStartDate:btnStartDate.titleLabel.text WithEndDate:btnEndDate.titleLabel.text WithMessage:txtViewSecond.text WithTime:btnSecond.titleLabel.text WithDataBlock:^(BOOL success, NSError *error) {
            
            if (success) {
                
            }
            else {
                
            }
        }];

        isSecondSelected = NO;

    }
    if (isThirdSelected) {
        
        NSString *string = btnThird.titleLabel.text;
        NSLog(@"%@",string);
        
        NSArray * array = [string componentsSeparatedByString:@":"];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:startDate];
        [components setHour:[[array objectAtIndex:0]intValue]];
        [components setMinute:[[array objectAtIndex:1]intValue]];
        
        NSDate *date = [calendar dateFromComponents:components];
        
        NSCalendar *calendar1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components1 = [calendar1 components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:endDate];
        [components1 setHour:[[array objectAtIndex:0]intValue]];
        [components1 setMinute:[[array objectAtIndex:1]intValue]];
        
        NSDate *date1 = [calendar1 dateFromComponents:components1];
        
        
        NSLog(@"%@",date);


        for ( nextDate = date ; [nextDate compare:date1] < 0 ; nextDate = [nextDate dateByAddingTimeInterval:24*60*60] ) {
            // use date
            NSLog(@"Reminder Set");
            NSLog(@"%@",nextDate);
        
            //[[MKLocalNotificationsScheduler sharedInstance]scheduleNotificationOn:date text:txtThird.text action:@"View" sound:nil launchImage:nil andInfo:nil];
            
            NSDictionary * dict = [[NSDictionary alloc]initWithObjectsAndKeys:txtViewFirst.text,@"TEXT",nil];

        [[JRNLocalNotificationCenter defaultCenter]postNotificationOn:nextDate forKey:@"" alertBody:txtViewThird.text userInfo:dict];

        
        }
        
        [DataManager storeMedicationRemindersWithStartDate:btnStartDate.titleLabel.text WithEndDate:btnEndDate.titleLabel.text WithMessage:txtViewThird.text WithTime:btnThird.titleLabel.text WithDataBlock:^(BOOL success, NSError *error) {
            
            if (success) {
                
            }
            else {
                
            }
        }];

        isThirdSelected = NO;

    }
    if (isFourthSelected) {

        NSString *string = btnFourth.titleLabel.text;
        NSLog(@"%@",string);
        
        NSArray * array = [string componentsSeparatedByString:@":"];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:startDate];
        [components setHour:[[array objectAtIndex:0]intValue]];
        [components setMinute:[[array objectAtIndex:1]intValue]];
        
        NSDate *date = [calendar dateFromComponents:components];
        
        NSCalendar *calendar1 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components1 = [calendar1 components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:endDate];
        [components1 setHour:[[array objectAtIndex:0]intValue]];
        [components1 setMinute:[[array objectAtIndex:1]intValue]];
        
        NSDate *date1 = [calendar1 dateFromComponents:components1];
        
        
        NSLog(@"%@",date);

        for ( nextDate = date ; [nextDate compare:date1] < 0 ; nextDate = [nextDate dateByAddingTimeInterval:24*60*60] ) {
            // use date
            NSLog(@"Reminder Set");
            NSLog(@"%@",nextDate);
        
            //[[MKLocalNotificationsScheduler sharedInstance]scheduleNotificationOn:date text:txtFourth.text action:@"View" sound:nil launchImage:nil andInfo:nil];
            
            NSDictionary * dict = [[NSDictionary alloc]initWithObjectsAndKeys:txtViewFirst.text,@"TEXT",nil];

        [[JRNLocalNotificationCenter defaultCenter]postNotificationOn:nextDate forKey:@"" alertBody:txtViewFourth.text userInfo:dict];

        
        }
        
        [DataManager storeMedicationRemindersWithStartDate:btnStartDate.titleLabel.text WithEndDate:btnEndDate.titleLabel.text WithMessage:txtViewFourth.text WithTime:btnFourth.titleLabel.text WithDataBlock:^(BOOL success, NSError *error) {
            
            if (success) {
                
            }
            else {
                
            }
        }];

        isFourthSelected = NO;

    }
    [viewSetReminder removeFromSuperview];
    [self loadSetReminder];
}

- (void)didReceiveLocalNotificationUserInfo:(NSDictionary *)userInfo
{
    
}


- (void) niDropDownDelegateMethod: (NIDropDown *) sender withindex:(int)index
{
    NSLog(@"%d",index);
    if (index == 0) {
        
        [self createFirstView];
    }
    else if (index == 1) {
        
        [self createSecondView];
    }
    else if (index == 2) {
        
        [self createThirdView];
    }
    else {
        
        [self createFourthView];
    }
    
}


-(void)rel
{
    dropDown = nil;
    
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

-(void)createFirstView
{
    [self removeAllViews];
    
    isFirstSelected = YES;
    
    viewFirstReminder = [[UIView alloc]init];
    viewFirstReminder.frame = CGRectMake(20, 166, 240, 150);
    viewFirstReminder.backgroundColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    [objScrollView addSubview:viewFirstReminder];
    
    btnFirst = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFirst.frame = CGRectMake(30, 176, 220, 35);
    [btnFirst setBackgroundImage:[UIImage imageNamed:@"dropdown_1x.png"] forState:UIControlStateNormal];
    [btnFirst addTarget:self action:@selector(btnFirstClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnFirst setTitleColor:[UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [btnFirst setTitle:@"Select Time" forState:UIControlStateNormal];
    [btnFirst.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:14]];
    [btnFirst setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [btnFirst setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [objScrollView addSubview:btnFirst];
    
//    txtFirst = [[UITextField alloc]init];
//    txtFirst.frame = CGRectMake(30, 225, 220, 35);
//    [txtFirst setBackground:[UIImage imageNamed:@"textfiled_1x.png"]];
//    [txtFirst setPlaceholder:@"Message"];
//    [objScrollView addSubview:txtFirst];
    
    txtViewFirst = [[UITextView alloc]init];
    txtViewFirst.frame = CGRectMake(30, 225, 220, 80);
    [objScrollView addSubview:txtViewFirst];

    objScrollView.contentSize = CGSizeMake(280, 450);
    
    btnSave.frame = CGRectMake(79, 336, 122, 37);
}

-(void)createSecondView
{
    [self removeAllViews];
    
    isFirstSelected = YES;
    isSecondSelected = YES;
    
    viewFirstReminder = [[UIView alloc]init];
    viewFirstReminder.frame = CGRectMake(20, 166, 240, 150);
    viewFirstReminder.backgroundColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    [objScrollView addSubview:viewFirstReminder];
    
    btnFirst = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFirst.frame = CGRectMake(30, 176, 220, 35);
    [btnFirst setBackgroundImage:[UIImage imageNamed:@"dropdown_1x.png"] forState:UIControlStateNormal];
    [btnFirst addTarget:self action:@selector(btnFirstClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnFirst setTitleColor:[UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [btnFirst setTitle:@"Select Time" forState:UIControlStateNormal];
    [btnFirst.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:14]];
    [btnFirst setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [btnFirst setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [objScrollView addSubview:btnFirst];
    
//    txtFirst = [[UITextField alloc]init];
//    txtFirst.frame = CGRectMake(30, 225, 220, 35);
//    [txtFirst setBackground:[UIImage imageNamed:@"textfiled_1x.png"]];
//    [txtFirst setPlaceholder:@"Message"];
//    [objScrollView addSubview:txtFirst];
    
    txtViewFirst = [[UITextView alloc]init];
    txtViewFirst.frame = CGRectMake(30, 225, 220, 80);
    [objScrollView addSubview:txtViewFirst];

    
    viewSecondReminder = [[UIView alloc]init];
    viewSecondReminder.frame = CGRectMake(20, 330, 240, 150);
    viewSecondReminder.backgroundColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    [objScrollView addSubview:viewSecondReminder];
    
    btnSecond = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSecond.frame = CGRectMake(30, 340, 220, 35);
    [btnSecond setBackgroundImage:[UIImage imageNamed:@"dropdown_1x.png"] forState:UIControlStateNormal];
    [btnSecond addTarget:self action:@selector(btnSecondClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnSecond setTitleColor:[UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [btnSecond setTitle:@"Select Time" forState:UIControlStateNormal];
    [btnSecond.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:14]];
    [btnSecond setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [btnSecond setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [objScrollView addSubview:btnSecond];
    
//    txtSecond = [[UITextField alloc]init];
//    txtSecond.frame = CGRectMake(30, 345, 220, 35);
//    [txtSecond setBackground:[UIImage imageNamed:@"textfiled_1x.png"]];
//    [txtSecond setPlaceholder:@"Message"];
//    [objScrollView addSubview:txtSecond];
    
    txtViewSecond = [[UITextView alloc]init];
    txtViewSecond.frame = CGRectMake(30, 390, 220, 80);
    [objScrollView addSubview:txtViewSecond];


    objScrollView.contentSize = CGSizeMake(280, 600);
    
    btnSave.frame = CGRectMake(79, 500, 122, 37);
}

-(void)createThirdView
{
    [self removeAllViews];
    
    isFirstSelected = YES;
    isSecondSelected = YES;
    isThirdSelected = YES;
    
    viewFirstReminder = [[UIView alloc]init];
    viewFirstReminder.frame = CGRectMake(20, 166, 240, 150);
    viewFirstReminder.backgroundColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    [objScrollView addSubview:viewFirstReminder];
    
    btnFirst = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFirst.frame = CGRectMake(30, 176, 220, 35);
    [btnFirst setBackgroundImage:[UIImage imageNamed:@"dropdown_1x.png"] forState:UIControlStateNormal];
    [btnFirst addTarget:self action:@selector(btnFirstClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnFirst setTitleColor:[UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [btnFirst.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:14]];
    [btnFirst.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [btnFirst setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [btnFirst setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [objScrollView addSubview:btnFirst];
    
//    txtFirst = [[UITextField alloc]init];
//    txtFirst.frame = CGRectMake(30, 225, 220, 35);
//    [txtFirst setBackground:[UIImage imageNamed:@"textfiled_1x.png"]];
//    [txtFirst setPlaceholder:@"Message"];
//    [objScrollView addSubview:txtFirst];
    
    txtViewFirst = [[UITextView alloc]init];
    txtViewFirst.frame = CGRectMake(30, 225, 220, 80);
    [objScrollView addSubview:txtViewFirst];


    viewSecondReminder = [[UIView alloc]init];
    viewSecondReminder.frame = CGRectMake(20, 330, 240, 150);
    viewSecondReminder.backgroundColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    [objScrollView addSubview:viewSecondReminder];

    btnSecond = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSecond.frame = CGRectMake(30, 340, 220, 35);
    [btnSecond setBackgroundImage:[UIImage imageNamed:@"dropdown_1x.png"] forState:UIControlStateNormal];
    [btnSecond addTarget:self action:@selector(btnSecondClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnSecond setTitleColor:[UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [btnSecond setTitle:@"Select Time" forState:UIControlStateNormal];
    [btnSecond.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:14]];
    [btnSecond setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [btnSecond setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [objScrollView addSubview:btnSecond];
    
//    txtSecond = [[UITextField alloc]init];
//    txtSecond.frame = CGRectMake(30, 345, 220, 35);
//    [txtSecond setBackground:[UIImage imageNamed:@"textfiled_1x.png"]];
//    [txtSecond setPlaceholder:@"Message"];
//    [objScrollView addSubview:txtSecond];
    
    txtViewSecond = [[UITextView alloc]init];
    txtViewSecond.frame = CGRectMake(30, 390, 220, 80);
    [objScrollView addSubview:txtViewSecond];


    viewThirdReminder = [[UIView alloc]init];
    viewThirdReminder.frame = CGRectMake(20, 500, 240, 150);
    viewThirdReminder.backgroundColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    [objScrollView addSubview:viewThirdReminder];
    
    btnThird = [UIButton buttonWithType:UIButtonTypeCustom];
    btnThird.frame = CGRectMake(30, 515, 220, 35);
    [btnThird setBackgroundImage:[UIImage imageNamed:@"dropdown_1x.png"] forState:UIControlStateNormal];
    [btnThird addTarget:self action:@selector(btnThirdClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnThird setTitleColor:[UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [btnThird setTitle:@"Select Time" forState:UIControlStateNormal];
    [btnThird.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:14]];
    [btnThird setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [btnThird setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [objScrollView addSubview:btnThird];
    
//    txtThird = [[UITextField alloc]init];
//    txtThird.frame = CGRectMake(30, 465, 220, 35);
//    [txtThird setBackground:[UIImage imageNamed:@"textfiled_1x.png"]];
//    [txtThird setPlaceholder:@"Message"];
//    [objScrollView addSubview:txtThird];
    
    txtViewThird = [[UITextView alloc]init];
    txtViewThird.frame = CGRectMake(30, 560, 220, 80);
    [objScrollView addSubview:txtViewThird];


    objScrollView.contentSize = CGSizeMake(280, 750);
    
    btnSave.frame = CGRectMake(79, 680, 122, 37);
}

-(void)createFourthView
{
    [self removeAllViews];
    
    isFirstSelected = YES;
    isSecondSelected = YES;
    isThirdSelected = YES;
    isFourthSelected = YES;
    
    viewFirstReminder = [[UIView alloc]init];
    viewFirstReminder.frame = CGRectMake(20, 166, 240, 150);
    viewFirstReminder.backgroundColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    [objScrollView addSubview:viewFirstReminder];
    
    btnFirst = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFirst.frame = CGRectMake(30, 176, 220, 35);
    [btnFirst setBackgroundImage:[UIImage imageNamed:@"dropdown_1x.png"] forState:UIControlStateNormal];
    [btnFirst addTarget:self action:@selector(btnFirstClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnFirst setTitleColor:[UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [btnFirst setTitle:@"Select Time" forState:UIControlStateNormal];
    [btnFirst.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:14]];
    [btnFirst setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [btnFirst setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [objScrollView addSubview:btnFirst];
    
//    txtFirst = [[UITextField alloc]init];
//    txtFirst.frame = CGRectMake(30, 225, 220, 35);
//    [txtFirst setBackground:[UIImage imageNamed:@"textfiled_1x.png"]];
//    [txtFirst setPlaceholder:@"Message"];
//    [objScrollView addSubview:txtFirst];
    
    txtViewFirst = [[UITextView alloc]init];
    txtViewFirst.frame = CGRectMake(30, 225, 220, 80);
    [objScrollView addSubview:txtViewFirst];

    viewSecondReminder = [[UIView alloc]init];
    viewSecondReminder.frame = CGRectMake(20, 330, 240, 150);
    viewSecondReminder.backgroundColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    [objScrollView addSubview:viewSecondReminder];
    
    btnSecond = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSecond.frame = CGRectMake(30, 340, 220, 35);
    [btnSecond setBackgroundImage:[UIImage imageNamed:@"dropdown_1x.png"] forState:UIControlStateNormal];
    [btnSecond addTarget:self action:@selector(btnSecondClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnSecond setTitleColor:[UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [btnSecond setTitle:@"Select Time" forState:UIControlStateNormal];
    [btnSecond.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:14]];
    [btnSecond setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [btnSecond setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [objScrollView addSubview:btnSecond];
    
//    txtSecond = [[UITextField alloc]init];
//    txtSecond.frame = CGRectMake(30, 345, 220, 35);
//    [txtSecond setBackground:[UIImage imageNamed:@"textfiled_1x.png"]];
//    [txtSecond setPlaceholder:@"Message"];
//    [objScrollView addSubview:txtSecond];
    
    txtViewSecond = [[UITextView alloc]init];
    txtViewSecond.frame = CGRectMake(30, 390, 220, 80);
    [objScrollView addSubview:txtViewSecond];

    viewThirdReminder = [[UIView alloc]init];
    viewThirdReminder.frame = CGRectMake(20, 500, 240, 150);
    viewThirdReminder.backgroundColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    [objScrollView addSubview:viewThirdReminder];

    btnThird = [UIButton buttonWithType:UIButtonTypeCustom];
    btnThird.frame = CGRectMake(30, 515, 220, 35);
    [btnThird setBackgroundImage:[UIImage imageNamed:@"dropdown_1x.png"] forState:UIControlStateNormal];
    [btnThird addTarget:self action:@selector(btnThirdClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnThird setTitleColor:[UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [btnThird setTitle:@"Select Time" forState:UIControlStateNormal];
    [btnThird.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:14]];
    [btnThird setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [btnThird setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [objScrollView addSubview:btnThird];
    
//    txtThird = [[UITextField alloc]init];
//    txtThird.frame = CGRectMake(30, 465, 220, 35);
//    [txtThird setBackground:[UIImage imageNamed:@"textfiled_1x.png"]];
//    [txtThird setPlaceholder:@"Message"];
//    [objScrollView addSubview:txtThird];
    
    
    txtViewThird = [[UITextView alloc]init];
    txtViewThird.frame = CGRectMake(30, 560, 220, 80);
    [objScrollView addSubview:txtViewThird];


    viewFourthReminder = [[UIView alloc]init];
    viewFourthReminder.frame = CGRectMake(20, 670, 240, 150);
    viewFourthReminder.backgroundColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    [objScrollView addSubview:viewFourthReminder];
    
    btnFourth = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFourth.frame = CGRectMake(30, 685, 220, 35);
    [btnFourth setBackgroundImage:[UIImage imageNamed:@"dropdown_1x.png"] forState:UIControlStateNormal];
    [btnFourth addTarget:self action:@selector(btnFourthClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnFourth setTitleColor:[UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    [btnFourth setTitle:@"Select Time" forState:UIControlStateNormal];
    [btnFourth.titleLabel setFont:[UIFont fontWithName:@"Avenir-Roman" size:14]];
    [btnFourth setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [btnFourth setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [objScrollView addSubview:btnFourth];
    
//    txtFourth = [[UITextField alloc]init];
//    txtFourth.frame = CGRectMake(30, 585, 220, 35);
//    [txtFourth setBackground:[UIImage imageNamed:@"textfiled_1x.png"]];
//    [txtFourth setPlaceholder:@"Message"];
//    [objScrollView addSubview:txtFourth];
    
    txtViewFourth = [[UITextView alloc]init];
    txtViewFourth.frame = CGRectMake(30, 730, 220, 80);
    [objScrollView addSubview:txtViewFourth];


    objScrollView.contentSize = CGSizeMake(280, 900);
    
    btnSave.frame = CGRectMake(79, 840, 122, 37);
}

-(void)removeAllViews
{
    [viewFirstReminder removeFromSuperview];
    [viewSecondReminder removeFromSuperview];
    [viewThirdReminder removeFromSuperview];
    [viewFourthReminder removeFromSuperview];
    
    [btnFirst removeFromSuperview];
    [btnSecond removeFromSuperview];
    [btnThird removeFromSuperview];
    [btnFourth removeFromSuperview];
    
    [txtViewFirst removeFromSuperview];
    [txtViewSecond removeFromSuperview];
    [txtViewThird removeFromSuperview];
    [txtViewFourth removeFromSuperview];
}

-(void)btnFirstClicked:(UIButton *)sender
{
    [txtViewFirst resignFirstResponder];
    [txtViewSecond resignFirstResponder];
    [txtViewThird resignFirstResponder];
    [txtViewFourth resignFirstResponder];
    isFirstSelected = YES;
    pickerView.datePickerMode = UIDatePickerModeTime;
    indexSelected = 3;
    [self navigate];
}

-(void)btnSecondClicked:(UIButton *)sender
{
    [txtViewFirst resignFirstResponder];
    [txtViewSecond resignFirstResponder];
    [txtViewThird resignFirstResponder];
    [txtViewFourth resignFirstResponder];
    isSecondSelected = YES;
    pickerView.datePickerMode = UIDatePickerModeTime;
    indexSelected = 4;
    [self navigate];
}

-(void)btnThirdClicked:(UIButton *)sender
{
    [txtViewFirst resignFirstResponder];
    [txtViewSecond resignFirstResponder];
    [txtViewThird resignFirstResponder];
    [txtViewFourth resignFirstResponder];
    isThirdSelected = YES;
    pickerView.datePickerMode = UIDatePickerModeTime;
    indexSelected = 5;
    [self navigate];
}

-(void)btnFourthClicked:(UIButton *)sender
{
    [txtViewFirst resignFirstResponder];
    [txtViewSecond resignFirstResponder];
    [txtViewThird resignFirstResponder];
    [txtViewFourth resignFirstResponder];
    isFourthSelected = YES;
    pickerView.datePickerMode = UIDatePickerModeTime;
    indexSelected = 6;
    [self navigate];
}

-(void)fetchAllReminders:(NSArray *)array
{
    arrayReminderStartDate = [[NSMutableArray alloc]init];
    arrayReminderEndDate = [[NSMutableArray alloc]init];
    arrayReminderMessage = [[NSMutableArray alloc]init];
    arrayReminderTime = [[NSMutableArray alloc]init];
    
    
    for (int i = 0; i<[array count]; i++) {
        
        NSManagedObject * info = [array objectAtIndex:i];
        
        [arrayReminderStartDate addObject:[info valueForKey:@"startDate"]];
        [arrayReminderEndDate addObject:[info valueForKey:@"endDate"]];
        [arrayReminderMessage addObject:[info valueForKey:@"message"]];
        [arrayReminderTime addObject:[info valueForKey:@"reminderTime"]];
    }
    
    [tblReminder reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
