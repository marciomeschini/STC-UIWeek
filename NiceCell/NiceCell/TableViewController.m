//
//  TableViewController.m
//  NiceCell
//
//  Created by Marco Meschini on 08/04/2013.
//  Copyright (c) 2013 Marco Meschini. All rights reserved.
//

#import "TableViewController.h"
#import "RistrettoUI.h"

@interface TableViewController ()
@end

@implementation TableViewController

- (void)loadView
{
    [super loadView];
    
    self.tableView.rowHeight = 50.0f;//kTableViewCellHeight
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];

        UIImageView *iv = [[UIImageView new] autorelease];
        iv.image = [self _backgroundImage];
        
        UIImageView *siv = [[UIImageView new] autorelease];
        siv.image = [self _selectedBackgroundImage];
        
        cell.backgroundView = iv;
        cell.selectedBackgroundView = siv;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    TableViewController *tvc = [[[TableViewController alloc] init] autorelease];
//    [self.navigationController pushViewController:tvc animated:YES];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UIImage *)_backgroundImage
{
    static dispatch_once_t onceToken;
    static UIImage *toReturn = nil;
    dispatch_once(&onceToken, ^{
        toReturn = [UIImage fwt_imageWithSize:CGSizeMake(1.0f, 50.0f) block:^(CGContextRef ctx) {
            
            CGRect rect = CGContextGetClipBoundingBox(ctx);
            
            CGRect bottomLine = rect;
            bottomLine.origin.y += CGRectGetHeight(bottomLine)-1.0f;
            bottomLine.size.height = 1.0f;

            [[UIColor colorWithWhite:.35f alpha:1.0f] setFill];
            UIRectFill(bottomLine);
            
            CGRect topLine = rect;
            topLine.size.height = 1.0f;
            [[UIColor colorWithWhite:.8f alpha:1.0f] setFill];
            UIRectFill(topLine);
        }];
    });
    
    return toReturn;
}

- (UIImage *)_selectedBackgroundImage
{
    __block typeof(UIImage) *_weakBackgroundImage = [self _backgroundImage];
    static dispatch_once_t onceToken;
    static UIImage *toReturn = nil;
    dispatch_once(&onceToken, ^{
        toReturn = [UIImage fwt_imageWithSize:CGSizeMake(1.0f, 50.0f) block:^(CGContextRef ctx) {
            
            CGRect rect = CGContextGetClipBoundingBox(ctx);
            
            [[[UIColor blackColor] colorWithAlphaComponent:.25f] setFill];
            UIRectFill(rect);
            
            [_weakBackgroundImage drawInRect:rect];
            
            //
            CGColorRef startColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:.9f].CGColor;
            CGColorRef endColor = [UIColor colorWithRed:.0 green:.0 blue:.0 alpha:.0f].CGColor;
            NSArray *colors = [NSArray arrayWithObjects:(id)startColor, (id)endColor, nil];
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef _glossGradientRef = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, NULL);
            CGColorSpaceRelease(colorSpace);
            
            //
            CGFloat gradientHeight = 6.0f;
            CGRect gradientRect = rect;
            gradientRect.size.height = gradientHeight;
            
            CGPoint startPoint = (CGPoint){CGRectGetMinX(gradientRect), CGRectGetMinY(gradientRect)};
            CGPoint endPoint = (CGPoint){CGRectGetMinX(gradientRect), CGRectGetMaxY(gradientRect)};
            CGContextDrawLinearGradient(ctx, _glossGradientRef, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
            
            gradientRect = rect;
            gradientRect.origin.y += (CGRectGetHeight(gradientRect)-gradientHeight);
            gradientRect.size.height = gradientHeight;
            
            startPoint = (CGPoint){CGRectGetMinX(gradientRect), CGRectGetMinY(gradientRect)};
            endPoint = (CGPoint){CGRectGetMinX(gradientRect), CGRectGetMaxY(gradientRect)};
            
            CGContextSetAlpha(ctx, .2f);
            CGContextDrawLinearGradient(ctx, _glossGradientRef, endPoint, startPoint, kCGGradientDrawsAfterEndLocation);
        }];
    });
    
    return toReturn;
}

@end
