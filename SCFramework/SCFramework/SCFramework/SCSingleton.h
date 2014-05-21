//
//  SCSingleton.h
//  SCFramework
//
//  Created by Angzn on 3/4/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#ifndef SCFramework_SCSingleton_h
#define SCFramework_SCSingleton_h

#if __has_feature(objc_arc)

#define SCSINGLETON(_class_name_)                                                       \
                                                                                        \
+ (_class_name_ *) shared##Instance                                                     \
{                                                                                       \
    static _class_name_ *shared##_class_name_ = nil;                                    \
                                                                                        \
    static dispatch_once_t onceToken;													\
    dispatch_once(&onceToken, ^{                                                        \
        shared##_class_name_ = [[self alloc] init];                                     \
    });                                                                                 \
                                                                                        \
    return shared##_class_name_;                                                        \
}																						\
//+ (_class_name_ *) shared##Instance                                                     \
//{                                                                                       \
//    static _class_name_ *shared##_class_name_ = nil;                                    \
//                                                                                        \
//    @synchronized(self) {                                                               \
//        if (shared##_class_name_ == nil) {                                              \
//            shared##_class_name_ = [[self alloc] init];                                 \
//        }                                                                               \
//    }                                                                                   \
//                                                                                        \
//    return shared##_class_name_;                                                        \
//}                                                                                       \

#else

#define SCSINGLETON(_class_name_)                                                       \
                                                                                        \
+ (_class_name_ *) shared##Instance                                                     \
{                                                                                       \
    static _class_name_ *shared##_class_name_ = nil;                                    \
                                                                                        \
    static dispatch_once_t onceToken;													\
    dispatch_once(&onceToken, ^{                                                        \
        shared##_class_name_ = [[super allocWithZone:NULL] init];                       \
    });                                                                                 \
                                                                                        \
    return shared##_class_name_;                                                        \
}																						\
                                                                                        \
+ (id) allocWithZone:(NSZone *)zone                                                     \
{                                                                                       \
    return [[self shared##Instance] retain];                                            \
}                                                                                       \
                                                                                        \
- (id) copyWithZone:(NSZone *)zone                                                      \
{                                                                                       \
    return self;                                                                        \
}                                                                                       \
                                                                                        \
- (id) retain                                                                           \
{                                                                                       \
    return self;                                                                        \
}                                                                                       \
                                                                                        \
- (NSUInteger) retainCount                                                              \
{                                                                                       \
    return NSUIntegerMax;  /* so the singleton object cannot be released */             \
}                                                                                       \
                                                                                        \
- (oneway void) release                                                                 \
{                                                                                       \
                                                                                        \
}                                                                                       \
                                                                                        \
- (id) autorelease                                                                      \
{                                                                                       \
    return self;                                                                        \
}                                                                                       \

#endif

#endif
