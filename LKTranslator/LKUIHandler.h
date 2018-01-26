//
//  LKUIHandler.h
//  LKTranslator
//
//  Created by Luka Li on 2017/12/21.
//  Copyright © 2017年 Luka Li. All rights reserved.
//

#import <AppKit/AppKit.h>

typedef NS_ENUM(NSUInteger, LKUIHandlerStatus) {
    LKUIHandlerStatusIdle,
    LKUIHandlerStatusProcessing,
    LKUIHandlerStatusError,
};

@class LKUIHandler;
@protocol LKUIHandlerDelegate <NSObject>

@optional
- (void)UIHandler:(LKUIHandler *)handler didEnterText:(NSString *)text;

@end

@interface LKUIHandler : NSObject

@property (nonatomic, assign) LKUIHandlerStatus status;

@property (nonatomic, weak) id<LKUIHandlerDelegate> delegate;

- (void)showTranslateText:(NSString *)text;
- (void)showTextInputView;

@end
