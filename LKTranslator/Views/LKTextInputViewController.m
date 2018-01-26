//
//  LKTextInputViewController.m
//  LKTranslator
//
//  Created by Luka Li on 25/1/2018.
//  Copyright © 2018 Luka Li. All rights reserved.
//

#import "LKTextInputViewController.h"
#import <Carbon/Carbon.h>

@interface LKTextInputViewController () <NSTextFieldDelegate>

@property (nonatomic, strong) IBOutlet NSTextField *textField;

@end

@implementation LKTextInputViewController
{
    BOOL _commandPressed;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
}

- (BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector
{
    if (commandSelector == @selector(insertNewline:)) {
        if (self.textField.stringValue.length) {
            self.callback ? self.callback(self.textField.stringValue) : nil;
        }
        return YES;
    }

    return NO;
}

@end
