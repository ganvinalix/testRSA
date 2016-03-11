//
//  ViewController.m
//  testRSA
//
//  Created by YDX on 16/3/10.
//  Copyright © 2016年 mini. All rights reserved.
//

#import "ViewController.h"
#import <Security/Security.h>
#import "XHCryptorTools.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [RsaCrypt getPublicKey];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    XHCryptorTools *tools = [[XHCryptorTools alloc]init];
    // 1. 加载公钥
    NSString *pubPath = [[NSBundle mainBundle] pathForResource:@"rsacert.der" ofType:nil];
    [tools loadPublicKeyWithFilePath:pubPath];
    // 2. 使用公钥加密,加密内容最大长度为117
    NSString *result = [tools RSAEncryptString:@"I love you!"];
    NSLog(@"加密 = %@",result);
    
    // 解密:加载私钥,并指定导出 p12 时设置的密码
    NSString *privatePath = [[NSBundle mainBundle] pathForResource:@"p.p12" ofType:nil];
    [tools loadPrivateKey:privatePath password:@"123456"];
    // 使用私钥解密
    NSLog(@"解密结果:%@", [tools RSADecryptString:result]);
}
@end
