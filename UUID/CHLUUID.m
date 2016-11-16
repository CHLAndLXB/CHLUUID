//
//  CHLUUID.m
//  UUID
//
//  Created by huochaihy on 2016/11/16.
//  Copyright © 2016年 CHLdemo.com. All rights reserved.
//

#import "CHLUUID.h"

#define UUID_KEYCHAIN @"UUIDKeyChain"

@implementation CHLUUID


+(NSString *)obtainUUID{
    
    NSMutableDictionary *UUIDKeyChain = (NSMutableDictionary *)[self load:UUID_KEYCHAIN];
    NSString * uuid = [NSString string];
    if (![UUIDKeyChain objectForKey:@"uuidkey"]) {
        uuid = [CHLUUID getUUIDString];
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        [dic setObject:uuid forKey:@"uuidkey"];
        [CHLUUID save:UUID_KEYCHAIN data:dic];
    }else{
        uuid = [UUIDKeyChain objectForKey:@"uuidkey"];
    }
    
    return uuid;
}

+ (NSString*) getUUIDString
{
    
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    
    CFRelease(uuidObj);
    
    return uuidString;
    
}

+(void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [CHLUUID getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}


+(NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,nil];
}


+(id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [CHLUUID getKeychainQuery:service];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

- (void)deleteuuid{
    NSMutableDictionary *keychainQuery = [CHLUUID getKeychainQuery:UUID_KEYCHAIN];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}
@end
