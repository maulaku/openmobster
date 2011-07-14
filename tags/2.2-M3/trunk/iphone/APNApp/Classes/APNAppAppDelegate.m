//
//  APNAppAppDelegate.m
//  APNApp
//
//  Created by openmobster on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "APNAppAppDelegate.h"
#import "APNAppViewController.h"
#import "Kernel.h"
#import "UIKernel.h"
#import "Channel.h"
#import "Configuration.h"
#import "Request.h"
#import "Response.h"
#import "MobileService.h"
#import "SubmitDeviceToken.h"
#import "CloudService.h"

@implementation APNAppAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
    [self.window addSubview:viewController.view];
    [self.window makeKeyAndVisible];
	
	//Bootstrap the Cloud services
	[self startCloudService];
	
	NSLog(@"Registering for push notifications for real...");    
    [[UIApplication sharedApplication] 
	 registerForRemoteNotificationTypes:
	 (UIRemoteNotificationTypeAlert | 
	  UIRemoteNotificationTypeBadge | 
	  UIRemoteNotificationTypeSound)];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	/*AppService *appService = [AppService getInstance];
	[appService start];
	
	UIAlertView *dialog = [[UIAlertView alloc] 
						   initWithTitle:@"APNApp"
						   message:@"App successfully launched" 
						   delegate:nil 
						   cancelButtonTitle:@"OK" otherButtonTitles:nil];
	dialog = [dialog autorelease];
	[dialog show];*/
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	[self stopCloudService];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}
//-----Integration for Push Notifications---------------------------------------------
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken 
{ 
	
    NSString *str = [NSString stringWithFormat:@"Device Token=%@",deviceToken];
	
	//show this in an alert dialog
	UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Device Token"
													 message:str delegate:nil 
										   cancelButtonTitle:@"OK" otherButtonTitles:nil];
	dialog = [dialog autorelease];
	[dialog show];
	
	
	NSString *deviceTokenStr = [NSString stringWithFormat:@"%@",deviceToken];
	deviceTokenStr = [StringUtil replaceAll:deviceTokenStr :@"<" :@""];
	deviceTokenStr = [StringUtil replaceAll:deviceTokenStr :@">" :@""];
	
	@try 
	{
		SubmitDeviceToken *submit = [SubmitDeviceToken withInit];
		[submit submit:deviceTokenStr];
	}
	@catch (SystemException * syse) 
	{
		UIAlertView *dialog = [[UIAlertView alloc] 
							   initWithTitle:@"Token Registration Error"
							   message:@"Device Token Cloud Registration Failed. Please make sure your device is activated with the Cloud using the ActivationApp. Re-start this App to start the token registration again" 
							   delegate:nil 
							   cancelButtonTitle:@"OK" otherButtonTitles:nil];
		dialog = [dialog autorelease];
		[dialog show];
	}
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err { 
	
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    
	UIAlertView *dialog = [[UIAlertView alloc] 
						   initWithTitle:@"Token Registration Error"
						   message:str 
						   delegate:nil 
						   cancelButtonTitle:@"OK" otherButtonTitles:nil];
	dialog = [dialog autorelease];
	[dialog show];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	
    for (id key in userInfo) 
	{
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }    
	
}
//---OpenMobster Cloud Layer integration-------------------------------------------------------
-(void)startCloudService
{
	@try 
	{
		CloudService *cloudService = [CloudService getInstance:viewController];
		
		[cloudService startup];
	}
	@catch (NSException * e) 
	{
		//something caused the kernel to crash
		//stop the kernel
		[self stopCloudService];
	}
}

-(void)stopCloudService
{
	@try
	{
		CloudService *cloudService = [CloudService getInstance];
		[cloudService shutdown];
	}
	@catch (NSException *e) 
	{
		
	}
}

@end