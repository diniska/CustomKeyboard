//
//  DCustomGridKeyboard.m
//  Scout
//
//  Created by Denis Chaschin on 30.04.14.
//  Copyright (c) 2014 RSA LLC. All rights reserved.
//

#import "DCustomGridKeyboard.h"
#import "DCustomGridKeyboardButtonStyleIOS6.h"
#import "DCustomGridKeyboardButtonStyleIOS6Highlighted.h"

NSString *const kDCustomGridKeyboardEmptyCharacter = @"empty";
NSString *const kDCustomGridKeyboardBackSpaceCharacter = @"delete";

static const CGRect kLandscapeIPhoneKeyboardFrame = (CGRect){0, 0, 480, 162};
static const CGRect kPortraitIPhoneKeyboardFrame = (CGRect){0, 0, 320, 216};

static const NSTimeInterval kHighlightRemovingWhenPressedDelay = .05;
static const NSTimeInterval kHighlightRemovingWhenPressedDuration = .3;

@interface DCustomGridKeyboard()
@property (strong, nonatomic) NSArray *buttons;
@property (strong, nonatomic) NSArray *backspaces;
@property (strong, nonatomic) NSArray *emptyButtons;

@property (strong, nonatomic) UILabel *highlightedButton;
@property (strong, nonatomic) UIImageView *highlightedBackspace;
@property (strong, nonatomic) UIView *highlightedEmptyButton;
/**
 * UITextFiel or UITextView
 */
@property (strong, nonatomic) id textInput;

@end

@implementation DCustomGridKeyboard

- (id)initWithCharacters:(NSArray *)array {
    UIDeviceOrientation const orientation = [[UIDevice currentDevice] orientation];
	CGRect frame;
    
	if(UIDeviceOrientationIsLandscape(orientation)) {
        frame = kLandscapeIPhoneKeyboardFrame;
    } else {
        frame = kPortraitIPhoneKeyboardFrame;
    }
	if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor redColor];
        [self setupDefaultStyles];
        [self crateButtonsWithCharachters:array];
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
    DLog(@"touch began");
    CGPoint location = [[touches anyObject] locationInView:self];
    BOOL wasHighlighted = [self highlighButtonInLocation:location];
    if (wasHighlighted) {
        [[UIDevice currentDevice] playInputClick];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    DLog(@"touch moved");
    CGPoint location = [[touches anyObject] locationInView:self];
    [self highlighButtonInLocation:location];
}


- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    DLog(@"touch ended")
    
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


#pragma mark - UIInputViewAudioFeedback
- (BOOL)enableInputClicksWhenVisible {
    return YES;
}

#pragma mark - Private
- (void)crateButtonsWithCharachters:(NSArray *)characters2DArray {
    const NSUInteger numberOfLines = characters2DArray.count;
    NSUInteger numberOfRows = 0;
    for (NSArray *line in characters2DArray) {
        numberOfRows = MAX(numberOfRows, line.count);
    }
    
    const CGFloat fullWidth = self.bounds.size.width;
    const CGFloat fullHeight = self.bounds.size.height;
    
    const NSInteger buttonWidth = floorf(fullWidth / numberOfRows);
    const NSInteger buttonHeight = floor(fullHeight / numberOfLines);
    NSAssert(buttonHeight > 0, @"unsupported button height");
    NSAssert(buttonWidth > 0, @"unsupported button width");
    
    UIView *previousTopButton;
    UIView *previousLeftButton;
    NSMutableArray *constraints = [NSMutableArray array];
    
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:numberOfLines * numberOfRows];
    NSMutableArray *backspaces = [NSMutableArray array];
    NSMutableArray *emptyButtons = [NSMutableArray array];
    
    id<DCustomGridKeyboardButtonStyle> style = self.style;
    
    for (NSArray *line in characters2DArray) {
        const CGFloat separatorWidth = fullWidth - line.count * buttonWidth;
        for (NSString *buttonTitle in line) {
            UIView *button;
            if (buttonTitle == kDCustomGridKeyboardBackSpaceCharacter) {
                UIImageView *backspace = [[UIImageView alloc] init];
                backspace.contentMode = UIViewContentModeCenter;
                [style applyToBackspace:backspace];
                [backspaces addObject:backspace];
            } else if (buttonTitle == kDCustomGridKeyboardEmptyCharacter) {
                button = [[UIView alloc] init];
                [style applyToEmptyButton:button];
                [emptyButtons addObject:button];
            } else {
                UILabel *label = [[UILabel alloc] init];
                label.text = buttonTitle;
                label.textAlignment = NSTextAlignmentCenter;
                button = label;
                [style applyToCharacterLabel:label];
                [buttons addObject:button];
            }
            
            if (button != nil) {
                button.translatesAutoresizingMaskIntoConstraints = NO;
                [self addSubview:button];
                [self appendConstraintsTo:constraints
                              buttonWidth:buttonWidth
                             buttonHeight:buttonHeight
                        previousTopButton:previousTopButton
                       previousLeftButton:previousLeftButton
                           separatorWidth:separatorWidth
                                   button:button];
                if (line.lastObject == buttonTitle) {
                    previousTopButton = button;
                    previousLeftButton = nil;
                } else {
                    previousLeftButton = button;
                }
            }
        }
    }
    self.buttons = [buttons copy];
    self.backspaces = [backspaces copy];
    self.emptyButtons = [emptyButtons copy];
    [self addConstraints:constraints];
}

