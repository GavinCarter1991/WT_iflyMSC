//
//  SpeechToText.m
//  讯飞语音demo
//
//  Created by Gavin on 16/7/21.
//  Copyright © 2016年 gavin. All rights reserved.
//

#import "SpeechToText.h"
#import "ParseData.h"
#import "iflyMSC/iflyMSC.h"


@interface SpeechToText()<IFlyRecognizerViewDelegate>{
    //IFlyRecognizerView  带界面的识别对象
}
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;//带界面的识别对象
//不带界面的识别对象
//@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) NSMutableString *curResult;//当前session的结果

@end

@implementation SpeechToText

- (void)viewDidLoad {
    self.curResult = [[NSMutableString alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 24)];
    [self.view addSubview:noteLabel];
    noteLabel.text = @"语音转换后的文字：";
    noteLabel.tintColor = [UIColor grayColor];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height / 2.0)];
    _textView.backgroundColor = [UIColor colorWithRed:0.7117 green:0.7117 blue:0.7117 alpha:1.0];
    [self.view addSubview:_textView];
    
    [self initIFlySpeech];
    // 转换
    UIButton *btnChange = [UIButton buttonWithType:UIButtonTypeCustom];
    btnChange.frame = CGRectMake(0, 0, self.view.frame.size.width,44);
    btnChange.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0 + 180);
    [btnChange setTitle:@"开始录音" forState:UIControlStateNormal];
    btnChange.backgroundColor = [UIColor orangeColor];
    [btnChange addTarget:self action:@selector(startSpeech) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnChange];
    // 关闭
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.frame = CGRectMake(0, 0, 40, 40);
    [btnClose setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClose];
    
    
    // 清空
    UIButton *btnEmpty = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEmpty.frame = CGRectMake(0, 0, self.view.frame.size.width,44);
    [btnEmpty setTitle:@"清空转换结果" forState:UIControlStateNormal];
    btnEmpty.backgroundColor = [UIColor orangeColor];
    btnEmpty.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0 + 220);
    [btnEmpty addTarget:self action:@selector(empty) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnEmpty];
}
- (void)empty {
    [_textView setText:@""];
}
- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)startSpeech {
    
    if(_iflyRecognizerView == nil)
    {
        [self initIFlySpeech ];
    }
    
//    [_textView setText:@""];
    [_textView resignFirstResponder];
    
    //设置音频来源为麦克风
    [_iflyRecognizerView setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iflyRecognizerView setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [_iflyRecognizerView setDelegate:self];
    
    [_iflyRecognizerView start];
}

#pragma mark -- 语音合成
- (void)initIFlySpeech {
    //单例模式，UI的实例
    if (_iflyRecognizerView == nil) {
        //UI显示剧中
        _iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
        
        [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        
    }
    _iflyRecognizerView.delegate = self;
    
    if (_iflyRecognizerView != nil) {
        //设置最长录音时间
        [_iflyRecognizerView setParameter:@"30000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iflyRecognizerView setParameter:@"3000" forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iflyRecognizerView setParameter:@"3000" forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iflyRecognizerView setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iflyRecognizerView setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];

        [_iflyRecognizerView setParameter:[IFlySpeechConstant LANGUAGE_CHINESE] forKey:[IFlySpeechConstant LANGUAGE]];
        //设置方言
        [_iflyRecognizerView setParameter:[IFlySpeechConstant ACCENT_MANDARIN] forKey:[IFlySpeechConstant ACCENT]];

        //设置是否返回标点符号
        [_iflyRecognizerView setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT]];
    }
}

#pragma mark -- 4. IFlyRecognizerViewDelegate识别代理
/*识别结果返回代理
 @param :results识别结果
 @ param :isLast 表示是否最后一次结果
 */

- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast {
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    
    NSString *resultFromJson =  [ParseData stringFromJson:result];
    
    _textView.text = [NSString stringWithFormat:@"%@%@",_textView.text,resultFromJson];
}
/*识别会话结束返回代理
 @ param error 错误码,error.errorCode=0表示正常结束,非0表示发生错误。 */
- (void)onError: (IFlySpeechError *) error {
    NSLog(@"error=%d",error.errorCode);
    NSString *text;
    if (error.errorCode == 0 ) {
        
        if (self.curResult.length == 0 || [self.curResult hasPrefix:@"nomatch"]) {
            text = @"无匹配结果";
        }
        else {
            text = @"识别成功";
        }
    }else {
        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
    }
    NSLog(@"%@",text);
}
/**
 停止录音回调
 ****/
- (void) onEndOfSpeech {
    NSLog(@"停止录音");
}
/**
 开始识别回调
 ****/
- (void) onBeginOfSpeech {
    NSLog(@"开始识别");
}
/**
 音量回调函数 volume 0-30 ****/
- (void) onVolumeChanged: (int)volume {
    NSLog(@"当前音量：%d",volume);
}

-(void)viewWillDisappear:(BOOL)animated {
    NSLog(@"%s",__func__);
    [_iflyRecognizerView cancel]; //取消识别
    [_iflyRecognizerView setDelegate:nil];
    [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    [super viewWillDisappear:animated];
}

@end
