//
//  DCustomAbstractKeyboard.m
//  Scout
//
//  Created by Denis Chaschin on 30.04.14.
//  Copyright (c) 2014 RSA LLC. All rights reserved.
//

#import "DCustomAbstractKeyboard.h"
#import "DCustomAbstractKeyboard_Protected.h"
#import "DCustomKeyboardButtonStyleIOS7.h"
#import "DCustomKeyboardButtonStyleIOS7Highlighted.h"

NSString *const kDCustomAbstractKeyboardEmptyCharacter = @"empty";
NSString *const kDCustomAbstractKeyboardBackSpaceCharacter = @"delete";

static const CGRect kLandscapeIPhoneKeyboardFrame = (CGRect){0, 0, 480, 162};
static const CGRect kPortraitIPhoneKeyboardFrame = (CGRect){0, 0, 320, 216};

static const NSTimeInterval kHighlightRemovingWhenPressedDelay = .05;
static const NSTimeInterval kHighlightRemovingWhenPressedDuration = .3;

@interface DCustomAbstractKeyboard ()
//TODO: move to private
@property (strong, nonatomic) UILabel *highlightedButton;
@property (strong, nonatomic) UIImageView *highlightedBackspace;
@property (strong, nonatomic) UIView *highlightedEmptyButton;
@end

@implementation DCustomAbstractKeyboard
@synthesize textInput = _textInput;

- (id)init {
    UIDeviceOrientation const orientation = [[UIDevice currentDevice] orientation];
	CGRect frame;
    
	if(UIDeviceOrientationIsLandscape(orientation)) {
        frame = kLandscapeIPhoneKeyboardFrame;
    } else {
        frame = kPortraitIPhoneKeyboardFrame;
    }
	if (self = [super initWithFrame:frame]) {
        if ([_style respondsToSelector:@selector(applyToBackgroundView:)]) {
            [_style applyToBackgroundView:self];
        }
        [self setupDefaultStyles];
    }
    
    return self;
}

- (void)applyKeyboardToTextInput:(id<UITextInput>)textInput {
    self.textInput = textInput;
}

#pragma mark - Setters

- (void)setTextInput:(id<UITextInput>)textInput {
    [_textInput setInputView:nil];
    _textInput = textInput;
    [_textInput setInputView:self];
}

- (void)setHighlightedButton:(UILabel *)highlightedButton {
    [self.style applyToCharacterLabel:_highlightedButton];
    _highlightedButton = highlightedButton;
    if (_highlightedButton) {
        [self.highlightedStyle applyToCharacterLabel:_highlightedButton];
    }
}

- (void)setHighlightedEmptyButton:(UIView *)highlightedEmptyButton {
    [self.style applyToEmptyButton:_highlightedEmptyButton];
    _highlightedEmptyButton = highlightedEmptyButton;
    if (_highlightedEmptyButton) {
        [self.highlightedStyle applyToEmptyButton:_highlightedEmptyButton];
    }
}

- (void)setHighlightedBackspace:(UIImageView *)highlightedBackspace {
    [self.style applyToBackspace:_highlightedBackspace];
    _highlightedBackspace = highlightedBackspace;
    if (_highlightedBackspace) {
        [self.highlightedStyle applyToBackspace:_highlightedBackspace];
    }
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    BOOL wasHighlighted = [self highlighButtonInLocation:location];
    if (wasHighlighted) {
        [[UIDevice currentDevice] playInputClick];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    [self highlighButtonInLocation:location];
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint location = [[touches anyObject] locationInView:self];
    [self highlighButtonInLocation:location];
    
    if (self.highlightedButton) {
        [self didPressButton:self.highlightedButton];
    }
    
    if (self.highlightedEmptyButton) {
        [self didPressEmptyButton:self.highlightedEmptyButton];
    }
    
    if (self.highlightedBackspace) {
        [self didPressBackspace:self.highlightedBackspace];
    }
    
    [UIView animateWithDuration:kHighlightRemovingWhenPressedDuration delay:kHighlightRemovingWhenPressedDelay options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.highlightedButton = nil;
        self.highlightedEmptyButton = nil;
        self.highlightedBackspace = nil;
    } completion:nil];
}

#pragma mark - Button events
- (void)didPressButton:(UILabel *)button {
    NSString *const text = [button.text copy];
    
    id const input = self.textInput;
    
    //code from http://stackoverflow.com/questions/13205160/how-do-i-retrieve-keystrokes-from-a-custom-keyboard-on-an-ios-app/13205494#13205494
    if ([input respondsToSelector:@selector(shouldChangeTextInRange:replacementText:)]) {
        if ([input shouldChangeTextInRange:[input selectedTextRange] replacementText:text]) {
            [input insertText:text];
        }
    } else if ([input isKindOfClass:[UITextField class]]) {
        NSRange range = [self selectedRangeInTextField:input];
        if ([[input delegate] textField:input shouldChangeCharactersInRange:range replacementString:text]) {
            [input insertText:text];
        }
    } else if ([input isKindOfClass:[UITextView class]]) {
        NSRange range = [self selectedRangeInTextField:input];
        if ([[input delegate] textView:input shouldChangeTextInRange:range replacementText:text]) {
            [input insertText:text];
        }
    } else {
        [self.textInput insertText:text];
    }
    
    [self sendNotificationAboutTextChanging];
}

