CustomKeyboard
==============
[![CI Status](http://img.shields.io/travis/diniska/CustomKeyboard.svg?style=flat)](https://travis-ci.org/diniska/CustomKeyboard)
[![Version](https://img.shields.io/cocoapods/v/DCustomKeyboard.svg?style=flat)](http://cocoadocs.org/docsets/DCustomKeyboard)

Customizable default iOS keyboard


## Installation

### SwiftPM

Add a SwiftPM dependency to your project: `https://github.com/diniska/CustomKeyboard`.


### Cocoapods

The easiest way is to use [CocoaPods](http://cocoapods.org). It takes care of all required frameworks and third party dependencies:
```ruby
pod 'DCustomKeyboard', '~> 0.0'
```

## Usage example

To add **keyboard** to your **UITextView** or **UITextField** use next code
```objective-c
DCustomGridKeyboard *keyboard = [[DCustomGridKeyboard alloc] initWithCharacters:@[
                                                                                 @[@"1", @"2", @"3"],
                                                                                 @[@"4", @"5", @"6"],
                                                                                 @[@"7", @"8", @"9"],
                                                                                 @[kDCustomAbstractKeyboardEmptyCharacter, @"0", kDCustomAbstractKeyboardBackSpaceCharacter]]];
[keyboard applyKeyboardToTextInput:textField];
```

The result is:
![image alt][1]


You can use any characters or strings to put them on keyboard. Also you can layout them as you want. For example there is another object **DCustomLinesKeyboard**
```objective-c
DCustomLinesKeyboard *keyboard = [[DCustomLinesKeyboard alloc] initWithCharactersLines:@[
                                                                                   @[@"А", @"В", @"Е", @"К"],
                                                                                   @[@"М", @"Н", @"О", @"Р"],
                                                                                   @[@"С", @"Т", @"У", @"Х"],
                                                                                   @[kDCustomAbstractKeyboardEmptyCharacter, kDCustomAbstractKeyboardEmptyCharacter, kDCustomAbstractKeyboardBackSpaceCharacter]]];
```

The result is:
![image alt][2]

Use constants 

 - **kDCustomAbstractKeyboardBackSpaceCharacter** - to place backspace
 - **kDCustomAbstractKeyboardEmptyCharacter** - to place empty placeholder


  [1]: https://raw.githubusercontent.com/diniska/CustomKeyboard/master/Examples/numbers_grid_keyboard_example.png
  [2]: https://raw.githubusercontent.com/diniska/CustomKeyboard/master/Examples/characters_grid_keyboard_example.png
