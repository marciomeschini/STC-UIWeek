//
//  ViewController.m
//  Bubbles
//
//  Created by Marco Meschini on 06/04/2013.
//  Copyright (c) 2013 Marco Meschini. All rights reserved.
//

#import "ViewController.h"
#import "BubbleView.h"


@interface ViewController ()
@property (nonatomic, retain) BubbleView *bubbleView;

@end

@implementation ViewController

- (void)dealloc
{
    self.bubbleView = nil;
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    
    CGRect rect = (CGRect){10, 10, 300, 300};
    self.bubbleView = [[[BubbleView alloc] initWithFrame:rect] autorelease];
    [self.view addSubview:self.bubbleView];
    self.bubbleView.layer.borderWidth = 1.0f;
    
    
    BubbleView *oneMore = [[[BubbleView alloc] initWithFrame:CGRectMake(50, 340, 80, 80)] autorelease];
    oneMore.fillColor = [[UIColor blueColor] colorWithAlphaComponent:.5f];
    [self.view addSubview:oneMore];
    
    BubbleView *last = [[[BubbleView alloc] initWithFrame:CGRectMake(180, 320, 140, 140)] autorelease];
    last.fillColor = [[UIColor purpleColor] colorWithAlphaComponent:.75f];
    [self.view addSubview:last];
}

@end
