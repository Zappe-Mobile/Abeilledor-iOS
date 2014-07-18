
//
//  AppDelegate.m
//  AbeilleDor
//
//  Created by Roman Khan on 03/03/14.
//  Copyright (c) 2014 Chaos Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "MenuViewController.h"
#import "JASidePanelController.h"
#import "MagicalRecord+Setup.h"
#import "MKLocalNotificationsScheduler.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
#import "JRNLocalNotificationCenter.h"
#import "MessageViewController.h"
#import "DataManager.h"

static NSString * const kClientId = @"151597012826-9hgdtpvj8nk48pc77fh84ppqsurg39vq.apps.googleusercontent.com";
#define kURL @"http://abdchlorella.com/site/apple_push/push_user.php?dtoken=%@&dtype=iOS"

@interface AppDelegate () <NSURLConnectionDelegate>
{
    
}
@end

@implementation AppDelegate
@synthesize viewController = _viewController;
@synthesize responseData;

-(void)setController:(BOOL)value
{
    Value = value;
    if (Value) {
        self.viewController = [[JASidePanelController alloc] init];
        self.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
        self.viewController.bounceOnSidePanelOpen = NO;
        self.viewController.bounceOnCenterPanelChange = NO;
        
        MenuViewController * objSidePanel = [[MenuViewController alloc]init];
        self.viewController.rightPanel = objSidePanel;
        
        
        HomeViewController * objHome = [[HomeViewController alloc]init];
        UINavigationController * chariotNav = [[UINavigationController alloc]initWithRootViewController:objHome];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        
        UIGraphicsBeginImageContext(CGSizeMake(1, 1));
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[UIColor colorWithRed:106.0f/255.0f green:59.0f/255.0f blue:5.0f/255.0f alpha:1.0f] set];
        CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
        
        UIImage *navBarBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        [[UINavigationBar appearance] setBackgroundImage:navBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
        chariotNav.navigationBar.translucent = YES;
        
        self.viewController.centerPanel = chariotNav;
        
        self.window.rootViewController = self.viewController;
        
        
    }
    else {
        LoginViewController * objRegister = [[LoginViewController alloc]init];
        UINavigationController * registerNav = [[UINavigationController alloc]initWithRootViewController:objRegister];
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        
        UIGraphicsBeginImageContext(CGSizeMake(1, 1));
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[UIColor colorWithRed:106.0f/255.0f green:59.0f/255.0f blue:5.0f/255.0f alpha:1.0f] set];
        CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
        
        UIImage *navBarBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        [[UINavigationBar appearance] setBackgroundImage:navBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
        registerNav.navigationBar.translucent = YES;

        [self.window setRootViewController:registerNav];
        
    }
    [self.window makeKeyAndVisible];

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [GPPSignIn sharedInstance].clientID = kClientId;
    // Read Google+ deep-link data.
//    [GPPDeepLink setDelegate:self];
//    [GPPDeepLink readDeepLinkAfterInstall];
    //! Set Whether the App is Getting Launched First Time OR
    
    
    NSLog(@"%@",launchOptions);
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }

    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"firstLaunch"]) {
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"0" forKey:@"CART"];
        [defaults setObject:@"" forKey:@"LASTMESSAGE"];
        [defaults synchronize];
    }
    
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    application.applicationIconBadgeNumber = 0;
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    
    [[JRNLocalNotificationCenter defaultCenter] setLocalNotificationHandler:^(NSString *key, NSDictionary *userInfo) {
        
        NSLog(@"%@",key);
        NSLog(@"%@",userInfo);
        
//        if ( [key isEqualToString:@"test"] ) {
            [[[UIAlertView alloc] initWithTitle:@"Abeilledor"
                                        message:[userInfo objectForKey:@"TEXT"]
                                       delegate:nil
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:nil] show];
//        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TABLESELECT" object:nil userInfo:nil];
        
    }];
    
    if ( launchOptions[UIApplicationLaunchOptionsLocalNotificationKey] ) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TABLESELECT" object:nil userInfo:nil];
        [[JRNLocalNotificationCenter defaultCenter] didReceiveLocalNotificationUserInfo:launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]];
    }


    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [self setupDB];
    self.window.backgroundColor = [UIColor whiteColor];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"OAUTH"]!= NULL) {
        [self setController:YES];
    }
    else {
        [self setController:NO];
    }
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupDB
{
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:[self dbStore]];

}

