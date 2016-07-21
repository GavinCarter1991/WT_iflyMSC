//
//  AppDelegate.m
//  讯飞语音demo
//
//  Created by Gavin on 16/7/21.
//  Copyright © 2016年 gavin. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import "iflyMSC/iflyMSC.h"

#define APPID_VALUE @"579036e9"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)configIFlySpeech
{
    [IFlySpeechUtility createUtility:[NSString stringWithFormat:@"appid=%@,timeout=%@",@"5733feca",@"20000"]];
    
    [IFlySetting setLogFile:LVL_NONE];
    [IFlySetting showLogcat:NO];
    
    // 设置语音合成的参数
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];//合成的语速,取值范围 0~100
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"50" forKey:[IFlySpeechConstant VOLUME]];//合成的音量;取值范围 0~100
    
    // 发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]];
    
    // 音频采样率,目前支持的采样率有 16000 和 8000;
    [[IFlySpeechSynthesizer sharedInstance] setParameter:@"8000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    // 当你再不需要保存音频时，请在必要的地方加上这行。
    [[IFlySpeechSynthesizer sharedInstance] setParameter:nil forKey:[IFlySpeechConstant TTS_AUDIO_PATH]];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //显示SDK的版本号
    NSLog(@"verson=%@",[IFlySetting getVersion]);
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    //打开输出在console的log开关
    [IFlySetting showLogcat:NO];
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    // 默认为 NO,设置 YES,则会打印 LOG,如需发布到 appstore 请设置为 NO。
//    [IFlyFlowerCollector SetDebugMode:YES];
    // key id
//    [IFlyFlowerCollector SetAppid:@"579036e9"];
    // 是否上传位置信息
//    [IFlyFlowerCollector SetAutoLocation:NO];
    
    [self configIFlySpeech];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[ViewController alloc]init];
    [self.window makeKeyAndVisible];
    
    
    return YES;
}


@end
