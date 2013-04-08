//
//  TextBubbleView.m
//  Bubbles
//
//  Created by Marco Meschini on 07/04/2013.
//  Copyright (c) 2013 Marco Meschini. All rights reserved.
//

#import "TextBubbleView.h"

@interface BubbleView (Private)
@property (nonatomic, retain) CAShapeLayer *shapeLayer;
@end

@interface TextBubbleView ()

@property (nonatomic, readwrite, retain) UILabel *headerLabel;
@property (nonatomic, readwrite, retain) UILabel *mainLabel;
@property (nonatomic, retain) UIFont *mainLabelFont;

@end


@implementation TextBubbleView

- (void)dealloc
{
    self.mainLabelFont = nil;
    
    // destroy only if it was created
    if (self->_headerLabel) self.headerLabel = nil;
    
    // estroy only if it was created
    if (self->_mainLabel) self.mainLabel = nil;
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // do layout only if it's there
    if (self->_headerLabel)
    {
        if (!self.headerLabel.superview) [self addSubview:self.headerLabel];
        
        self.headerLabel.layer.borderWidth = 1.0f;
    }
    
    [self _layoutMainLabel];
}

#pragma mark - Private layouts
- (void)_layoutMainLabel
{
    // do layout only if it's there
    if (self->_mainLabel)
    {
        if (!self.mainLabel.superview) [self addSubview:self.mainLabel];
        
        //
        if (!self.mainLabelFont) self.mainLabelFont = self.mainLabel.font;
        
        //
        CGFloat horizontalInset = MAX(self.shapeLayer.lineWidth*2.0f, 5.0f);
        CGRect mainLabelFrame = self.bounds;
        mainLabelFrame.size.height *= 1.0f/3.0f;
        mainLabelFrame = CGRectInset(mainLabelFrame, horizontalInset, .0f);
        
        
        
        // sadly it seems there's a bug with the Apple sizeWithFont: minFontSize: ...
        // The size returned by this methos has the correct width, but the height does not account for the actual font size.
        // see http://stackoverflow.com/a/7243465/143000
        //
        CGFloat minimumFontSize = 10.0f;
        CGFloat actualFontSize;//= minimumFontSize;
        [self.mainLabel.text sizeWithFont:self.mainLabel.font
                              minFontSize:minimumFontSize
                           actualFontSize:&actualFontSize
                                 forWidth:CGRectGetWidth(mainLabelFrame)
                            lineBreakMode:NSLineBreakByWordWrapping];
        
        UIFont *actualFont = [UIFont fontWithName:self.mainLabel.font.fontName size:actualFontSize];
        CGSize sizeWithCorrectHeight = [self.mainLabel.text sizeWithFont:actualFont];
        mainLabelFrame.size.height = sizeWithCorrectHeight.height;
        mainLabelFrame.origin.y += (CGRectGetHeight(self.bounds)-CGRectGetHeight(mainLabelFrame))*.5f;
        self.mainLabel.frame = mainLabelFrame;
        self.mainLabel.font = actualFont;        
    }
}

#pragma mark - Accessors
- (UILabel *)headerLabel
{
    if (!self->_headerLabel)
    {
        self->_headerLabel = [[UILabel alloc] init];
        
    }
    
    return self->_headerLabel;
}

- (UILabel *)mainLabel
{
    if (!self->_mainLabel)
    {
        self->_mainLabel = [[UILabel alloc] init];
        self->_mainLabel.textAlignment = NSTextAlignmentCenter;
        self->_mainLabel.backgroundColor = [UIColor clearColor];
        self->_mainLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    return self->_mainLabel;
}

@end
