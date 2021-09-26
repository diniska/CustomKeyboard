//
//  DCustomLinesKeyboard.h
//  Scout
//
//  Created by Denis Chaschin on 30.04.14.
//  Copyright (c) 2014 diniska All rights reserved.
//

#import "DCustomGridKeyboard.h"

typedef DCustomGridKeyboard DCustomLinesKeyboard;

@interface DCustomGridKeyboard (DCustomLinesKeyboardOldApiCompatibility)
/**
 * The buttons will be splitted to lines. Each button on line will have the same width
 * @param array 2D array of strings to use a keyboard symbols
 */
- (id)initWithCharactersLines:(NSArray *)array;
@end
