//
//  DCustomGridKeyboardButtonStyleIOS7.m
//  Scout
//
//  Created by Denis Chaschin on 30.04.14.
//  Copyright (c) 2014 RSA LLC. All rights reserved.
//

#import "DCustomGridKeyboardButtonStyleIOS7.h"

@implementation DCustomGridKeyboardButtonStyleIOS7
- (void)applyToCharacterLabel:(UILabel *)label {
    label.textColor = [UIColor blackColor];
//    label.layer.borderWidth = 1;
    label.font = [UIFont systemFontOfSize:20];
    label.backgroundColor = [UIColor colorWithRed:252/255.f green:252/255.f blue:253/255.f alpha:1];
//    label.layer.borderColor = [UIColor blackColor].CGColor;
}

- (void)applyToBackspace:(UIImageView *)backspaceImage {
    backspaceImage.backgroundColor = [UIColor colorWithRed:188/255.f green:192/255.f blue:196/255.f alpha:1];
}

- (void)applyToEmptyButton:(UIView *)emptyButton {
    emptyButton.backgroundColor = [UIColor colorWithRed:188/255.f green:192/255.f blue:196/255.f alpha:1];
}

- (void)applyToBackgroundView:(UIView *)backgroundView {
    backgroundView.backgroundColor = [UIColor colorWithRed:188/255.f green:192/255.f blue:196/255.f alpha:1];
}
@end
