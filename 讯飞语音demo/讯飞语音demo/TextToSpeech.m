//
//  TextToSpeech.m
//  讯飞语音demo
//
//  Created by Gavin on 16/7/21.
//  Copyright © 2016年 gavin. All rights reserved.
//

#import "TextToSpeech.h"
#import "iflyMSC/iflyMSC.h"

@interface TextToSpeech()<IFlySpeechSynthesizerDelegate>

// 讯飞语音合成
@property (nonatomic, strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

@property (nonatomic, strong) UITextView *textView;

@end

@implementation TextToSpeech

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 24)];
    [self.view addSubview:noteLabel];
    noteLabel.text = @"请输入需要转换成语音的文字：";
    noteLabel.tintColor = [UIColor grayColor];
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height / 2.0)];
    _textView.backgroundColor = [UIColor colorWithRed:0.7117 green:0.7117 blue:0.7117 alpha:1.0];
    [self.view addSubview:_textView];
    
    [self initIFlySpeech];
    // 转换
    UIButton *btnChange = [UIButton buttonWithType:UIButtonTypeCustom];
    btnChange.frame = CGRectMake(0, 0, 100, 100);
    btnChange.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0 + 200);
    [btnChange setTitle:@"开始识别" forState:UIControlStateNormal];
    btnChange.backgroundColor = [UIColor orangeColor];
    [btnChange addTarget:self action:@selector(startSpeech) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnChange];
    // 关闭
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.frame = CGRectMake(0, 0, 40, 40);
    [btnClose setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClose];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)startSpeech {
    if (_textView.text.length > 0) {
        // 开启异步线程（全局）
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [_iFlySpeechSynthesizer startSpeaking:_textView.text];
            NSLog(@"%@",_textView.text);
        });
    }
}
#pragma mark -- 语音合成
- (void)initIFlySpeech {
    if (self.iFlySpeechSynthesizer == nil) {
        
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
        
    }
    _iFlySpeechSynthesizer.delegate = self;
}
// 语音失败回调代理函数
- (void)onCompleted:(IFlySpeechError *)error {
    
    NSLog(@"Speak Error:{%d:%@}", error.errorCode, error.errorDesc);
}

@end
