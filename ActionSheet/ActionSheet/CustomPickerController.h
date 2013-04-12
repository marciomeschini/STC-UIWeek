//
//  ViewController.h
//  ActionSheet
//
//  Created by Marco Meschini on 08/04/2013.
//  Copyright (c) 2013 Marco Meschini. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomPickerController;
typedef void(^CustomPickerControllerDidSelectRowBlock)(CustomPickerController *picker, NSInteger row);

@interface CustomPickerController : UIViewController

@property (nonatomic, retain) UIColor *backgroundColor;
@property (nonatomic, retain) NSArray *values; // please use only string values
@property (nonatomic, copy) CustomPickerControllerDidSelectRowBlock didSelectRowBlock;
@property (nonatomic, assign) UIInterfaceOrientation preferredInterfaceOrientation; // UIInterfaceOrientationMaskPortrait

@property (nonatomic, readonly, retain) UIPickerView *pickerView;

- (void)showAnimated:(BOOL)animated;
- (void)dismissAnimated:(BOOL)animated;

@end
