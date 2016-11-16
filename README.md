# CHLUUID
UDID的代替UUID+Keychain

      使用方便
```[CHLUUID obtainUUID];```

      这种用UUID代替的设备唯一标识码，其中UUID的获取方法是

```CFUUIDRef uuidObj = CFUUIDCreate(nil);\n
   NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);\n
   CFRelease(uuidObj);```
  
      
      
```再通过Keychain保存到手机，这样即使删除了应用UUID也不会被删除，我们只需要在取的时候做一个简单的判断，就能拿到唯一的标识
 (注意：用户完全还原手机，会被删除）
      
