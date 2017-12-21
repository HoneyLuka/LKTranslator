//
//  LKHotKeyObserver.h
//  LKTranslator
//
//  Created by Luka Li on 2017/12/20.
//  Copyright © 2017年 Luka Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LKHotKeyObserver;
@protocol LKHotKeyObserverDelegate <NSObject>

- (void)hotKeyObserverDidTriggerHotKey:(LKHotKeyObserver *)observer;

@end

@interface LKHotKeyObserver : NSObject

@property (nonatomic, weak) id<LKHotKeyObserverDelegate> delegate;

- (void)registerHotKey;
- (void)unRegisterHotKey;

@end
