//
//  LKCustomTextField.m
//  LKTranslator
//
//  Created by Luka Li on 26/1/2018.
//  Copyright © 2018 Luka Li. All rights reserved.
//

#import "LKCustomTextField.h"
#import <Carbon/Carbon.h>

@implementation LKCustomTextField

- (BOOL)performKeyEquivalent:(NSEvent *)event
{
    if (event.type == NSEventTypeKeyDown && (event.modifierFlags & NSEventModifierFlagCommand)) {
        NSResponder * responder = [[self window] firstResponder];
        if (![responder isKindOfClass:NSTextView.class]) {
            return NO;
        }
        
        BOOL handled = NO;
        
        if (event.keyCode == kVK_ANSI_A) {
            handled = YES;
            [self selectText:nil];
        }
        
        if (event.keyCode == kVK_ANSI_C) {
            handled = YES;
            NSString *string = self.stringValue;
            [[NSPasteboard generalPasteboard]clearContents];
            [[NSPasteboard generalPasteboard]writeObjects:@[string]];
        }
        
        if (event.keyCode == kVK_ANSI_V) {
            handled = YES;
            NSString *pasteboardString = [[NSPasteboard generalPasteboard]stringForType:NSPasteboardTypeString];
            if (!pasteboardString) {
                pasteboardString = @"";
            }
            
            NSString *currentString = self.stringValue;
            if (!currentString) {
                currentString = @"";
            }
            
            currentString = [currentString stringByAppendingString:pasteboardString];
            self.stringValue = currentString;
        }
        
        return handled;
    }
    
    return NO;
}

@end
