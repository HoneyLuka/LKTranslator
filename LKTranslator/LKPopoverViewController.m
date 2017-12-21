//
//  LKPopoverViewController.m
//  LKTranslator
//
//  Created by Luka Li on 2017/12/19.
//  Copyright © 2017年 Luka Li. All rights reserved.
//

#import "LKPopoverViewController.h"

const CGFloat kLKPopoverViewControllerContentPadding = 12;

@interface LKPopoverViewController ()

@end

@implementation LKPopoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setTranslateText:(NSString *)text
{
    [self.label setStringValue:text];
}

@end
