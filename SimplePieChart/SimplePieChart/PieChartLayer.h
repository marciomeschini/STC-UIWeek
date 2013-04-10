//
//  PieChartLayer.h
//  SimplePieChart
//
//  Created by Marco Meschini on 10/04/2013.
//  Copyright (c) 2013 Marco Meschini. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface PieChartLayer : CALayer

@property (nonatomic, assign) CGFloat progress;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
