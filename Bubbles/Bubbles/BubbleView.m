//
//  BubbleView.m
//  Bubbles
//
//  Created by Marco Meschini on 06/04/2013.
//  Copyright (c) 2013 Marco Meschini. All rights reserved.
//

#import "BubbleView.h"

@interface BubbleView ()
@property (nonatomic, assign) CGFloat diameter;
@property (nonatomic) CGGradientRef glossGradientRef, bottomRadialGradientRef, borderRadialGradientRef;
@property (nonatomic, retain) CAShapeLayer *shapeLayer;
@end

@implementation BubbleView

- (void)dealloc
{
    self.fillColor = nil;
    self.shapeLayer = nil;
    CGGradientRelease(self.borderRadialGradientRef);
    self.borderRadialGradientRef = nil;
    CGGradientRelease(self.bottomRadialGradientRef);
    self.bottomRadialGradientRef = nil;
    CGGradientRelease(self.glossGradientRef);
    self.glossGradientRef = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        
        //
        self.layer.shadowOpacity = .65f;
        self.layer.shadowOffset = (CGSize){.0f, 5.0f};
        self.layer.shadowRadius = 20.0f;
        
        self.fillColor = [[UIColor greenColor] colorWithAlphaComponent:.4f];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [self _updatePath];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //
    CGContextSaveGState(ctx);
    
    //
    CGContextSaveGState(ctx);
    CGContextSetBlendMode(ctx, kCGBlendModeCopy);
    self.shapeLayer.fillColor = self.fillColor.CGColor;
    [self.shapeLayer drawInContext:ctx];
    CGContextRestoreGState(ctx);
    
    //
    CGContextAddPath(ctx, self.shapeLayer.path);
    CGContextClip(ctx);

    //
    [self _drawGlossGradientInContext:ctx rect:rect];

    //
    [self _drawBorderGradientInContext:ctx rect:rect];
    
    //
    [self _drawBottomGradientInContext:ctx rect:rect];
    
//    CGContextRestoreGState(ctx);
    
    //
    CGContextSetShadowWithColor(ctx, CGSizeMake(.0f, 2.0f), 2.0f, [[UIColor whiteColor] colorWithAlphaComponent:.45f].CGColor);
    UIBezierPath *bp = [UIBezierPath bezierPathWithCGPath:self.shapeLayer.path];
    [bp appendPath:[UIBezierPath bezierPathWithRect:rect]];
    bp.usesEvenOddFillRule = YES;
    [bp fill];
}

#pragma mark - Private
- (void)_updatePath
{
    if (CGRectEqualToRect(self.bounds, CGRectZero))
        self.shapeLayer.path = nil;
    else
    {
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat height = CGRectGetHeight(self.bounds);
        self.diameter = MIN(width, height);
        
        // center the circle inside our bounds
        CGRect bezierRect = (CGRect){(width-self.diameter)*.5f, (height-self.diameter)*.5f, self.diameter, self.diameter};
        
        // reduce our circle size by lineWidth
        bezierRect = CGRectInset(bezierRect, self.shapeLayer.lineWidth, self.shapeLayer.lineWidth);
        self.shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:bezierRect].CGPath;
        
        // update also the shadow
        CGFloat shadowSideRatio = .63f;
        CGFloat shadowSide = self.diameter*shadowSideRatio;
        CGRect shadowRect = (CGRect){(self.diameter-shadowSide)*.5f, self.diameter-shadowSide*.65f, shadowSide, shadowSide};
        self.layer.shadowPath = [UIBezierPath bezierPathWithOvalInRect:shadowRect].CGPath;
    }
}

- (void)_drawGlossGradientInContext:(CGContextRef)context rect:(CGRect)rect
{
    CGContextSaveGState(context);
    
    //
    CGMutablePathRef glossPath = CGPathCreateMutable();
    CGPathMoveToPoint(glossPath, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect)-self.diameter+rect.size.height/2);
	CGPathAddArc(glossPath, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect)-self.diameter+rect.size.height/2, self.diameter, 0.75f*M_PI, 0.25f*M_PI, YES);
	CGPathCloseSubpath(glossPath);
	CGContextAddPath(context, glossPath);
	CGContextClip(context);
    CGPathRelease(glossPath);
    
    //
	CGRect halfRect = rect;
    halfRect.size.height *= .5f;
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(halfRect), CGRectGetMinY(halfRect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(halfRect), CGRectGetMaxY(halfRect));
    
    CGContextSaveGState(context);
    CGContextDrawLinearGradient(context, self.glossGradientRef, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
    CGContextRestoreGState(context);
    
    CGContextRestoreGState(context);
}

