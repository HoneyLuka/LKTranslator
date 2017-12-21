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
static EventHotKeyRef hotKeyRef = NULL;
static EventHotKeyID translateHotKeyID = {'keyA', 1};

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
    if (keyID.id == translateHotKeyID.id) {
        if ([selfRef.delegate respondsToSelector:@selector(hotKeyObserverDidTriggerHotKey:)]) {
            [selfRef.delegate hotKeyObserverDidTriggerHotKey:selfRef];
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
                        cmdKey,
                        translateHotKeyID,
                        GetApplicationEventTarget(),
                        0,
                        &hotKeyRef);
}

- (void)unRegisterHotKey
{
    if (hotKeyRef) {
        UnregisterEventHotKey(hotKeyRef);
        hotKeyRef = NULL;
    }
    
    if (handlerRef) {
        RemoveEventHandler(handlerRef);
        handlerRef = NULL;
    }
}

@end
