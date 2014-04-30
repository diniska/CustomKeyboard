//
//  DCustomGridKeyboard.m
//  Scout
//
//  Created by Denis Chaschin on 30.04.14.
//  Copyright (c) 2014 RSA LLC. All rights reserved.
//

#import "DCustomGridKeyboard.h"
#import "DCustomAbstractKeyboard_Protected.h"
#import "DCustomGridKeyboardButtonStyle.h"

@interface DCustomGridKeyboard()

@end

@implementation DCustomGridKeyboard

- (id)initWithCharacters:(NSArray *)array {

	if (self = [super init]) {
        [self crateButtonsWithCharachters:array];
    }
    return self;
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
        const CGFloat separatorWidth =(CGFloat) fullWidth / line.count - buttonWidth;
        for (NSString *buttonTitle in line) {
            UIView *button;
            if (buttonTitle == kDCustomAbstractKeyboardBackSpaceCharacter) {
                UIImageView *backspace = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backspace_ios7_icon"]];
                backspace.contentMode = UIViewContentModeCenter;
                button = backspace;
                [style applyToBackspace:backspace];
                [backspaces addObject:backspace];
            } else if (buttonTitle == kDCustomAbstractKeyboardEmptyCharacter) {
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
            @"separatorWidth" : @(separatorWidth / 2),
            @"separatorHeight" : @0
    };
    
    if (previousLeftButton == nil) {
        viewsToApplyHorizontalFormat = NSDictionaryOfVariableBindings(button);
        horizontalConstraintVisualFormat = @"H:|-separatorWidth-[button(buttonWidth)]";
    } else {
        viewsToApplyHorizontalFormat = NSDictionaryOfVariableBindings(previousLeftButton, button);
        horizontalConstraintVisualFormat = @"H:[previousLeftButton]-separatorWidth-[button(buttonWidth)]";
    }

    NSString *verticalConstraintVisualFormat;
    NSDictionary *viewsToApplyVerticalFormat;

    if (previousTopButton == nil) {
        viewsToApplyVerticalFormat = NSDictionaryOfVariableBindings(button);
        verticalConstraintVisualFormat = @"V:|-separatorHeight-[button(buttonHeight)]";
    } else {
        viewsToApplyVerticalFormat = NSDictionaryOfVariableBindings(previousTopButton, button);
        verticalConstraintVisualFormat = @"V:[previousTopButton]-separatorHeight-[button(buttonHeight)]";
    }

    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraintVisualFormat options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:viewsToApplyHorizontalFormat]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:verticalConstraintVisualFormat options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:viewsToApplyVerticalFormat]];
}

@end
