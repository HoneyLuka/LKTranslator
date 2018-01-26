//
//  LKHotKeyObserver.m
//  LKTranslator
//
//  Created by Luka Li on 2017/12/20.
//  Copyright © 2017年 Luka Li. All rights reserved.
//

#import "LKHotKeyObserver.h"
#import <Carbon/Carbon.h>

static EventHandlerRef handlerRef = NULL;
static EventHotKeyRef quickHotKeyRef = NULL;
static EventHotKeyRef inputHotKeyRef = NULL;

static EventHotKeyID quickHotKeyID = {'keyA', 1};
static EventHotKeyID inputHotKeyID = {'keyB', 2};

static LKHotKeyObserver *selfRef = nil;

@implementation LKHotKeyObserver

OSStatus hotKeyHandler(EventHandlerCallRef inHandlerCallRef, EventRef inEvent, void *inUserData)
{
    if (GetEventClass(inEvent) != kEventClassKeyboard) {
        return noErr;
    }
    
    if (GetEventKind(inEvent) != kEventHotKeyPressed) {
        return noErr;
    }
    
    EventHotKeyID keyID;
    GetEventParameter(inEvent, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(keyID), NULL, &keyID);
    if (keyID.id == quickHotKeyID.id) {
        if ([selfRef.delegate respondsToSelector:@selector(hotKeyObserverDidTriggerQuickHotKey:)]) {
            [selfRef.delegate hotKeyObserverDidTriggerQuickHotKey:selfRef];
        }
    }
    
    if (keyID.id == inputHotKeyID.id) {
        if ([selfRef.delegate respondsToSelector:@selector(hotKeyObserverDidTriggerInputHotKey:)]) {
            [selfRef.delegate hotKeyObserverDidTriggerInputHotKey:selfRef];
        }
    }
    
    return noErr;
}

- (void)dealloc
{
    selfRef = nil;
    [self unRegisterHotKey];
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
    selfRef = self;
    [self registerHotKey];
}

- (void)registerHotKey
{
    EventTypeSpec eventSpecs[] = {{kEventClassKeyboard,kEventHotKeyPressed}};
    InstallApplicationEventHandler(NewEventHandlerUPP(hotKeyHandler),
                                   GetEventTypeCount(eventSpecs),
                                   eventSpecs,
                                   NULL,
                                   &handlerRef);
    
    RegisterEventHotKey(kVK_ANSI_D,
                        cmdKey | controlKey,
                        inputHotKeyID,
                        GetApplicationEventTarget(),
                        0,
                        &inputHotKeyRef);
    
    RegisterEventHotKey(kVK_ANSI_D,
                        cmdKey,
                        quickHotKeyID,
                        GetApplicationEventTarget(),
                        0,
                        &quickHotKeyRef);
}

- (void)unRegisterHotKey
{
    if (quickHotKeyRef) {
        UnregisterEventHotKey(quickHotKeyRef);
        quickHotKeyRef = NULL;
    }
    
    if (inputHotKeyRef) {
        UnregisterEventHotKey(inputHotKeyRef);
        inputHotKeyRef = NULL;
    }
    
    if (handlerRef) {
        RemoveEventHandler(handlerRef);
        handlerRef = NULL;
    }
}

@end
