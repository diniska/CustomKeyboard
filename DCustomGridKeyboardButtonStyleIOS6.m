//
//  DCustomGridKeyboardButtonStyleIOS6.m
//  Scout
//
//  Created by Denis Chaschin on 30.04.14.
//  Copyright (c) 2014 RSA LLC. All rights reserved.
//

#import "DCustomGridKeyboardButtonStyleIOS6.h"

@implementation DCustomGridKeyboardButtonStyleIOS6
- (void)applyToCharacterLabel:(UILabel *)label {
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor blackColor];
    label.layer.borderWidth = 1;
    label.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)applyToBackspace:(UIImageView *)backspaceImage {
    backspaceImage.backgroundColor = [UIColor greenColor];
}

- (void)applyToEmptyButton:(UIView *)emptyButton {
    emptyButton.backgroundColor = [UIColor lightGrayColor];
}
@end