- (NSString *)dbStore
{
    NSString *bundleID = (NSString *)[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    return [NSString stringWithFormat:@"%@.sqlite", bundleID];
}

- (void)cleanAndResetupDB
{
    NSString *dbStore = [self dbStore];
    
    NSError *error = nil;
    
    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:dbStore];
    
    [MagicalRecord cleanUp];
    
    if([[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error]){
        [self setupDB];
    }
    else{
        NSLog(@"An error has occurred while deleting %@", dbStore);
        NSLog(@"Error description: %@", error.description);
    }
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *str = [NSString
                     stringWithFormat:@"%@",deviceToken];
    NSLog(@"%@",str);
    NSString *pushToken = [[[str stringByReplacingOccurrencesOfString:@"<" withString:@""]
                             stringByReplacingOccurrencesOfString:@">" withString:@""]
                            stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@",pushToken);
    self.responseData = [NSMutableData data];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:pushToken forKey:@"DEVICETOKEN"];
    [defaults synchronize];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:kURL,pushToken]]];
    [request setHTTPMethod:@"GET"];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
 	self.responseData = nil;
}

#pragma mark -
#pragma mark Process loan data
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSLog(@"%@",responseData);
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"rs%@",responseString);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"%@",str);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }
    NSLog(@"%@",userInfo);
    
    NSLog(@"%@",[[userInfo objectForKey:@"aps"]objectForKey:@"alert"]);
    
//    [DataManager StoreMessageData:[[userInfo objectForKey:@"aps"]objectForKey:@"alert"] WithDataBlock:^(BOOL success, NSError *error) {
//        
//        if (success) {
//            
//        }
//        else {
//            
//        }
//    }];
//    
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:[[userInfo objectForKey:@"aps"]objectForKey:@"alert"] forKey:@"PUSHMESSAGE"];
//    [defaults synchronize];
    
    
    
    //UINavigationController *navController = (UINavigationController *)self.window.rootViewController;
    
    MessageViewController *notificationViewController = [[MessageViewController alloc] init];
    UINavigationController * chariotNav = [[UINavigationController alloc]initWithRootViewController:notificationViewController];

    
    self.viewController = [[JASidePanelController alloc] init];
    self.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
    self.viewController.bounceOnSidePanelOpen = NO;
    self.viewController.bounceOnCenterPanelChange = NO;
    
    MenuViewController * objSidePanel = [[MenuViewController alloc]init];
    self.viewController.rightPanel = objSidePanel;
    
    
    self.viewController.centerPanel = chariotNav;
    self.window.rootViewController = self.viewController;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PUSHMESSAGE" object:nil];


}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TABLESELECT" object:nil userInfo:nil];
    [[JRNLocalNotificationCenter defaultCenter] didReceiveLocalNotificationUserInfo:notification.userInfo];
}


-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [FBSession.activeSession handleOpenURL:url];
    
}



-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([[url scheme] isEqualToString:@"fb435998106546078"])
    {
        BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
        return wasHandled;
    }
    else {
        return [GPPURLHandler handleURL:url
               sourceApplication:sourceApplication
                      annotation:annotation];
    }
    return 0;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)localNotification {
//    
//    UIApplicationState state = [[UIApplication sharedApplication] applicationState];
//    if (state == UIApplicationStateInactive) {
//        // Application was in the background when notification
//        // was delivered.
//    }
//    else if (state == UIApplicationStateActive)
//    {
//        // show an alert view
//        UIAlertView *alertView=[[UIAlertView alloc]
//                                initWithTitle:@"Abeille d'Or"
//                                message:@"Medication Reminder Time"
//                                delegate:self
//                                cancelButtonTitle:nil
//                                otherButtonTitles:@"Ok",
//                                nil];
//        [alertView show];
//        NSError * error;
//        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/apple_alarm.mp3", [[NSBundle mainBundle] resourcePath]]];
//        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//        [player play];
//    }
//    
//    NSArray* scheduledNotifications = [NSArray arrayWithArray:app.scheduledLocalNotifications];
//    NSLog(@"%lu",(unsigned long)[scheduledNotifications count]);
//    //[[MKLocalNotificationsScheduler sharedInstance]clearBadgeCount];
//}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //[[MKLocalNotificationsScheduler sharedInstance]clearBadgeCount];
}

#pragma mark - GPPDeepLinkDelegate

- (void)didReceiveDeepLink:(GPPDeepLink *)deepLink {
    // An example to handle the deep link data.
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Deep-link Data"
                          message:[deepLink deepLinkID]
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}


@end
