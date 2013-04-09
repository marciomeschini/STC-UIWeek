//
//  TableViewController.m
//  Bubbles
//
//  Created by Marco Meschini on 07/04/2013.
//  Copyright (c) 2013 Marco Meschini. All rights reserved.
//

#import "TableViewController.h"
#import "BubbleView.h"
#import "UIImage+Sample.h"

#pragma mark - UIColor (category)
@interface UIColor (TableViewController)
+ (UIColor *)stc_colorWithIndex:(NSInteger)index count:(NSInteger)count;
@end

@implementation UIColor (TableViewController)

+ (UIColor *)stc_colorWithIndex:(NSInteger)index count:(NSInteger)count
{
    static CGFloat saturation = 0.6, brightness = 0.7;
    UIColor *color = [UIColor colorWithHue:(CGFloat)index/count
                                saturation:saturation
                                brightness:brightness
                                     alpha:1.0];
    return color;
}

@end

#pragma mark - BubbleView (category)
@interface BubbleView (TableViewController)

- (UIImage *)imageWithFillColor:(UIColor *)fillColor;

@end

@implementation BubbleView (TableViewController)

- (UIImage *)imageWithFillColor:(UIColor *)fillColor
{
    self.fillColor = fillColor;
    return [UIImage fwt_imageWithSize:self.bounds.size
                                block:^(CGContextRef ctx) {
                                    [self.layer renderInContext:ctx];
                                }];
}

@end

#define COUNT 100

#pragma mark - TableViewController
@interface TableViewController ()
@property (nonatomic, retain) BubbleView *bubbleView;
@end

@implementation TableViewController

- (void)loadView
{
    [super loadView];
    
    self.tableView.rowHeight = 68.0f;
}

#pragma mark - Accessors
- (BubbleView *)bubbleView
{
    if (!self->_bubbleView)
    {
        CGRect rect = (CGRect){.0f, .0f, 48.0f, 48.0f};
        self->_bubbleView = [[BubbleView alloc] initWithFrame:rect];
    }
    
    return self->_bubbleView;
}

#pragma mark - TableView datasource/delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return COUNT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    UIColor *color = [UIColor stc_colorWithIndex:indexPath.row count:COUNT];
    cell.imageView.image = [self.bubbleView imageWithFillColor:color];
    return cell;
}


@end
