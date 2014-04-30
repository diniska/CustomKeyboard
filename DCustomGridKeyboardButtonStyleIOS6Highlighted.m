//
//  DCustomGridKeyboardButtonStyleIOS6Highlighted.m
//  Scout
//
//  Created by Denis Chaschin on 30.04.14.
//  Copyright (c) 2014 RSA LLC. All rights reserved.
//

#import "DCustomGridKeyboardButtonStyleIOS6Highlighted.h"


@implementation DCustomGridKeyboardButtonStyleIOS6Highlighted
- (void)applyToCharacterLabel:(UILabel *)label {
    label.backgroundColor = [UIColor blackColor];
    label.textColor = [UIColor whiteColor];
    label.layer.borderWidth = 1;
    label.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)applyToBackspace:(UIImageView *)backspaceImage {
    backspaceImage.backgroundColor = [UIColor blackColor];
}

- (void)applyToEmptyButton:(UIView *)emptyButton {
    emptyButton.backgroundColor = [UIColor blackColor];
}
@end