- (void)_drawBottomGradientInContext:(CGContextRef)context rect:(CGRect)rect
{
    CGContextSaveGState(context);
//    CGContextSetAlpha(context, .2f);
    
    
    CGFloat endRadiusRatio = .5f;
    CGFloat startRadius = .0f;
    CGFloat endRadius = self.diameter*endRadiusRatio;
    CGPoint start, end;
    start = end = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGContextDrawRadialGradient(context, self.bottomRadialGradientRef, start, startRadius, end, endRadius, kCGGradientDrawsAfterEndLocation);
    
//    start = end = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect)-CGRectGetHeight(rect));
//    CGContextSetAlpha(context, .2f);
//    CGContextDrawRadialGradient(context, self.bottomRadialGradientRef, start, startRadius, end, endRadius, kCGGradientDrawsAfterEndLocation);
    
    CGContextRestoreGState(context);
}

- (void)_drawBorderGradientInContext:(CGContextRef)context rect:(CGRect)rect
{
    CGContextSaveGState(context);
//    CGContextSetAlpha(context, .2f);
    
    CGFloat thickness = 12.0f;
    CGFloat radius = self.diameter*.5f;
    CGFloat startRadius = radius;
    CGFloat endRadius = radius-thickness;
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGContextDrawRadialGradient(context, self.borderRadialGradientRef, center, startRadius, center, endRadius, kCGGradientDrawsBeforeStartLocation);
    
    CGContextRestoreGState(context);
}

#pragma mark - UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    [UIView animateWithDuration:.2f animations:^{
       self.transform = CGAffineTransformMakeScale(.925f, .925f);
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [UIView animateWithDuration:.15f animations:^{
            self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        }];
    }];
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:.925f], [NSNumber numberWithFloat:1.05f],
                              [NSNumber numberWithFloat:.935f],  nil];
    
    bounceAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    bounceAnimation.duration = .15f;
    bounceAnimation.delegate = self;
    [self.layer addAnimation:bounceAnimation forKey:@"bounce"];
    [CATransaction commit];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    [UIView animateWithDuration:.2f animations:^{
        self.transform = CGAffineTransformMakeScale(.925f, .925f);
    }];
}

#pragma mark - Accessors
- (CGGradientRef)glossGradientRef
{
    if (!self->_glossGradientRef)
    {
        CGColorRef startColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.6].CGColor;
        CGColorRef endColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.1].CGColor;
        NSArray *colors = [NSArray arrayWithObjects:(id)startColor, (id)endColor, nil];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        self->_glossGradientRef = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, NULL);
        CGColorSpaceRelease(colorSpace);
    }
    
    return self->_glossGradientRef;
}

- (CGGradientRef)bottomRadialGradientRef
{
    if (!self->_bottomRadialGradientRef)
    {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        UIColor *colorBottom = self.fillColor;
        UIColor *colorTop = nil;
        CGFloat r = .0f, g = .0f, b = .0f, a = .0f;
        BOOL result = [colorBottom getRed:&r green:&g blue:&b alpha:&a];
        if (result) colorTop = [UIColor colorWithRed:r green:g blue:b alpha:1.0f];
        else colorTop = colorBottom;
        NSArray *array = @[(id)colorTop.CGColor, (id)colorBottom.CGColor];
        self->_bottomRadialGradientRef = CGGradientCreateWithColors(colorSpace, (CFArrayRef)array, NULL);
        CGColorSpaceRelease(colorSpace);
    }
    
    return self->_bottomRadialGradientRef;
}

- (CGGradientRef)borderRadialGradientRef
{
    if (!self->_borderRadialGradientRef)
    {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        UIColor *fillColor = self.fillColor;
        UIColor *outerColor = nil;
        UIColor *innerColor = nil;
        CGFloat r = .0f, g = .0f, b = .0f, a = .0f;
        BOOL result = [fillColor getRed:&r green:&g blue:&b alpha:&a];
        if (result)
        {
            CGFloat factor = .375f;
            outerColor = [fillColor colorWithAlphaComponent:a*factor];
            innerColor = [fillColor colorWithAlphaComponent:.0f];
        }
        else
        {
            outerColor = fillColor;
            innerColor = fillColor;
        }
        
        
        NSArray *array = @[(id)outerColor.CGColor, (id)innerColor.CGColor];
        self->_borderRadialGradientRef = CGGradientCreateWithColors(colorSpace, (CFArrayRef)array, NULL);
        CGColorSpaceRelease(colorSpace);
    }
    
    return self->_borderRadialGradientRef;
}

- (CAShapeLayer *)shapeLayer
{
    if (!self->_shapeLayer)
    {
        self->_shapeLayer = [[CAShapeLayer alloc] init];
        self->_shapeLayer.lineWidth = 2.0f;
    }
    
    return self->_shapeLayer;
}

#pragma mark - Public




@end
