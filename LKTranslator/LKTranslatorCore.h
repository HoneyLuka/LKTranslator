//
//  LKTranslatorCore.h
//  LKTranslator
//
//  Created by Luka Li on 2017/12/20.
//  Copyright © 2017年 Luka Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface LKTranslatorCore : NSObject

- (void)applicationWillTerminate;

+ (instancetype)sharedCore;

@end
