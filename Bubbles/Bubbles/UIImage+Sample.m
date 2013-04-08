//
//  UIImage+Sample.m
//  Bubbles
//
//  Created by Marco Meschini on 07/04/2013.
//  Copyright (c) 2013 Marco Meschini. All rights reserved.
//

#import "UIImage+Sample.h"

@implementation UIImage (Sample)

+ (UIImage *)stc_navigationBarImage
{
    UIImage *di = [UIImage fwt_imageWithSize:CGSizeMake(1, 44)
                                       block:^(CGContextRef ctx) {
                                           CGRect rect = CGContextGetClipBoundingBox(ctx);
                                           
                                           [[UIColor colorWithRed:1 green:.0f blue:.0f alpha:1.0f] setFill];
                                           UIRectFill(rect);
                                           
                                           CGRect line = rect;
                                           line.origin.y += (CGRectGetHeight(line) - 2.0f);
                                           line.size.height = 2.0f;
                                           
                                           [[UIColor colorWithRed:.85f green:.0f blue:.0f alpha:1.0f] setFill];
                                           UIRectFill(line);
                                           
                                           CGRect gRect = rect;
                                           CGPoint startPoint = CGPointMake(CGRectGetMidX(gRect), CGRectGetMinY(gRect));
                                           CGPoint endPoint = CGPointMake(CGRectGetMidX(gRect), CGRectGetMaxY(gRect));
                                           
                                           CGColorRef startColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.6].CGColor;
                                           CGColorRef endColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:.1].CGColor;
                                           NSArray *colors = [NSArray arrayWithObjects:(id)startColor, (id)endColor, nil];
                                           CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                                           CGGradientRef _glossGradientRef = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, NULL);
                                           CGColorSpaceRelease(colorSpace);
                                           
                                           CGContextDrawLinearGradient(ctx, _glossGradientRef, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);
                                           CGGradientRelease(_glossGradientRef);
                                       }];

    return di;
}

@end
