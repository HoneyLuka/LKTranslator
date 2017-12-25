//
//  LKUIHandler.m
//  LKTranslator
//
//  Created by Luka Li on 2017/12/21.
//  Copyright © 2017年 Luka Li. All rights reserved.
//

#import "LKUIHandler.h"
#import "LKPopoverViewController.h"

@interface LKUIHandler () <NSPopoverDelegate>

@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSProgressIndicator *progressIndicator;

@property (nonatomic, strong) LKPopoverViewController *popViewController;
@property (nonatomic, strong) NSPopover *popover;

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
    self.popover.contentSize = size;
    
    [self.popover showRelativeToRect:self.statusItem.button.bounds
                              ofView:self.statusItem.button
                       preferredEdge:NSRectEdgeMaxY];
    
    [[NSApplication sharedApplication]activateIgnoringOtherApps:YES];
}

#pragma mark - Action

- (void)onStatusItemClick:(NSStatusBarButton *)sender
{
    NSString *name = [NSBundle mainBundle].infoDictionary[@"CFBundleExecutable"];
    NSMenu *menu = [[NSMenu alloc]initWithTitle:name];
    NSMenuItem *quitItem = [menu addItemWithTitle:@"Quit"
                                           action:@selector(onQuitMenuButtonClick)
                                    keyEquivalent:@""];
    quitItem.target = self;
    
    [menu popUpMenuPositioningItem:nil atLocation:NSMakePoint(0, -5) inView:sender.window.contentView];
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
