//
//  LKTranslatorCore.m
//  LKTranslator
//
//  Created by Luka Li on 2017/12/20.
//  Copyright © 2017年 Luka Li. All rights reserved.
//

#import "LKTranslatorCore.h"
#import "LKPopoverViewController.h"
#import "LKHotKeyObserver.h"
#import "LKUIHandler.h"

@interface LKTranslatorCore () <LKHotKeyObserverDelegate, LKUIHandlerDelegate>

@property (nonatomic, strong) LKHotKeyObserver *hotKeyObserver;
@property (nonatomic, strong) LKUIHandler *uiHandler;

@end

@implementation LKTranslatorCore
{
    BOOL _isProcessing;
}

+ (instancetype)sharedCore
{
    static LKTranslatorCore *core = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        core = [LKTranslatorCore new];
    });
    
    return core;
}

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
    self.hotKeyObserver = [LKHotKeyObserver new];
    self.hotKeyObserver.delegate = self;
    
    self.uiHandler = [LKUIHandler new];
    self.uiHandler.delegate = self;
}

- (void)applicationWillTerminate
{
    [self.hotKeyObserver unRegisterHotKey];
}

#pragma mark - Pasteboard check

- (void)checkPasteBoard
{
    if (_isProcessing) {
        return;
    }
    
    NSPasteboardItem *item = [[NSPasteboard generalPasteboard].pasteboardItems lastObject];
    
    if (![item.types containsObject:NSPasteboardTypeString]) {
        return;
    }
    
    NSString *str = [item stringForType:NSPasteboardTypeString];
    [self translateText:str];
}

- (void)translateText:(NSString *)text
{
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length > 1024 || !text.length) {
        return;
    }
    
    NSString *urlString = @"https://translate.google.cn/translate_a/single";
    NSURLComponents *components = [NSURLComponents componentsWithString:urlString];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:text forKey:@"q"];
    [params setObject:@"en" forKey:@"sl"];
    [params setObject:@"zh-CN" forKey:@"tl"];
    [params setObject:@"gtx" forKey:@"client"];
    [params setObject:@"t" forKey:@"dt"];
    [params setObject:@"UTF-8" forKey:@"ie"];
    [params setObject:@"UTF-8" forKey:@"oe"];
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *key in params.allKeys) {
        id value = params[key];
        NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:key value:value];
        [items addObject:item];
    }
    
    components.queryItems = items;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:components.URL];
    request.timeoutInterval = 5;
    
    _isProcessing = YES;
    self.uiHandler.status = LKUIHandlerStatusProcessing;
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:
     ^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
         _isProcessing = NO;
         
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         if (httpResponse.statusCode != 200 || !data.length || connectionError) {
             // error
             self.uiHandler.status = LKUIHandlerStatusError;
             return;
         }
         
         NSString *resultText = nil;
         
         @try {
             NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:NSJSONReadingMutableLeaves
                                                                    error:nil];
             NSArray *resultArray = [jsonArray firstObject];
             
             NSMutableString *str = [[NSMutableString alloc]initWithString:@""];
             for (NSArray *array in resultArray) {
                 NSString *translatedText = array.firstObject;
                 if (translatedText.length) {
                     [str appendString:translatedText];
                 }
             }
             
             resultText = str;
             
             if (!resultText.length) {
                 // error
                 self.uiHandler.status = LKUIHandlerStatusError;
                 return;
             }
         } @catch (NSException *exception) {
             self.uiHandler.status = LKUIHandlerStatusError;
             return;
         }
         
         self.uiHandler.status = LKUIHandlerStatusIdle;
         [self showTranslateResult:resultText];
     }];
}

- (void)showTranslateResult:(NSString *)text
{
    [self.uiHandler showTranslateText:text];
}

#pragma mark - LKHotKeyObserverDelegate

- (void)hotKeyObserverDidTriggerQuickHotKey:(LKHotKeyObserver *)observer
{
    [self checkPasteBoard];
}

- (void)hotKeyObserverDidTriggerInputHotKey:(LKHotKeyObserver *)observer
{
    [self.uiHandler showTextInputView];
}

#pragma mark - LKUIHandlerDelegate

- (void)UIHandler:(LKUIHandler *)handler didEnterText:(NSString *)text
{
    [self translateText:text];
}

@end
