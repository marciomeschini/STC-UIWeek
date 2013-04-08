//
//  TextBubbleView.h
//  Bubbles
//
//  Created by Marco Meschini on 07/04/2013.
//  Copyright (c) 2013 Marco Meschini. All rights reserved.
//

#import "BubbleView.h"

// Please when you access and change some properties of the mainLabel
// invoke then a setNeedsDisplay
@interface TextBubbleView : BubbleView

@property (nonatomic, readonly, retain) UILabel *headerLabel;
@property (nonatomic, readonly, retain) UILabel *mainLabel;
@property (nonatomic, assign) CGFloat inset;
@end
