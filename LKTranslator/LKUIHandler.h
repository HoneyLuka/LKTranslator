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

@interface LKUIHandler : NSObject

@property (nonatomic, assign) LKUIHandlerStatus status;

- (void)showTranslateText:(NSString *)text;

@end
