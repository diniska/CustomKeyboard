//
//  DCustomGridKeyboard.h
//  Scout
//
//  Created by Denis Chaschin on 30.04.14.
//  Copyright (c) 2014 RSA LLC. All rights reserved.
//

#import "DCustomAbstractKeyboard.h"

@interface DCustomGridKeyboard : DCustomAbstractKeyboard <UIInputViewAudioFeedback>
/**
 * @param array 2D array of strings to use a keyboard symbols
 */
- (id)initWithCharacters:(NSArray *)array;

@end
