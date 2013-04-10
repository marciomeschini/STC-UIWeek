//
//  ViewController.m
//  SimplePieChart
//
//  Created by Marco Meschini on 09/04/2013.
//  Copyright (c) 2013 Marco Meschini. All rights reserved.
//

#import "ViewController.h"

@interface PieChartLayer : CALayer
// public API
@property (nonatomic, assign) CGFloat progress;
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;


// private later
@property (nonatomic, assign) CGFloat startAngle, endAngle;
@property (nonatomic, assign) CGFloat radius;


@end

@implementation PieChartLayer
@dynamic endAngle;

- (id)init
{
    if (self = [super init])
    {
        self.startAngle = 3 * M_PI_2;
        self.endAngle = 3 * M_PI_2;
    }
    return self;
}

- (id)initWithLayer:(id)layer
{
    if ((self = [super initWithLayer:layer]))
    {
        PieChartLayer *source = (PieChartLayer *)layer;
        self.startAngle = source.startAngle;
        self.endAngle = source.endAngle;
        self.radius = source.radius;
    }
    
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString*)key {
    if ([key isEqualToString:@"endAngle"]) {
        return YES;
    } else {
        return [super needsDisplayForKey:key];
    }
}

- (id<CAAction>)actionForKey:(NSString *)key
{
    if ([key isEqualToString:@"endAngle"])
    {
        CABasicAnimation *toReturn = [CABasicAnimation animationWithKeyPath:key];
        toReturn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        toReturn.duration = 1.0f;
        toReturn.fromValue = [self.presentationLayer valueForKey:key];
        return toReturn;
    }
    else
    {
        return [super actionForKey:key];
    }
}

- (void)drawInContext:(CGContextRef)ctx
{
    UIBezierPath *bezierPath = [self _getEllipsePath];

    CGContextAddPath(ctx, bezierPath.CGPath);
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextFillPath(ctx);
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
    if (self->_progress != progress)
    {
        self->_progress = progress;
        
        if (!animated)
        {
            [CATransaction begin];
            [CATransaction setDisableActions:YES];
        }
        
        self.endAngle = 2 * M_PI * self->_progress + self.startAngle;
        
        if (!animated)
            [CATransaction commit];
    }
}

- (UIBezierPath *)_getEllipsePath
{
    if (self.startAngle == self.endAngle) return nil;
    
    self.radius = CGRectGetWidth(self.bounds)*.5f - 4.0f;
    
    int clockwise = self.startAngle < self.endAngle;
    CGPoint ellipseCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGPoint p1 = ellipseCenter;
    p1.x += self.radius * cosf(self.startAngle);
    p1.y += self.radius * sinf(self.startAngle);
    UIBezierPath *toReturn = [UIBezierPath bezierPath];
    [toReturn moveToPoint:ellipseCenter];
    [toReturn addLineToPoint:p1];
    [toReturn addArcWithCenter:ellipseCenter
                        radius:self.radius
                    startAngle:self.startAngle
                      endAngle:self.endAngle
                     clockwise:clockwise];
    [toReturn closePath];
    return toReturn;
}

@end

@interface ViewController ()
@property (nonatomic, retain) PieChartLayer *myLayer;
@property (nonatomic, retain) UIView *myView;

@end

@implementation ViewController

- (void)loadView
{
    [super loadView];
    
    self.myLayer = [PieChartLayer layer];
//    self.myLayer.backgroundColor = [UIColor redColor].CGColor;
    self.myLayer.frame = (CGRect){10, 10, 200, 200};
    self.myLayer.borderWidth = 1.0f;
    self.myLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.view.layer addSublayer:self.myLayer];
    
//    self.myView = [[[UIView alloc] initWithFrame:(CGRect){100, 100, 100, 100}] autorelease];
//    self.myView.layer.borderColor = [UIColor redColor].CGColor;
//    self.myView.layer.borderWidth = 1.0f;
//    [self.view addSubview:self.myView];
    
    
    CGRect sliderFrame = (CGRect){10, 400, 300, 30};
    UISlider *slider = [[[UISlider alloc] initWithFrame:sliderFrame] autorelease];
    slider.continuous = NO;
    [slider addTarget:self action:@selector(_sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    
//    self.myLayer.radius = 10.0f;
//    [self.myLayer setNeedsDisplay];
    
    
//    self.myLayer.actions = @{@"position": [NSNull null]};
}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    CGPoint point = [[touches anyObject] locationInView:self.view];
//    
////    self.myView.layer.position = point;
//    
////    [CATransaction begin];
////    [CATransaction setDisableActions:YES];
////     NSNumber *myNumber = @111;
////    
////    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
////    animation.duration = 1.0f;
////    animation.toValue = [NSValue valueWithCGPoint:point];
////    [animation setValue:myNumber forKey:@"key"];
////    animation.delegate = self;
//////    animation.removedOnCompletion = NO;
//////    animation.fillMode = kCAFillModeForwards;
////    [self.myLayer addAnimation:animation forKey:@"myKey"];
//    
//   
//    
////    [CATransaction begin];
////    [CATransaction setValue:myNumber forKey:@"theKey"];
////    self.myLayer.position = point;
////    [CATransaction commit];
//    
//    
////    self.myLayer.position = point;
////    [CATransaction commit];
//    
////    [UIView animateWithDuration:.25f animations:^{
////        self.myView.center = point;
////    }];
////    
////    [UIView beginAnimations:nil context:NULL];
////    [UIView setAnimationDuration:.5f];
////    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
////    self.myView.center = point;
////    [UIView commitAnimations];
//}

//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
//{
//    NSLog(@"-->%@", [anim valueForKey:@"key"]);
//}

- (void)_sliderValueDidChange:(UISlider *)slider
{
    NSLog(@"slider update");
    [self.myLayer setProgress:slider.value animated:YES];
//    CGFloat diameter = CGRectGetWidth(self.myLayer.bounds)-4.0f;
//    self.myLayer.radius = diameter*.5f*slider.value;
}

@end
