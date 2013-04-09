
//
//  ViewController.m
//  ActionSheet
//
//  Created by Marco Meschini on 08/04/2013.
//  Copyright (c) 2013 Marco Meschini. All rights reserved.
//

#import "CustomPickerController.h"

#define kBackgroundColor        [[UIColor blackColor] colorWithAlphaComponent:.4f]
#define kAnimationDuration      .25f


@interface CustomPickerController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, retain) UIView *containerView;
//@property (nonatomic, retain) UIImageView *imageView;
//@property (nonatomic, retain) UIButton *doneButton;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) UIWindow *currentWindow, *oldWindow;
@end

@implementation CustomPickerController

- (void)dealloc
{
    self.toolbar = nil;
    self.didSelectRowBlock = nil;
    self.values = nil;
    self.pickerView = nil;
//    self.doneButton = nil;
//    self.imageView = nil;
    self.containerView = nil;
    [super dealloc];
}

- (id)init
{
    if (self = [super init])
    {
        self.backgroundColor = kBackgroundColor;
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    //
    self.view.backgroundColor = self.backgroundColor;
    
    
    
//    self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    [self.toolbar sizeToFit];
    

//    self.imageView.autoresizingMask = self.view.autoresizingMask;
//    CGRect rect = self.view.bounds;
////    rect.origin.y = -20.0f;
////    rect.size.height += 20.0f;
//    self.imageView.frame = rect;
//    [self.view addSubview:self.imageView];
//    self.imageView.layer.borderWidth = 5.0f;
    
    
    //
    CGFloat toolbarHeight = CGRectGetHeight(self.toolbar.frame);
    CGFloat pickerViewHeight = CGRectGetHeight(self.pickerView.frame);
    CGFloat containerViewHeight = pickerViewHeight + toolbarHeight;
    CGRect containerFrame = self.view.bounds;
    containerFrame.origin.y += (CGRectGetHeight(containerFrame)-containerViewHeight);
    containerFrame.size.height = containerViewHeight;
    self.containerView.frame = containerFrame;
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    [self.view addSubview:self.containerView];
//    self.containerView.layer.borderWidth = 1.0f;
//    self.containerView.layer.borderColor = [UIColor redColor].CGColor;
    

    //
    [self.containerView addSubview:self.toolbar];
//    self.toolbar.layer.borderWidth = 3.0f;
//    self.toolbar.layer.borderColor = [UIColor orangeColor].CGColor;


    //
    CGPoint pickerViewCenter = self.pickerView.center;
    pickerViewCenter.y += toolbarHeight;
    self.pickerView.center = pickerViewCenter;
    [self.containerView addSubview:self.pickerView];
    

    
    // debug purposes
//    self.view.layer.borderWidth = 3.0f;
//    self.view.layer.borderColor = [UIColor redColor].CGColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"here i am");
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"viewDidAppear");
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Accessors
- (UIView *)containerView
{
    if (!self->_containerView)
    {
        self->_containerView = [[UIView alloc] init];
    }
    
    return self->_containerView;
}

//- (UIImageView *)imageView
//{
//    if (!self->_imageView)
//    {
//        self->_imageView = [[UIImageView alloc] init];
////        self->_imageView.backgroundColor = [UIColor yellowColor];
//    }
//    
//    return self->_imageView;
//}


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
    return self.values[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.didSelectRowBlock) self.didSelectRowBlock(self, row);
}

#pragma mark - Public
- (void)showAnimated:(BOOL)animated
{
//    [viewController addChildViewController:self];
//    [viewController.view addSubview:self.view];
//    [self didMoveToParentViewController:viewController];
//
//    if (animated)
//    {
//        //
//        self.view.backgroundColor = [UIColor clearColor];
//        CGFloat offset = CGRectGetHeight(self.containerView.frame);
//        self.containerView.frame = CGRectOffset(self.containerView.frame, .0f, offset);
//        
//        //
//        [UIView animateWithDuration:kAnimationDuration animations:^{
//            self.view.backgroundColor = self.backgroundColor;
//            self.containerView.frame = CGRectOffset(self.containerView.frame, .0f, -offset);
//            
//        }];
//    }
    
//    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    self.oldWindow = [UIApplication sharedApplication].keyWindow;
    
//    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate date]];
    
    CGRect windowFrame = [UIScreen mainScreen].bounds;
    self.currentWindow = [[[UIWindow alloc] initWithFrame:windowFrame] autorelease];
//    self.currentWindow.alpha = .0f;
    self.currentWindow.windowLevel = UIWindowLevelNormal;//self.oldWindow.windowLevel + 1;
    self.currentWindow.rootViewController = self;
    [self.currentWindow makeKeyAndVisible];
    
//    UIGraphicsBeginImageContextWithOptions(self.oldWindow.bounds.size, YES, .0f);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [self.oldWindow.layer renderInContext:context];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();    
//    self.imageView.image = image;
    
    //
    self.view.backgroundColor = [UIColor clearColor];
    CGFloat offset = CGRectGetHeight(self.containerView.frame);
    self.containerView.frame = CGRectOffset(self.containerView.frame, .0f, offset);
    
    //
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.view.backgroundColor = [UIColor blackColor];//self.backgroundColor;
        self.containerView.frame = CGRectOffset(self.containerView.frame, .0f, -offset);
        
    }];

}

- (void)dismissAnimated:(BOOL)animated
{
    void (^completionBlock)() = ^(){
//        [self willMoveToParentViewController:nil];
//        [self.view removeFromSuperview];
//        [self removeFromParentViewController];
        
        [self.currentWindow resignKeyWindow];
        [self.oldWindow makeKeyAndVisible];
        self.currentWindow = nil;
    };
    
    if (!animated)
        completionBlock();
    else
    {
        CGFloat offset = CGRectGetHeight(self.containerView.frame);
        
        [UIView animateWithDuration:kAnimationDuration
                         animations:^{
                             self.containerView.frame = CGRectOffset(self.containerView.frame, .0f, offset);
                             self.view.backgroundColor = [UIColor clearColor];
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
