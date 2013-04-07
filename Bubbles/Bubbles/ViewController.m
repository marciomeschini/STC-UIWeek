//
//  ViewController.m
//  Bubbles
//
//  Created by Marco Meschini on 06/04/2013.
//  Copyright (c) 2013 Marco Meschini. All rights reserved.
//

#import "ViewController.h"
#import "BubbleView.h"
#import "TextBubbleView.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)loadView
{
    [super loadView];
    
    
    //
    CGRect rect = (CGRect){10, 10, 300, 300};
    TextBubbleView *bubbleView = [[[TextBubbleView alloc] initWithFrame:rect] autorelease];
    bubbleView.mainLabel.text = @"Hello world!";
    bubbleView.mainLabel.font = [UIFont boldSystemFontOfSize:100];
    bubbleView.mainLabel.textColor = [UIColor whiteColor];
    bubbleView.mainLabel.shadowColor = [UIColor blackColor];
    bubbleView.mainLabel.shadowOffset = CGSizeMake(.0f, -1.0f);
    [self.view addSubview:bubbleView];
    
    //
    TextBubbleView *oneMore = [[[TextBubbleView alloc] initWithFrame:CGRectMake(50, 340, 80, 80)] autorelease];
    oneMore.fillColor = [[UIColor blueColor] colorWithAlphaComponent:.3f];
    oneMore.mainLabel.text = @"A very long text";
    oneMore.mainLabel.font = [UIFont boldSystemFontOfSize:100];
    oneMore.mainLabel.textColor = [UIColor whiteColor];
    oneMore.mainLabel.shadowColor = [UIColor blackColor];
    oneMore.mainLabel.shadowOffset = CGSizeMake(.0f, -1.0f);
    [self.view addSubview:oneMore];
    
    //
    TextBubbleView *last = [[[TextBubbleView alloc] initWithFrame:CGRectMake(180, 320, 140, 140)] autorelease];
    last.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:.6f];
    last.mainLabel.text = @"6,956";
    last.mainLabel.font = [UIFont boldSystemFontOfSize:100];
    last.mainLabel.textColor = [UIColor whiteColor];
    last.mainLabel.shadowColor = [UIColor blackColor];
    last.mainLabel.shadowOffset = CGSizeMake(.0f, -1.0f);
    [self.view addSubview:last];
}

@end
