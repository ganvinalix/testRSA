//
//  NSString+Base64.h
//  testRSA
//
//  Created by YDX on 16/3/10.
//  Copyright © 2016年 mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Base64)

/**
 *  将文本转换成base64格式字符串
 *
 *  @param text 文本
 *
 *  @return base64格式字符串
 */
+ (NSString *)base64StringFromText:(NSString *)text;

/**
 *  将base64字符串转换成文本
 *
 *  @param base64 base64字符串
 *
 *  @return 文本
 */
+ (NSString *)textFromBase64String:(NSString *)base64;



@end
