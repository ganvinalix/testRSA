//
//  RsaCrypt.m
//  testRSA
//
//  Created by YDX on 16/3/10.
//  Copyright © 2016年 mini. All rights reserved.
//

#import "RsaCrypt.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonCrypto.h>

@implementation RsaCrypt

// 我们在前面使用openssl生成的public_key.der文件的base64值，用你自己的替换掉这里
#define RSA_KEY_BASE64 @"MIIC5DCCAk2gAwIBAgIJALUk4hrYth9oMA0GCSqGSIb3DQEBBQUAMIGKMQswCQYDVQQGEwJ\
DTjERMA8GA1UECAwIU2hhbmdoYWkxETAPBgNVBAcMCFNoYW5naGFpMQ4wDAYDVQQKDAVCYWl5aTEOMAwGA1UECwwFQmFpeWk\
xEDAOBgNVBAMMB1lvcmsuR3UxIzAhBgkqhkiG9w0BCQEWFGd5cTUzMTk5MjBAZ21haWwuY29tMB4XDTExMTAyNjAyNDUzMlo\
XDTExMTEyNTAyNDUzM1owgYoxCzAJBgNVBAYTAkNOMREwDwYDVQQIDAhTaGFuZ2hhaTERMA8GA1UEBwwIU2hhbmdoYWkxDjA\
MBgNVBAoMBUJhaXlpMQ4wDAYDVQQLDAVCYWl5aTEQMA4GA1UEAwwHWW9yay5HdTEjMCEGCSqGSIb3DQEJARYUZ3lxNTMxOTk\
yMEBnbWFpbC5jb20wgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAK3cKya7oOi8jVMkRGVuNn/SiSS1y5knKLh6t98JukB\
DJZqo30LVPXXL9nHcYXBTulJgzutCOGQxw8ODfAKvXYxmX7QvLwlJRFEzrqzi3eAM2FYtZZeKbgV6PximOwCG6DqaFqd8X0W\
ezP1B2eWKz4kLIuSUKOmt0h3RpIPkatPBAgMBAAGjUDBOMB0GA1UdDgQWBBSIiLi2mehEgi/MwRZOld1mLlhl7TAfBgNVHSM\
EGDAWgBSIiLi2mehEgi/MwRZOld1mLlhl7TAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBBQUAA4GBAB0GUsssoVEDs9vQxk0\
DzNr8pB0idfI+Farl46OZnW5ZwPu3dvSmhQ+yRdh7Ba54JCyvRy0JcWB+fZgO4QorNRbVVbBSuPg6wLzPuasy9TpmaaYaLLK\
Iena6Z60aFWRwhazd6+hIsKTMTExaWjndblEbhAsjdpg6QMsKurs9+izr"

//NSString base64-->  NSData
static SecKeyRef _public_key=nil;
+ (SecKeyRef) getPublicKey{ // 从公钥证书文件中获取到公钥的SecKeyRef指针
    if(_public_key == nil){
//        NSData *certificateData = [Base64 decode:RSA_KEY_BASE64];
        NSData *base64Data = [RSA_KEY_BASE64 dataUsingEncoding:NSUTF8StringEncoding];
        NSData *certificateData = [base64Data initWithBase64EncodedData:base64Data options:0];
        NSString *str = [[NSString alloc] initWithData:certificateData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", str);

        SecCertificateRef myCertificate =  SecCertificateCreateWithData(kCFAllocatorDefault, (CFDataRef)certificateData);
        SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
        SecTrustRef myTrust;
        OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
        SecTrustResultType trustResult;
        if (status == noErr) {
            status = SecTrustEvaluate(myTrust, &trustResult);
        }
        _public_key = SecTrustCopyPublicKey(myTrust);
        CFRelease(myCertificate);
        CFRelease(myPolicy);
        CFRelease(myTrust);
    }
    return _public_key;
}

+ (NSData*) rsaEncryptString:(NSString*) string{
    SecKeyRef key = [self getPublicKey];
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    NSData *stringBytes = [string dataUsingEncoding:NSUTF8StringEncoding];
    size_t blockSize = cipherBufferSize - 11;
    size_t blockCount = (size_t)ceil([stringBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init];
    for (int i=0; i<blockCount; i++) {
        int bufferSize = MIN(blockSize,[stringBytes length] - i * blockSize);
        NSData *buffer = [stringBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(key, kSecPaddingPKCS1, (const uint8_t *)[buffer bytes],
                                        [buffer length], cipherBuffer, &cipherBufferSize);
        if (status == noErr){
            NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        }else{
            if (cipherBuffer) free(cipherBuffer);
            return nil;
        }
    }
    if (cipherBuffer) free(cipherBuffer);
    //  NSLog(@"Encrypted text (%d bytes): %@", [encryptedData length], [encryptedData description]);
    //  NSLog(@"Encrypted text base64: %@", [Base64 encode:encryptedData]);
    return encryptedData;
}

@end
