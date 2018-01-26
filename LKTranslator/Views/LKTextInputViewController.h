//
//  LKTextInputViewController.h
//  LKTranslator
//
//  Created by Luka Li on 25/1/2018.
//  Copyright © 2018 Luka Li. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void(^LKTextInputViewControllerInputTextCallback)(NSString *text);

@interface LKTextInputViewController : NSViewController

@property (nonatomic, copy) LKTextInputViewControllerInputTextCallback callback;

@end
