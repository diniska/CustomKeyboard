CustomKeyboard
==============

Cusomizable default iOS keyboard

How to use:

To add **keyboard** to your **UITextView** or **UITextField** use next code

    DCustomGridKeyboard *keyboard = [[DCustomGridKeyboard alloc] initWithCharacters:@[
                                                                                 @[@"1", @"2", @"3"],
                                                                                 @[@"4", @"5", @"6"],
                                                                                 @[@"7", @"8", @"9"],
                                                                                 @[kDCustomAbstractKeyboardEmptyCharacter, @"0", kDCustomAbstractKeyboardBackSpaceCharacter]]];
    [keyboard applyKeyboardToTextInput:textField];

The result is:
![image alt][1]


  [1]: https://github.com/diniska/CustomKeyboard/blob/master/Examples/numbers_grid_keyboard_example.png

You can use any characters or strings to put them on keyboard. Also you can layout them as you want. For example there is another object **DCustomLinesKeyboard**

    DCustomLinesKeyboard *keyboard = [[DCustomLinesKeyboard alloc] initWithCharactersLines:@[
                                                                                   @[@"А", @"В", @"Е", @"К"],
                                                                                   @[@"М", @"Н", @"О", @"Р"],
                                                                                   @[@"С", @"Т", @"У", @"Х"],
                                                                                   @[kDCustomAbstractKeyboardEmptyCharacter, kDCustomAbstractKeyboardEmptyCharacter, kDCustomAbstractKeyboardBackSpaceCharacter]]];

The result is:
![image alt][1]


  [1]: https://github.com/diniska/CustomKeyboard/blob/master/Examples/characters_grid_keyboard_example.png

Use constants

 - **kDCustomAbstractKeyboardBackSpaceCharacter** - to place backspace
 - **kDCustomAbstractKeyboardEmptyCharacter** - to place empty placeholder