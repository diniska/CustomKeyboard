//
//  DCustomGridKeyboard.h
//  Scout
//
//  Created by Denis Chaschin on 30.04.14.
//  Copyright (c) 2014 diniska. All rights reserved.
//

#import "DCustomAbstractKeyboard.h"

@interface DCustomGridKeyboard : DCustomAbstractKeyboard <UIInputViewAudioFeedback>
/**
 * The buttons will be placed by grid.
 * @param array 2D array of strings to use a keyboard symbols
 */
- (id)initWithCharacters:(NSArray *)array;

@end
