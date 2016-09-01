//
//  SCKeyboardDelegate.m
//  sma11case
//
//  Created by lianlian on 8/24/16.
//  Copyright © 2016 sma11case. All rights reserved.
//

#import "SCKeyboardDelegate.h"
#import "../Config.h"

void closeKeyboard()
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

@implementation SCKeyboardDelegate
ImpSharedMethod()

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self addKeyboardNotify];
    }
    return self;
}

- (void)setKeyboardDelegate:(id <SCKeyboardManagerDelegate>)delegate
{
    _delegate = delegate;
}

- (void)unsetKeyboardDelegate:(id <SCKeyboardManagerDelegate>)delegate
{
    if (_delegate == delegate) {
        _delegate = nil;
    }
}

- (void)addKeyboardNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyboardNotify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notify
{
    id delegate = self.delegate;
    if (delegate && [delegate respondsToSelector:@selector(keyboardWillChangeFrameNotification:)]) {
        [delegate keyboardWillChangeFrameNotification:notify];
    }
}

- (void)keyboardWillShowNotification:(NSNotification *)notify
{
    id delegate = self.delegate;
    if (delegate && [delegate respondsToSelector:@selector(keyboardWillShowNotification:)]) {
        [delegate keyboardWillShowNotification:notify];
    }
}

- (void)keyboardWillHideNotification:(NSNotification *)notify
{
    id delegate = self.delegate;
    if (delegate && [delegate respondsToSelector:@selector(keyboardWillHideNotification:)]) {
        [delegate keyboardWillHideNotification:notify];
    }
}

@end