//
//  ViewController.m
//  讯飞语音demo
//
//  Created by Gavin on 16/7/21.
//  Copyright © 2016年 gavin. All rights reserved.
//

#import "ViewController.h"
#import "TextToSpeech.h"
#import "SpeechToText.h"


@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *toSpeech = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:toSpeech];
    [toSpeech setTitle:@"文字转语音" forState:UIControlStateNormal];
    [toSpeech setBackgroundColor:[UIColor orangeColor]];
    [toSpeech setFrame:CGRectMake(0, 100, self.view.frame.size.width, 60)];
    [toSpeech addTarget:self action:@selector(changeToSpeech) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *toText = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:toText];
    [toText setTitle:@"语音转文字" forState:UIControlStateNormal];
    [toText setBackgroundColor:[UIColor orangeColor]];
    [toText setFrame:CGRectMake(0, 260, self.view.frame.size.width, 60)];
    [toText addTarget:self action:@selector(changeToText) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)changeToSpeech {
    TextToSpeech *textToSpeech = [[TextToSpeech alloc] init];
    [self presentViewController: textToSpeech animated:YES completion:nil];
}

- (void)changeToText {
    SpeechToText *speechToText = [[SpeechToText alloc] init];
    [self presentViewController: speechToText animated:YES completion:nil];
}


@end
