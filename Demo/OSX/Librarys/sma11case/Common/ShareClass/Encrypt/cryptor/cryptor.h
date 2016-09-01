//
//  Crypt.h
//  IBOS-IOS
//
//  Created by IBOS on 15/4/20.
//  Copyright (c) 2015年 IBOS. All rights reserved.
//

#ifndef CRYPT_C_H_
#define CRYPT_C_H_

#import <Foundation/Foundation.h>
#import "polarssl/base64.h"


// aes 256位加密
#define AES_KEY_SIZE_256 256
// aes 192 位加密
#define AES_KEY_SIZE_192 192
// aes 128位加密
#define AES_KEY_SIZE_128 128

#ifdef __cplusplus
extern "C" {
#endif

/**
 *  获取md5校验值,大写
 *
 *  @param data 源数据
 *  @param len  数据长度
 *  @param md   最终得到的md5校验值（这里已经转换为16进制的形式），注意：该缓冲区最少要有32个字节，否则会出错
 */
void cryptor_md5(const void *data,NSUInteger len, char *md);

/**
 *  获取sha1校验值，大写
 *
 *  @param data 源数据
 *  @param len  数据长度
 *  @param md   最终得到的sha1校验值（这里已经转换为16进制的形式），注意：该缓冲区最少要有40个字节，否则会出错
 */
void cryptor_sha1(const void *data,NSUInteger len, char *md);

/**
 *  aes解密,使用的是ecb
 *
 *  @param content 要解密的数据，同时解密后的数据也是存放在这里
 *  @param len     源数据长度
 *  @param key     密钥
 *  @param bit     使用的是128还是256位解密
 *
 *  @return 解密后的数据长度,-1代表参数有错
 */
NSInteger cryptor_aes_decrypt(char *content, NSUInteger len, const char *key, NSInteger bit );

/**
 *  aes加密，使用的是ecb
 *
 *  @param content    要加密的数据
 *  @param size       源数据大小
 *  @param dstContent 解密后的数据,注意：函数内会使用malloc分配空间，所以外部使用要自己释放
 *  @param key        密钥
 *  @param bit        使用的是128还是256位解密
 *
 *  @return 加密后的数据长度,-1代表参数有错
 */
NSInteger cryptor_aes_encrypt(const char *content, NSUInteger size, char **dstContent,const char *key, NSUInteger bit );

/**
 *  base64编码
 *
 *  @param dst  编码后的数据
 *  @param dlen dst的大小
 *  @param src  要编码的数据
 *  @param slen src的大小
 *
 *  @return 0是成功,或者POLARSSL_ERR_BASE64_BUFFER_TOO_SMALL
 */
NSInteger cryptor_base64_encode( unsigned char *dst, unsigned int *dlen,const unsigned char *src, unsigned int slen );

/**
 *  base64解码
 *
 *  @param dst  解码后的数据
 *  @param dlen dst的大小
 *  @param src  要解码的数据
 *  @param slen src的大小
 *
 *  @return 0是成功，或者POLARSSL_ERR_BASE64_BUFFER_TOO_SMALL, or
 *                 POLARSSL_ERR_BASE64_INVALID_CHARACTER
 */
NSInteger cryptor_base64_decode( unsigned char *dst, unsigned int *dlen,const unsigned char *src, unsigned int slen );


#ifdef __cplusplus
}
#endif
#endif