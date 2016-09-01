//
//  SCKeyboardDelegate.h
//  sma11case
//
//  Created by lianlian on 8/24/16.
//  Copyright © 2016 sma11case. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SCKeyboardState)
{
    SCKeyboardStateUnknow = 0,
    SCKeyboardStateWillShow,
    SCKeyboardStateDidShow,
    SCKeyboardStateWillChange,
    SCKeyboardStateDidChange,
    SCKeyboardStateWillHide,
    SCKeyboardStateDidHide
};

@protocol SCKeyboardManagerDelegate <NSObject>
@optional
- (void)keyboardWillChangeFrameNotification:(NSNotification *)notify;
- (void)keyboardWillShowNotification:(NSNotification *)notify;
- (void)keyboardWillHideNotification:(NSNotification *)notify;
@end

void closeKeyboard();

@interface SCKeyboardDelegate : NSObject
@property (nonatomic, assign, readonly) SCKeyboardState state;
@property (nonatomic, weak, readonly) id<SCKeyboardManagerDelegate> delegate;

+ (instancetype)shared;

- (void)setKeyboardDelegate:(id <SCKeyboardManagerDelegate>)delegate;
- (void)unsetKeyboardDelegate:(id <SCKeyboardManagerDelegate>)delegate;
@end
