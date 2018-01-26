//
//  LKPopoverViewController.h
//  LKTranslator
//
//  Created by Luka Li on 2017/12/19.
//  Copyright © 2017年 Luka Li. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern const CGFloat kLKPopoverViewControllerContentPadding;

@interface LKPopoverViewController : NSViewController

@property (nonatomic, strong) IBOutlet NSTextField *label;

- (void)setTranslateText:(NSString *)text;

@end
