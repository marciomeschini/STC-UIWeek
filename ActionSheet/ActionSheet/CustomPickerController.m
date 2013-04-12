
//
//  ViewController.m
//  ActionSheet
//
//  Created by Marco Meschini on 08/04/2013.
//  Copyright (c) 2013 Marco Meschini. All rights reserved.
//

#import "CustomPickerController.h"
#import <objc/runtime.h>

#define kBackgroundColor                    [[UIColor blackColor] colorWithAlphaComponent:.4f]
#define kAnimationDuration                  .3f
#define kPreferredInterfaceOrientation      UIInterfaceOrientationMaskPortrait

@interface CustomPickerController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, readwrite, retain) UIPickerView *pickerView;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) UIWindow *window, *previousWindow;
@property (nonatomic, assign) NSUInteger rootViewControllerSupportedInterfaceOrientations;
@end

@implementation CustomPickerController

- (void)dealloc
{
    self.previousWindow = nil;
    self.window = nil;
    self.toolbar = nil;
    self.didSelectRowBlock = nil;
    self.values = nil;
    self.pickerView = nil;
    self.containerView = nil;
    [super dealloc];
}

- (id)init
{
    if (self = [super init])
    {
        self.backgroundColor = kBackgroundColor;
        self.preferredInterfaceOrientation = kPreferredInterfaceOrientation;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    // calculate containerView height
    CGFloat toolbarHeight = CGRectGetHeight(self.toolbar.frame);
    CGFloat pickerViewHeight = CGRectGetHeight(self.pickerView.frame);
    CGFloat containerViewHeight = pickerViewHeight + toolbarHeight;
    CGRect containerFrame = self.view.bounds;
    containerFrame.origin.y += (CGRectGetHeight(containerFrame)-containerViewHeight);
    containerFrame.size.height = containerViewHeight;
    self.containerView.frame = containerFrame;
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.containerView];
    
    //
    [self.containerView addSubview:self.toolbar];

    //
    CGPoint pickerViewCenter = self.pickerView.center;
    pickerViewCenter.y += toolbarHeight;
    self.pickerView.center = pickerViewCenter;
    [self.containerView addSubview:self.pickerView];
    
    self.view.layer.borderWidth = 2.0f;
    self.view.layer.borderColor = [UIColor redColor].CGColor;
}

// iOS 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

// iOS 6
- (NSUInteger)supportedInterfaceOrientations
{
    return self.preferredInterfaceOrientation;
}

#pragma mark - Accessors
- (UIView *)containerView
{
    if (!self->_containerView) self->_containerView = [[UIView alloc] init];
    return self->_containerView;
}

- (UIPickerView *)pickerView
{
    if (!self->_pickerView)
    {
        self->_pickerView = [[UIPickerView alloc] init];
        self->_pickerView.dataSource = self;
        self->_pickerView.delegate = self;
    }
    
    return self->_pickerView;
}

- (UIToolbar *)toolbar
{
    if (!self->_toolbar)
    {
        self->_toolbar = [[UIToolbar alloc] init];
        self->_toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self->_toolbar sizeToFit];
        
        UIBarButtonItem *flexibleSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                        target:nil action:NULL] autorelease];
        
        UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                     target:self
                                                                                     action:@selector(_didPressDoneButton:)] autorelease];
        
        self->_toolbar.items = @[flexibleSpace, doneButton];
    }
    
    return self->_toolbar;
}

