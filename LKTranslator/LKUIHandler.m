//
//  LKUIHandler.m
//  LKTranslator
//
//  Created by Luka Li on 2017/12/21.
//  Copyright © 2017年 Luka Li. All rights reserved.
//

#import "LKUIHandler.h"
#import "LKPopoverViewController.h"
#import "LKTextInputViewController.h"

@interface LKUIHandler () <NSPopoverDelegate>

@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSProgressIndicator *progressIndicator;

@property (nonatomic, strong) LKPopoverViewController *popViewController;
@property (nonatomic, strong) NSPopover *popover;

@property (nonatomic, strong) LKTextInputViewController *inputViewController;

@end

@implementation LKUIHandler

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.statusItem = [[NSStatusBar systemStatusBar]statusItemWithLength:25];
    self.statusItem.button.target = self;
    self.statusItem.button.action = @selector(onStatusItemClick:);
    [self.statusItem.button sendActionOn:NSEventMaskLeftMouseUp | NSEventMaskRightMouseUp];
    
    NSProgressIndicator *indicator = [[NSProgressIndicator alloc]init];
    indicator.style = NSProgressIndicatorStyleSpinning;
    indicator.controlSize = NSControlSizeSmall;
    indicator.displayedWhenStopped = NO;
    [self.statusItem.button addSubview:indicator];
    indicator.frame = self.statusItem.button.bounds;
    self.progressIndicator = indicator;
    
    self.popover = [[NSPopover alloc]init];
    self.popover.delegate = self;
    self.popover.animates = NO;
    self.popover.behavior = NSPopoverBehaviorTransient;
    self.popover.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
    
    self.popViewController = [[LKPopoverViewController alloc]initWithNibName:NSStringFromClass(LKPopoverViewController.class)
                                                                      bundle:nil];
    [self.popViewController view];
    self.popover.contentViewController = self.popViewController;
    
    self.inputViewController = [[LKTextInputViewController alloc]init];
    
    __weak typeof(self) weakSelf = self;
    self.inputViewController.callback = ^(NSString *text) {
        if ([weakSelf.delegate respondsToSelector:@selector(UIHandler:didEnterText:)]) {
            [weakSelf.delegate UIHandler:weakSelf didEnterText:text];
        }
    };
    [self.inputViewController view];
    
    self.status = LKUIHandlerStatusIdle;
}

- (void)setStatus:(LKUIHandlerStatus)status
{
    _status = status;
    switch (status) {
        case LKUIHandlerStatusIdle:
            [self changeToIdle];
            break;
        case LKUIHandlerStatusProcessing:
            [self changeToProcessing];
            break;
        case LKUIHandlerStatusError:
            [self changeToError];
            break;
        default:
            break;
    }
}

- (void)changeToIdle
{
    self.statusItem.button.title = @"^_^";
    [self.progressIndicator stopAnimation:nil];
}

- (void)changeToProcessing
{
    self.statusItem.button.title = @"";
    [self.progressIndicator startAnimation:nil];
}

- (void)changeToError
{
    self.statusItem.button.title = @"x_x";
    [self.progressIndicator stopAnimation:nil];
}

- (void)showTranslateText:(NSString *)text
{
    [self.popViewController setTranslateText:text];
    
    NSSize size = [self.popViewController.label fittingSize];
    size.width += kLKPopoverViewControllerContentPadding * 2;
    size.height += kLKPopoverViewControllerContentPadding * 2;
    
    self.popover.contentViewController = self.popViewController;
    self.popover.contentSize = size;
    
    [self.popover showRelativeToRect:self.statusItem.button.bounds
                              ofView:self.statusItem.button
                       preferredEdge:NSRectEdgeMaxY];
    
    [[NSApplication sharedApplication]activateIgnoringOtherApps:YES];
}

- (void)showTextInputView
{
    self.popover.contentViewController = self.inputViewController;
    NSSize size = NSMakeSize(250, 48);
    self.popover.contentSize = size;
    [self.popover showRelativeToRect:self.statusItem.button.bounds
                              ofView:self.statusItem.button
                       preferredEdge:NSRectEdgeMaxY];
    [[NSApplication sharedApplication]activateIgnoringOtherApps:YES];
}

#pragma mark - Action

- (void)onStatusItemRightClick
{
    NSString *name = [NSBundle mainBundle].infoDictionary[@"CFBundleExecutable"];
    NSMenu *menu = [[NSMenu alloc]initWithTitle:name];
    NSMenuItem *quitItem = [menu addItemWithTitle:@"Quit"
                                           action:@selector(onQuitMenuButtonClick)
                                    keyEquivalent:@""];
    quitItem.target = self;
    
    self.statusItem.menu = menu;
    [self.statusItem popUpStatusItemMenu:menu];
    self.statusItem.menu = nil;
}

- (void)onStatusItemLeftClick
{
    [self showTextInputView];
}

- (void)onStatusItemClick:(NSStatusBarButton *)sender
{
    if (NSApp.currentEvent.type == NSEventTypeLeftMouseUp) {
        [self onStatusItemLeftClick];
    } else if (NSApp.currentEvent.type == NSEventTypeRightMouseUp) {
        [self onStatusItemRightClick];
    }
}

- (void)onQuitMenuButtonClick
{
    [[NSApplication sharedApplication]terminate:nil];
}

#pragma mark - NSPopoverDelegate

- (void)popoverWillClose:(NSNotification *)notification
{
    [[NSApplication sharedApplication]hide:nil];
}

@end
