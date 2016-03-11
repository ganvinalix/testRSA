//
//  RsaCrypt.h
//  testRSA
//
//  Created by YDX on 16/3/10.
//  Copyright © 2016年 mini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RsaCrypt : NSObject

+ (SecKeyRef) getPublicKey;
+ (NSData*) rsaEncryptString:(NSString*) string;

@end
