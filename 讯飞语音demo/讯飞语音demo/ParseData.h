//
//  ParseData.h
//  讯飞语音demo
//
//  Created by Gavin on 16/7/21.
//  Copyright © 2016年 gavin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseData : NSObject

// 解析命令词返回的结果
+ (NSString*)stringFromAsr:(NSString*)params;

/**
 解析JSON数据
 ****/
+ (NSString *)stringFromJson:(NSString*)params;//


/**
 解析语法识别返回的结果
 ****/
+ (NSString *)stringFromABNFJson:(NSString*)params;

@end
