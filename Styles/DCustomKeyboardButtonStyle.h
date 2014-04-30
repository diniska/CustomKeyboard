//
//  DCustomKeyboardButtonStyle.h
//  Scout
//
//  Created by Denis Chaschin on 30.04.14.
//  Copyright (c) 2014 diniska. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DCustomKeyboardButtonStyle<NSObject>
- (void)applyToCharacterLabel:(UILabel *)label;
- (void)applyToBackspace:(UIImageView *)backspaceImage;
- (void)applyToEmptyButton:(UIView *)emptyButton;
@optional
- (void)applyToBackgroundView:(UIView *)backgroundView;
@end
