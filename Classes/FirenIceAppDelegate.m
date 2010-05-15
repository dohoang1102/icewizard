//
//  FirenIceAppDelegate.m
//  FirenIce
//
//  Created by Per Borgman on 2010-05-07.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "FirenIceAppDelegate.h"
#import "EAGLView.h"

@implementation FirenIceAppDelegate

@synthesize window;
@synthesize glView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [glView startAnimation];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [glView stopAnimation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [glView startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [glView stopAnimation];
}

- (void)dealloc
{
    [window release];
    [glView release];

    [super dealloc];
}

@end
