//
//  AppDelegate.m
//  LKTranslator
//
//  Created by Luka Li on 2017/12/18.
//  Copyright © 2017年 Luka Li. All rights reserved.
//

#import "AppDelegate.h"
#import "LKTranslatorCore.h"

@interface AppDelegate ()

@property (nonatomic, strong) IBOutlet NSMenuItem *quitItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [LKTranslatorCore sharedCore];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [[LKTranslatorCore sharedCore]applicationWillTerminate];
}

- (IBAction)onQuit:(id)sender {
    [[NSApplication sharedApplication]terminate:self];
}

@end
