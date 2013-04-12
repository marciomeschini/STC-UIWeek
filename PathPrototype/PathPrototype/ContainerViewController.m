//
//  ContainerViewController.m
//  PathPrototype
//
//  Created by Marco Meschini on 10/04/2013.
//  Copyright (c) 2013 Marco Meschini. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()
@property (nonatomic, retain) UIViewController *viewControllerB;
@property (nonatomic, retain) UIViewController *viewControllerA;
@property (nonatomic, retain) UIViewController *viewControllerC;
@property (nonatomic, retain) UIViewController *bottomViewController;

@end

@implementation ContainerViewController

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    
    self.viewControllerB = [[[UIViewController alloc] init] autorelease];
    self.viewControllerA = [[[UIViewController alloc] init] autorelease];
    self.viewControllerA.view.backgroundColor = [UIColor yellowColor];
    self.viewControllerC = [[[UIViewController alloc] init] autorelease];
    self.viewControllerC.view.backgroundColor = [UIColor purpleColor];
    
    [self addChildViewController:self.viewControllerA];
    self.viewControllerA.view.frame = self.view.bounds;
    self.viewControllerA.view.hidden = YES;
    [self.view addSubview:self.viewControllerA.view];
    [self.viewControllerA didMoveToParentViewController:self];
    
    [self addChildViewController:self.viewControllerC];
    self.viewControllerC.view.frame = self.view.bounds;
    self.viewControllerC.view.hidden = YES;
    [self.view addSubview:self.viewControllerC.view];
    [self.viewControllerC didMoveToParentViewController:self];
    
    
    [self addChildViewController:self.viewControllerB];
    self.viewControllerB.view.frame = self.view.bounds;
    [self.view addSubview:self.viewControllerB.view];
    [self.viewControllerB didMoveToParentViewController:self];

    //
    self.viewControllerB.view.backgroundColor = [UIColor orangeColor];
    self.viewControllerB.view.layer.borderWidth = 10.0f;
    self.viewControllerB.view.layer.borderColor = [UIColor blueColor].CGColor;
    
    
    UIPanGestureRecognizer *panGesture = [[[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(_handleGesture:)]autorelease];
    [self.view addGestureRecognizer:panGesture];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
// 
////    CGPoint point = 
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesMoved:touches withEvent:event];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesEnded:touches withEvent:event];
//}

- (void)_handleGesture:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:gesture.view];
    [gesture setTranslation:CGPointZero inView:gesture.view];
 
    switch (gesture.state)
    {
        case UIGestureRecognizerStateBegan:
            [self _updateBottomViewControllerWithTranslationOnX:translation.x];
            break;
    
        case UIGestureRecognizerStateChanged:
            [self _updateBottomViewControllerWithTranslationOnX:translation.x];
            break;
            
        case UIGestureRecognizerStateEnded:
            [self _updateBottomViewControllerWithTranslationOnX:translation.x];
            break;
            
        default:
            break;
    }
    
    CGPoint center = self.viewControllerB.view.center;
    center.x += translation.x;
    self.viewControllerB.view.center = center;
}

#pragma mark - Private
- (void)_updateBottomViewControllerWithTranslationOnX:(CGFloat)x
{
//    if (self.bottomViewController)
//    {
//        [self.bottomViewController willMoveToParentViewController:nil];  // 1
//        [self.bottomViewController.view removeFromSuperview];            // 2
//        [self.bottomViewController removeFromParentViewController];      // 3
//        
//        self.bottomViewController = nil;
//    }
//    
//    if (x > 0)
//    {
//        self.bottomViewController = self.viewControllerA;
//    }
//    else
//    {
//        self.bottomViewController = self.viewControllerC;
//    }
//    
//    [self addChildViewController:self.bottomViewController];
//    self.bottomViewController.view.frame = self.view.bounds;
//    [self.view insertSubview:self.bottomViewController.view belowSubview:self.viewControllerB.view];
//    [self.bottomViewController didMoveToParentViewController:self];
    
    CGFloat centerX = self.view.center.x;
    CGFloat xB = self.viewControllerB.view.center.x;
    UIViewController *candidate = nil;
    if (xB > centerX)
    {
        NSLog(@"show A");
        candidate = self.viewControllerA;
    }
    else if (xB < centerX)
    {
        NSLog(@"show C");
        candidate = self.viewControllerC;
    }
    else
    {
        NSLog(@"here");
        self.bottomViewController.view.hidden = YES;
        self.bottomViewController = nil;
        
//        if (self.bottomViewController)
//        {
//            [self.bottomViewController willMoveToParentViewController:nil];  // 1
//            [self.bottomViewController.view removeFromSuperview];            // 2
//            [self.bottomViewController removeFromParentViewController];      // 3
//            
//            self.bottomViewController = nil;
//        }
    }
    
    if (candidate)
    {
        if (self.bottomViewController)
            self.bottomViewController.view.hidden = YES;
        
        candidate.view.hidden = NO;
        self.bottomViewController = candidate;
    }
    else
    {
        
    }
    
    // get the right one (candidate)
    // check if bottom != nil
    // if bottom == candidate nop
    // if bottom != candidate remove bottom and add candidate
    
//    if (self.bottomViewController == candidate)
//    {
//        // nop
//    }
//    else if (self.bottomViewController != candidate && candidate)
//    {
//        UIViewController *previous = self.bottomViewController;
//
//        //
//        self.bottomViewController = candidate;
//        [self addChildViewController:self.bottomViewController];
//        self.bottomViewController.view.frame = self.view.bounds;
//        [self.view insertSubview:self.bottomViewController.view belowSubview:self.viewControllerB.view];
//        [self.bottomViewController didMoveToParentViewController:self];
//
//        double delayInSeconds = .1  ;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            if (previous)
//            {
//                [previous willMoveToParentViewController:nil];  // 1
//                [previous.view removeFromSuperview];            // 2
//                [previous removeFromParentViewController];      // 3
//            }
//        });
//        
//
//        
//    }
    
    
}


@end
