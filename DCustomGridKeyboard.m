//
//  DCustomGridKeyboard.m
//  Scout
//
//  Created by Denis Chaschin on 30.04.14.
//  Copyright (c) 2014 diniska. All rights reserved.
//

#import "DCustomGridKeyboard.h"
#import "DCustomAbstractKeyboard_Protected.h"
#import "DCustomKeyboardButtonStyle.h"

@interface DCustomGridKeyboard()

@end

@implementation DCustomGridKeyboard

- (id)initWithCharacters:(NSArray *)array {

	if (self = [super init]) {
        [self createButtonsWithCharachters:array];
    }
    return self;
}

#pragma mark - Private
- (void)createButtonsWithCharachters:(NSArray *)characters2DArray {
    const NSUInteger numberOfLines = characters2DArray.count;
    NSUInteger numberOfRows = 0;
    for (NSArray *line in characters2DArray) {
        numberOfRows = MAX(line.count, numberOfRows);
    }
    
    if (numberOfRows == 0) {
        numberOfRows = 1;
    }
    
    const CGFloat separatorWidth = 1 / [UIScreen mainScreen].scale;
    const CGFloat separatorHeight = separatorWidth;
    
    const CGFloat fullWidth = self.bounds.size.width;
    const CGFloat fullHeight = self.bounds.size.height;
    const CGFloat buttonWidth = (fullWidth - separatorWidth * (numberOfRows - 2)) / numberOfRows;
    const CGFloat buttonHeight = (fullHeight - separatorHeight * (numberOfLines - 2)) / numberOfLines;

    NSAssert(buttonWidth > 0, @"unsupported button width");
    NSAssert(buttonHeight > 0, @"unsupported button height");
    
    UIView *previousTopButton;
    UIView *previousLeftButton;
    NSMutableArray *constraints = [NSMutableArray array];
    
    NSMutableArray *buttons = [NSMutableArray array];
    NSMutableArray *backspaces = [NSMutableArray array];
    NSMutableArray *emptyButtons = [NSMutableArray array];
    
    id<DCustomKeyboardButtonStyle> style = self.style;
    
    for (NSArray *line in characters2DArray) {

        
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
                          separatorHeight:separatorHeight
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
                buttonWidth:(CGFloat const)buttonWidth
               buttonHeight:(CGFloat const)buttonHeight
          previousTopButton:(UIView *)previousTopButton
         previousLeftButton:(UIView *)previousLeftButton
             separatorWidth:(CGFloat const)separatorWidth
            separatorHeight:(CGFloat const)separatorHeight
                     button:(UIView *)button {
    NSString *horizontalConstraintVisualFormat;
    NSDictionary *viewsToApplyHorizontalFormat;
    NSDictionary *metrics = @{
                              @"buttonWidth" : @(buttonWidth),
                              @"buttonHeight" : @(buttonHeight),
                              @"separatorWidth" : @(separatorWidth),
                              @"separatorHeight" : @(separatorHeight)
                              };
    
    if (previousLeftButton == nil) {
        viewsToApplyHorizontalFormat = NSDictionaryOfVariableBindings(button);
        horizontalConstraintVisualFormat = @"H:|[button(buttonWidth)]";
    } else {
        viewsToApplyHorizontalFormat = NSDictionaryOfVariableBindings(previousLeftButton, button);
        horizontalConstraintVisualFormat = @"H:[previousLeftButton]-separatorWidth-[button(buttonWidth)]";
    }
    
    NSString *verticalConstraintVisualFormat;
    NSDictionary *viewsToApplyVerticalFormat;
    
    if (previousTopButton == nil) {
        viewsToApplyVerticalFormat = NSDictionaryOfVariableBindings(button);
        verticalConstraintVisualFormat = @"V:|[button(buttonHeight)]";
    } else {
        viewsToApplyVerticalFormat = NSDictionaryOfVariableBindings(previousTopButton, button);
        verticalConstraintVisualFormat = @"V:[previousTopButton]-separatorHeight-[button(buttonHeight)]";
    }
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraintVisualFormat options:NSLayoutFormatDirectionLeftToRight metrics:metrics views:viewsToApplyHorizontalFormat]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:verticalConstraintVisualFormat options:NSLayoutFormatDirectionLeadingToTrailing metrics:metrics views:viewsToApplyVerticalFormat]];
}

@end
