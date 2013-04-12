//
//  AppDelegate.m
//  ActionSheet
//
//  Created by Marco Meschini on 08/04/2013.
//  Copyright (c) 2013 Marco Meschini. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomPickerController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];

    
    UIViewController *rootVC = [[[UIViewController alloc] init] autorelease];
    UIBarButtonItem *button = [[[UIBarButtonItem alloc] initWithTitle:@"Press me!"
                                                                style:UIBarButtonItemStyleDone
                                                               target:self
                                                               action:@selector(_doneButtonDidTap:)] autorelease];
    rootVC.navigationItem.rightBarButtonItem = button;
    
//    CustomPickerController *vc = [[[CustomPickerController alloc] init] autorelease];
    
    UINavigationController *nc = [[[UINavigationController alloc] initWithRootViewController:rootVC] autorelease];
//    nc.navigationBarHidden = YES;
    self.window.rootViewController = nc;
    
//    [self performSelector:@selector(_doneButtonDidTap:) withObject:nil afterDelay:2.0f];
    
//    nc.view.layer.borderWidth = 10.0f;
//    nc.view.layer.borderColor = [UIColor blueColor].CGColor;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)_doneButtonDidTap:(id)sender
{    
    NSArray *dummyArray = @[@"scrollViewTexturedBackgroundColor", @"blackColor", @"redColor", @"greenColor", @"orangeColor"];
    CustomPickerController *vc = [[[CustomPickerController alloc] init] autorelease];
    vc.values = dummyArray;
    __block typeof(self) weakself = self;
    vc.didSelectRowBlock = ^(CustomPickerController *picker, NSInteger row){
        NSLog(@"selected row:%i, %@", row, dummyArray[row]);
        weakself.window.backgroundColor = [UIColor performSelector:NSSelectorFromString(dummyArray[row])];
    };

    [vc showAnimated:YES];
    
//    [self.window.rootViewController presentViewController:vc
//                                                 animated:YES
//                                               completion:NULL];
}

- (void)_myDebugHook:(id)sedner
{
    NSLog(@"i want to debug here");
}

@end