- (UIWindow *)window
{
    if (!self->_window)
    {
        CGRect windowFrame = [UIScreen mainScreen].bounds;
        self->_window = [[UIWindow alloc] initWithFrame:windowFrame];
        self->_window.windowLevel = UIWindowLevelStatusBar + 1;
        self->_window.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    
    return self->_window;
}

#pragma mark - Private
- (void)_overrideRootViewControllerSupportedInterfaceOrientationsIfNeeded
{
    /*
     In iOS 6, your app supports the interface orientations defined in your app’s Info.plist file. A view controller can override the supportedInterfaceOrientations method to limit the list of supported orientations. Generally, the system calls this method only on the root view controller of the window or a view controller presented to fill the entire screen; child view controllers use the portion of the window provided for them by their parent view controller and no longer participate in directly in decisions about what rotations are supported. The intersection of the app’s orientation mask and the view controller’s orientation mask is used to determine which orientations a view controller can be rotated into.
     */
    self.rootViewControllerSupportedInterfaceOrientations = [self _setSupportedInterfaceOrientations:self.preferredInterfaceOrientation];
}

- (void)_restoreRootViewControllerSupportedInterfaceOrientationsIfNeeded
{    
    [self _setSupportedInterfaceOrientations:self.rootViewControllerSupportedInterfaceOrientations];
}

// Return the previous supported interface orientations and apply the new ones only if needed
//
- (NSUInteger)_setSupportedInterfaceOrientations:(NSUInteger)newSupportedInterfaceOrientations
{
    SEL selector = @selector(supportedInterfaceOrientations);
    UIViewController *target = (UIViewController *)self.previousWindow.rootViewController;
    NSUInteger supportedInterfaceOrientations = (NSUInteger)[target performSelector:selector];
    if (supportedInterfaceOrientations != newSupportedInterfaceOrientations)
    {
        __block NSUInteger interfaceOrientationsToReturn = newSupportedInterfaceOrientations;
        IMP imp = imp_implementationWithBlock(^(id self, SEL _cmd) { return interfaceOrientationsToReturn; });
        
        Class targetClass = [target class];
        Method method = class_getInstanceMethod(targetClass, selector);
        method_setImplementation(method, imp);
    }
    
    return supportedInterfaceOrientations;
}

#pragma mark - Picker datasource/delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.values.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    id item = self.values[row];
    if (![item isKindOfClass:[NSString class]]) return [NSString stringWithFormat:@"item:%i", row];
    return item;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.didSelectRowBlock) self.didSelectRowBlock(self, row);
}

#pragma mark - Public
- (void)showAnimated:(BOOL)animated
{
    //
    self.previousWindow = [UIApplication sharedApplication].keyWindow;
        
    //
    [self _overrideRootViewControllerSupportedInterfaceOrientationsIfNeeded];
    
    //
    self.window.rootViewController = self;
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    
    
    //
    if (animated)
    {
        CGFloat offset = CGRectGetHeight(self.containerView.frame);
        self.containerView.frame = CGRectOffset(self.containerView.frame, .0f, offset);
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.window.backgroundColor = self.backgroundColor;
            self.containerView.frame = CGRectOffset(self.containerView.frame, .0f, -offset);
        }];
    }
}

- (void)dismissAnimated:(BOOL)animated
{
    __block typeof(self) weakSelf = self;
    void (^completionBlock)() = ^(){
        
        [weakSelf _restoreRootViewControllerSupportedInterfaceOrientationsIfNeeded];
        
        [weakSelf.window resignKeyWindow];
        [weakSelf.previousWindow makeKeyAndVisible];
        weakSelf.window = nil;
    };
    
    if (!animated)
        completionBlock();
    else
    {
        CGFloat offset = CGRectGetHeight(self.containerView.frame);
        [UIView animateWithDuration:kAnimationDuration
                         animations:^{
                             self.containerView.frame = CGRectOffset(self.containerView.frame, .0f, offset);
                             self.window.backgroundColor = [UIColor clearColor];
                         }
                         completion:^(BOOL finished) {
                             
                             //
                             completionBlock();
                             
                             //
                             self.containerView.frame = CGRectOffset(self.containerView.frame, .0f, -offset);
                             self.view.backgroundColor = self.backgroundColor;
                         }];
    }
}

#pragma mark - Actions/Callbacks
- (void)_didPressDoneButton:(id)sender
{
    [self dismissAnimated:YES];
}


@end
