//
//  DCustomAbstractKeyboard_Protected.h
//  Scout
//
//  Created by Denis Chaschin on 30.04.14.
//  Copyright (c) 2014 RSA LLC. All rights reserved.
//

#import "DCustomAbstractKeyboard.h"

@interface DCustomAbstractKeyboard ()
@property (strong, nonatomic) NSArray *buttons;
@property (strong, nonatomic) NSArray *backspaces;
@property (strong, nonatomic) NSArray *emptyButtons;

/**
 * UITextFiel or UITextView
 */
@property (strong, nonatomic, readonly) id textInput;

#pragma mark - Button events Override if need
- (void)didPressButton:(UILabel *)button;
- (void)didPressBackspace:(UIImageView *)backspace;
- (void)didPressEmptyButton:(UIView *)emptyButton;
@end
