//
//  DCustomGridKeyboard.h
//  Scout
//
//  Created by Denis Chaschin on 30.04.14.
//  Copyright (c) 2014 RSA LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kDCustomGridKeyboardEmptyCharacter;
extern NSString *const kDCustomGridKeyboardBackSpaceCharacter;

@protocol DCustomGridKeyboardButtonStyle;

@interface DCustomGridKeyboard : UIView <UIInputViewAudioFeedback>
/**
 * @param array 2D array of strings to use a keyboard symbols
 */
- (id)initWithCharacters:(NSArray *)array;
- (void)applyKeyboardToTextInput:(id<UITextInput>)textInput;

@property (strong, nonatomic) id<DCustomGridKeyboardButtonStyle> style;
@property (strong, nonatomic) id<DCustomGridKeyboardButtonStyle> highlightedStyle;
@end
