//
//  Crypt.m
//  IBOS-IOS
//
//  Created by IBOS on 15/4/20.
//  Copyright (c) 2015年 IBOS. All rights reserved.
//

#import "cryptor.h"
#import "polarssl/aes.h"
#import <CommonCrypto/CommonCrypto.h>
#import "polarssl/base64.h"

void cryptor_md5(const void *data,NSUInteger len, char *md)
{
    const char* utfStr = (const char *)data;
    unsigned char szMd[16] = {0};
    CC_MD5(utfStr,(CC_LONG)strlen(utfStr),szMd);
    memset(md, 0, 32);
    for (int index = 0; index < 16; index++) {
        unsigned char src = szMd[index];
        sprintf(md, "%s%02X",md,src);
    }
}

void cryptor_sha1(const void *data,NSUInteger len, char *md)
{
    const char* utfStr = (const char *)data;
    unsigned char szMd[20] = {0};
    CC_SHA1(utfStr,(CC_LONG)strlen(utfStr),szMd);
    memset(md, 0, 40);
    for (int index = 0; index < 20; index++) {
        unsigned char src = szMd[index];
        sprintf(md, "%s%02X",md,src);
    }
}

// aes解密
NSInteger cryptor_aes_decrypt(char *content, NSUInteger len, const char *key, NSInteger bit )
{
    if (!content || !key || len <= 0) {
        return -1;
    }
    NSInteger bytes = bit / 8;    // bit count
    NSInteger loopCount = len / bytes;
    aes_context ctx;
    aes_setkey_dec(&ctx, (unsigned char*)key, (unsigned int)bit);
    NSInteger PKCS7Code = 0;
    ctx.nr = 10;
    for (int i = 0; i < loopCount; i++) {
        aes_crypt_ecb(&ctx, AES_DECRYPT, (uint8_t *)content + bytes * i, (uint8_t *)content + bytes * i);
    }
    PKCS7Code = (content[len - 1]);
    
    memset(content + len - PKCS7Code, 0, PKCS7Code);
    //补码是0，则去掉后面的16位
    if (PKCS7Code == 0x00) {
        len -= 16;
    }else{
        len -= PKCS7Code;
    }
    return len;
}

// aes加密
NSInteger cryptor_aes_encrypt(const char *content, NSUInteger size, char **dstContent,const char *key, NSUInteger bit )
{
    NSUInteger dstSize = 0;
    if (!content || !key || size <= 0) {
        return -1;
    }
    if (bit != 128 && bit != 192 && bit != 256) {
        return  -1;
    }
    //set key
    aes_context ctx;
    aes_setkey_enc(&ctx, (unsigned char*)key, (unsigned int)bit);
    
    int bytes = (unsigned int)bit / 8;    //bit count
    
    int dataLen = (int)size;
    int lmod = bytes;
    if (size >= bytes) {
        lmod = size % bytes;
        if (lmod != 0) {
            lmod = bytes - lmod;
        }
    }
    if (size < bytes) {
        lmod = (int)(bytes - size);
    }
    int PKCS7Code = lmod;
    
    size += PKCS7Code == 0 ? 16 : PKCS7Code;
    
    int loopcount = (int)(size / bytes);
    dstSize = size;
    *dstContent = (char *)malloc(size);
    memset(*dstContent, lmod, size);
    memcpy(*dstContent, content, dataLen);
    
    for (int i = 0; i < loopcount; i++) {
        aes_crypt_ecb(&ctx, AES_ENCRYPT, (uint8_t *)*dstContent + bytes * i, (uint8_t *)*dstContent + bytes * i);
    }
    return dstSize;
}


NSInteger cryptor_base64_encode( unsigned char *dst, unsigned int *dlen,const unsigned char *src, unsigned int slen )
{
    return polarssl_base64_encode(dst, dlen, src, slen);
}


NSInteger cryptor_base64_decode( unsigned char *dst, unsigned int *dlen,const unsigned char *src, unsigned int slen )
{
    return polarssl_base64_decode(dst, dlen, src, slen);
}


