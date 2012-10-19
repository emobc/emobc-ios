/**
 *  Copyright 2012 Neurowork Consulting S.L.
 *
 *  This file is part of eMobc.
 *
 *  eMobcViewController.m
 *  eMobc IOS Framework
 *
 *  eMobc is free software: you can redistribute it and/or modify
 *  it under the terms of the Affero GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  eMobc is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the Affero GNU General Public License
 *  along with eMobc.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#import "eMobcAppDelegate.h"
#import "eMobcViewController.h"
#import "AppParser.h"
#import "CoverParser.h"
#import "ImageDescriptionParser.h"
#import "SmartAdServerView.h"


@implementation eMobcAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

+ (void)initialize {

}

/**
 * Tells the delegate when the application has launched and may have additional launch options to handle.
 * 
 * @param application The delegating application object.
 * @param launchOptions A dictionary indicating the reason the application was launched (if any).
 *
 * @return NO if the application cannot handle the URL resource, otherwise return YES. 
 * The return value is ignored if the application is launched as a result of a remote notification.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    // Override point for customization after application launch.

    // Add the view controller's view to the window and display.
    [window addSubview:viewController.view];

	[window makeKeyAndVisible];
	/*
	[SmartAdServerView setSiteID:32088];
    
    // Create the interstitial with the Launch Image (Default.png) as the loader, for a smooth transition
    _startupAdView = [[SmartAdServerView alloc] initWithFrame:self.window.bounds loader:SmartAdServerViewLoaderLaunchImage hideStatusBar:YES];
    
    // Important : an interstitial should'nt be unlimited, because it is removed after a defined duration, a tap on the skip button, or at the end of a video. We don't want to have it stay in place forever and to block the application.
    self.startupAdView.unlimited = NO;
    
    // We set the RootViewController instance as the delegate, so that it will notify this instance when the interstitial is dismissed.
    self.startupAdView.delegate = viewController;
    
    // We want to stay fulscreen, even on rotation events
    self.startupAdView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //We load the ad for the given tags
    [self.startupAdView loadFormatId:14015 pageId:@"234359" master:YES target:nil timeout:2500];
    
    //Add the view to the navigationController, so it stays fulscreen.
    [self.window addSubview:self.startupAdView];*/
    
    [self.window makeKeyAndVisible];

	//[viewController showSplash];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    return YES;
}

/**
 * Sent to the delegate when the application successfully registers with Apple Push Service (APS).
 *
 * @param application The application that initiated the remote-notification registration process.
 * @param deviceToken A token that identifies the device to APS
 */
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
    deviceToken = [[[[deviceToken description]
                     stringByReplacingOccurrencesOfString: @"<" withString: @""]
                    stringByReplacingOccurrencesOfString: @">" withString: @""]
                   stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSString *host = @"www.madeinmobile.net/3minmotor/";
    NSString *URLString = @"/register.php?id=";
    URLString = [URLString stringByAppendingString:@"3minmotor"];
    URLString = [URLString stringByAppendingString:@"&devicetoken="];
    
    NSString *dt = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    dt = [dt stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    URLString = [URLString stringByAppendingString:dt];
    URLString = [URLString stringByAppendingString:@"&devicename="];
    URLString = [URLString stringByAppendingString:[[UIDevice alloc] name]];
    
    NSURL *url = [[NSURL alloc] initWithScheme:@"http" host:host path:URLString];

    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
}


/**
 * Sent to the delegate when Apple Push Service cannot successfully complete the registration process.
 *
 * @param application The application that initiated the remote-notification registration process
 * @param error An NSError object that encapsulates information why registration did not succeed. 
 * The application can choose to display this information to the user.
 */
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
}


/**
 * Tells the delegate that the application is about to become inactive.
 *
 * @param application The singleton application instance
 */
- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

/**
 * Tells the delegate that the application is now in the background.
 *
 * @param application The singleton application instance
 */
- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}

/**
 * Tells the delegate that the application is about to enter the foreground
 *
 * @param application The singleton application instance.
 */
- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}

/**
 * Tells the delegate that the application has become active
 *
 * @param application The singleton application instance.
 */
- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

/**
 * Tells the delegate when the application is about to terminate.
 *
 * @param application The delegating application object.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

/**
 * Tells the delegate when the application receives a memory warning from the system.
 *
 * @param application The delegating application object.
 */
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

@end