- (void)appendConstraintsTo:(in out NSMutableArray *)constraints
                buttonWidth:(NSInteger const)buttonWidth
               buttonHeight:(NSInteger const)buttonHeight
          previousTopButton:(UIView *)previousTopButton
         previousLeftButton:(UIView *)previousLeftButton
             separatorWidth:(CGFloat const)separatorWidth
                     button:(UIView *)button {
    NSString *horizontalConstraintVisualFormat;
    NSDictionary *viewsToApplyHorizontalFormat;
    NSDictionary *metrics = @{
            @"buttonWidth" : @(buttonWidth),
            @"buttonHeight" : @(buttonHeight),
            @"separatorWidth" : @(separatorWidth),
            @"separatorHeight" : @0
    };
    
    if (previousLeftButton == nil) {
        viewsToApplyHorizontalFormat = NSDictionaryOfVariableBindings(button);
        horizontalConstraintVisualFormat = @"H:|-0-[button(buttonWidth)]";
    } else {
        viewsToApplyHorizontalFormat = NSDictionaryOfVariableBindings(previousLeftButton, button);
        horizontalConstraintVisualFormat = @"H:[previousLeftButton]-separatorWidth-[button(buttonWidth)]";
    }

    NSString *verticalConstraintVisualFormat;
    NSDictionary *viewsToApplyVerticalFormat;

    if (previousTopButton == nil) {
        viewsToApplyVerticalFormat = NSDictionaryOfVariableBindings(button);
        verticalConstraintVisualFormat = @"V:|-0-[button(buttonHeight)]";
    } else {
        viewsToApplyVerticalFormat = NSDictionaryOfVariableBindings(previousTopButton, button);
        verticalConstraintVisualFormat = @"V:[previousTopButton]-separatorHeight-[button(buttonHeight)]";
    }

    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraintVisualFormat options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:viewsToApplyHorizontalFormat]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:verticalConstraintVisualFormat options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:viewsToApplyVerticalFormat]];
}

- (void)setupDefaultStyles {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        _style = [[DCustomGridKeyboardButtonStyleIOS6 alloc] init];
        _highlightedStyle = [[DCustomGridKeyboardButtonStyleIOS6Highlighted alloc] init];
    } else {
        _style = [[DCustomGridKeyboardButtonStyleIOS6 alloc] init];
        _highlightedStyle = [[DCustomGridKeyboardButtonStyleIOS6Highlighted alloc] init];
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

- (void)didPressButton:(UILabel *)button {
    NSString *const text = [button.text copy];
    
    id const input = self.textInput;
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
	[self.textInput deleteBackward];
    [self sendNotificationAboutTextChanging];
}

- (void)didPressEmptyButton:(UIView *)emptyButton {
    //nothing to do here
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
