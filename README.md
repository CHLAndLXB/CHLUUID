# CHLUUID
首先我们来了解一下UDID是什么？

> UDID的全名为 Unique Device Identifier :设备唯一标识符。从名称上也可以看出，UDID这个东西是和设备有关的，而且是只和设备有关的，有点类似于MAC地址。需要把UDID这个东西添加到Provisoning Profile授权文件中，也就是把设备唯一标识符添加进去，以此来识别某一台设备。

在应用开发过程中，UDID有什么作用呢。有的时候，后台需要我们传一个唯一标识给他，用做区分每台手机。而且程序卸载后再重新装上都不会改变。在iOS5以前，苹果提供了直接获取UDID的方法

```
NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;                                                   
NSLog(@"uuid = %@",uuid.UUIDString);
```

很遗憾，在iOS5以后得版本，苹果已经把这个干掉了。那么，如果我们需要用到UDID，也就唯一标识，那我们用什么代替呢。

那么正餐来了。以下方法亲测可行，不行你打我。


用以下方法获取到UUID

```
+ (NSString*) getUUIDString{

    CFUUIDRef uuidObj = CFUUIDCreate(nil);

    NSString *uuidString = (__bridge_transferNSString*)CFUUIDCreateString(nil, uuidObj);

    CFRelease(uuidObj);

    return  uuidString;
}
```
在将此UUID保存到钥匙串（每台手机都有一个钥匙串，即使删除应用，里面保存的东西也不会被删除。但是完全还原手机就会被删除）中。

```
+(void)save:(NSString *)service data:(id)data {

    NSMutableDictionary *keychainQuery = [CHLUUID getKeychainQuery:service];

    SecItemDelete((CFDictionaryRef)keychainQuery);

    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];

    SecItemAdd((CFDictionaryRef)keychainQuery,NULL);

}
```
这样即使应用删除，下载再装上应用，也能获得唯一的标识。从后台拿到原先的数据了。
