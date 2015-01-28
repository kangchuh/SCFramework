//
//  SCMacro.h
//  SCFramework
//
//  Created by Angzn on 3/4/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#ifndef SCFramework_SCMacro_h
#define SCFramework_SCMacro_h

// -------------------------- OS -------------------------- //
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
#define kSC_iOS7_OR_LATER       ([[[UIDevice currentDevice] systemVersion] \
                                            compare:@"7.0"] != NSOrderedAscending)
#else
#define kSC_iOS7_OR_LATER       (NO)
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
#define kSC_iOS8_OR_LATER       ([[[UIDevice currentDevice] systemVersion] \
                                            compare:@"8.0"] != NSOrderedAscending)
#else
#define kSC_iOS8_OR_LATER       (NO)
#endif

#define kSC_SYSTEM_VERSION_F    ([[[UIDevice currentDevice] systemVersion] floatValue])
#define kSC_SYSTEM_VERSION_D    ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define kSC_SYSTEM_VERSION_S    ([[UIDevice currentDevice] systemVersion])

#define kSC_CURRENT_LANGUAGE    ([[NSLocale preferredLanguages] firstObject])

#define kSC_iPad                (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kSC_iPhone              (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define kSC_PORTRAIT            (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
#define kSC_LANDSCAPE           (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))

// -------------------------- 常用宏常量 -------------------------- //
#define kSC_KEY_WINDOW          ([[UIApplication sharedApplication] keyWindow])

#define kSC_MAIN_SCREEN_SCALE   ([[UIScreen mainScreen] scale])

#define kSC_APP_FRAME           ([[UIScreen mainScreen] applicationFrame])
#define kSC_APP_FRAME_HEIGHT    ([[UIScreen mainScreen] applicationFrame].size.height)
#define kSC_APP_FRAME_WIDTH     ([[UIScreen mainScreen] applicationFrame].size.width)

#define kSC_MAIN_SCREEN_HEIGHT  ([[UIScreen mainScreen] bounds].size.height)
#define kSC_MAIN_SCREEN_WIDTH   ([[UIScreen mainScreen] bounds].size.width)

#define kSC_APP_TEMPORARY_DIRECTORY NSTemporaryDirectory()
#define kSC_APP_CACHES_DIRECTORY    NSSearchPathForDirectoriesInDomains(NSCachesDirectory, \
                                                                        NSUserDomainMask, \
                                                                        YES)
#define kSC_APP_DOCUMENT_DIRECTORY  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, \
                                                                        NSUserDomainMask, \
                                                                        YES)

// -------------------------- 常用宏方法 -------------------------- //
#define kSCPNGPATH(NAME)           [[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]
#define kSCJPGPATH(NAME)           [[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]
#define kSCPATH(NAME, EXT)         [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]

#define kSCPNGIMAGE(NAME)          [UIImage imageWithContentsOfFile:\
                                    [[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define kSCJPGIMAGE(NAME)          [UIImage imageWithContentsOfFile:\
                                    [[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define kSCIMAGE(NAME, EXT)        [UIImage imageWithContentsOfFile:\
                                    [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]

#define kSCBOLDSYSTEMFONT(FONTSIZE) [UIFont boldSystemFontOfSize:FONTSIZE]
#define kSCSYSTEMFONT(FONTSIZE)     [UIFont systemFontOfSize:FONTSIZE]
#define kSCFONT(NAME, FONTSIZE)     [UIFont fontWithName:(NAME) size:(FONTSIZE)]

#endif
