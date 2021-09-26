//
//  DCustomLinesKeyboard.m
//  Scout
//
//  Created by Denis Chaschin on 30.04.14.
//  Copyright (c) 2014 diniska. All rights reserved.
//

#import "DCustomLinesKeyboard.h"

@implementation  DCustomGridKeyboard (DCustomLinesKeyboardOldApiCompatibility)
- (id)initWithCharactersLines:(NSArray *)array {
    return [self initWithCharacters:array];
}
@end
