//
//  NSObject+String_Encrypt.h
//  Bloomr
//
//  Created by Tan Tan on 10/5/19.
//  Copyright © 2019 phdv. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Crypto)
- (NSString *) encryptDESByKey:(NSString *)key iv:(NSString*)iv;
- (NSString *) decryptDESByKey:(NSString *)key iv:(NSString*)iv;
@end

NS_ASSUME_NONNULL_END
