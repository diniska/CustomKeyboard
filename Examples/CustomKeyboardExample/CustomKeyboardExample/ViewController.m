//
//  ViewController.m
//  CustomKeyboardExample
//
//  Created by Denis Chaschin on 28.01.15.
//  Copyright (c) 2015 diniska. All rights reserved.
//

#import "ViewController.h"
#import "DCustomGridKeyboard.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    DCustomGridKeyboard *keyboard = [[DCustomGridKeyboard alloc] initWithCharacters:@[
                                                                                      @[@"1", @"2", @"3"],
                                                                                      @[@"4", @"5", @"6"],
                                                                                      @[@"7", @"8", @"9"],
                                                                                      @[kDCustomAbstractKeyboardEmptyCharacter, @"0", kDCustomAbstractKeyboardBackSpaceCharacter]]];
    [keyboard applyKeyboardToTextInput:self.textField];
}

@end