- (void)didPressBackspace:(UIImageView *)backspace {
    id const input = self.textInput;
    
    //code from http://stackoverflow.com/questions/13205160/how-do-i-retrieve-keystrokes-from-a-custom-keyboard-on-an-ios-app/13205494#13205494
    if ([input respondsToSelector:@selector(shouldChangeTextInRange:replacementText:)]) {
        UITextRange *range = [input selectedTextRange];
        if ([range.start isEqual:range.end]) {
            UITextPosition *newStart = [input positionFromPosition:range.start inDirection:UITextLayoutDirectionLeft offset:1];
            range = [input textRangeFromPosition:newStart toPosition:range.end];
        }
        if ([input shouldChangeTextInRange:range replacementText:@""]) {
            [input deleteBackward];
        }
    } else if ([input isKindOfClass:[UITextField class]]) {
        NSRange range = [self selectedRangeInTextField:input];
        if (range.length == 0) {
            if (range.location > 0) {
                range.location--;
                range.length = 1;
            }
        }
        if ([[input delegate] textField:input shouldChangeCharactersInRange:range replacementString:@""]) {
            [input deleteBackward];
        }
    } else if ([input isKindOfClass:[UITextView class]]) {
        NSRange range = [self selectedRangeInTextField:input];
        if (range.length == 0) {
            if (range.location > 0) {
                range.location--;
                range.length = 1;
            }
        }
        if ([[input delegate] textView:input shouldChangeTextInRange:range replacementText:@""]) {
            [input deleteBackward];
        }
    } else {
        [input deleteBackward];
    }
	
    [self sendNotificationAboutTextChanging];
}

- (void)didPressEmptyButton:(UIView *)emptyButton {
    //nothing to do here
}


#pragma mark - Private

- (void)setupDefaultStyles {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        _style = [[DCustomKeyboardButtonStyleIOS7 alloc] init];
        _highlightedStyle = [[DCustomKeyboardButtonStyleIOS7Highlighted alloc] init];
    } else {
        _style = [[DCustomKeyboardButtonStyleIOS7 alloc] init];
        _highlightedStyle = [[DCustomKeyboardButtonStyleIOS7Highlighted alloc] init];
    }
}

- (BOOL)highlighButtonInLocation:(CGPoint)location {
    BOOL wasFounded = NO;
    
    // check already hightlighted button
    if (!wasFounded && self.highlightedButton && CGRectContainsPoint(self.highlightedButton.frame, location)) {
        wasFounded = YES;
    }
    if (!wasFounded && self.highlightedBackspace && CGRectContainsPoint(self.highlightedBackspace.frame, location)) {
        wasFounded = YES;
    }
    if (!wasFounded && self.highlightedEmptyButton && CGRectContainsPoint(self.highlightedEmptyButton.frame, location)) {
        wasFounded = YES;
    }
    
    // check others buttons
    if (!wasFounded) {
        for (UILabel *label in self.buttons) {
            if (CGRectContainsPoint(label.frame, location)) {
                wasFounded = YES;
                self.highlightedButton = label;
                self.highlightedEmptyButton = nil;
                self.highlightedBackspace = nil;
                break;
            }
        }
    }
    if (!wasFounded) {
        for(UIView *empty in self.emptyButtons) {
            if (CGRectContainsPoint(empty.frame, location)) {
                self.highlightedButton = nil;
                self.highlightedEmptyButton = empty;
                self.highlightedBackspace = nil;
                wasFounded = YES;
                break;
            }
        }
    }
    if (!wasFounded) {
        for (UIImageView *backspace in self.backspaces) {
            if (CGRectContainsPoint(backspace.frame, location)) {
                self.highlightedButton = nil;
                self.highlightedEmptyButton = nil;
                self.highlightedBackspace = backspace;
                wasFounded = YES;
                break;
            }
        }
    }
    
    if (!wasFounded) {
        self.highlightedButton = nil;
        self.highlightedEmptyButton = nil;
        self.highlightedBackspace = nil;
    }
    return wasFounded;
}

- (void)sendNotificationAboutTextChanging {
    if ([self.textInput isKindOfClass:[UITextView class]]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textInput];
	} else if ([self.textInput isKindOfClass:[UITextField class]]) {
		[[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.textInput];
    }
}

- (NSRange)selectedRangeInTextField:(id<UITextInput>)textField {
    UITextRange *tr = [textField selectedTextRange];
    
    NSInteger spos = [textField offsetFromPosition:textField.beginningOfDocument toPosition:tr.start];
    NSInteger epos = [textField offsetFromPosition:textField.beginningOfDocument toPosition:tr.end];
    
    return NSMakeRange(spos, epos - spos);
}

@end
