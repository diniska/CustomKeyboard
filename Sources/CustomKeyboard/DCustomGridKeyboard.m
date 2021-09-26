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
    const CGFloat separatorWidth = 1 / [UIScreen mainScreen].scale;
    const CGFloat separatorHeight = separatorWidth;
    
    UIView *previousTopButton;
    UIView *previousLeftButton;
    NSMutableArray *constraints = [NSMutableArray array];
    
    NSMutableArray *buttons = [NSMutableArray array];
    NSMutableArray *backspaces = [NSMutableArray array];
    NSMutableArray *emptyButtons = [NSMutableArray array];
    
    id<DCustomKeyboardButtonStyle> style = self.style;
    
    for (NSArray *line in characters2DArray) {
        UIView *button;
        for (NSString *buttonTitle in line) {
            button = nil;
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
                //Add horizontal constraints
                if (previousLeftButton == nil) {
                    //First button in line
                    [self addConstraint: [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
                } else {
                    [self addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousLeftButton attribute:NSLayoutAttributeRight multiplier:1 constant:separatorWidth]];
                    [self addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:previousLeftButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
                }
                
                //Add vertical constraints
                if (previousTopButton == nil) {
                    //Top button
                    [self addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
                    //height constraint for first line
                    if (previousLeftButton != nil) {
                        [self addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:previousLeftButton attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
                    }
                } else {
                    [self addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousTopButton attribute:NSLayoutAttributeBottom multiplier:1 constant:separatorHeight]];
                    [self addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:previousTopButton attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
                }
                
                previousLeftButton = button;
            }
        }
        //Last button in line
        [self addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        
        previousTopButton = button;
        previousLeftButton = nil;
    }
    //Last button at all
    [self addConstraint:[NSLayoutConstraint constraintWithItem:previousTopButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    self.buttons = [buttons copy];
    self.backspaces = [backspaces copy];
    self.emptyButtons = [emptyButtons copy];
    [self addConstraints:constraints];
}

@end
