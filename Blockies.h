//
//  Blockies.h
//  NasWallet
//
//  Created by 于宙 on 2018/8/27.
//  Copyright © 2018年 NAS. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IOS || TARGET_OS_WATCH || TARGET_OS_TV
@import UIKit;
typedef UIColor Color;
typedef UIImage Image;
#else
@import AppKit;
typedef NSColor Color;
typedef NSImage Image;
#endif

@interface Blockies : NSObject

/**
 * - parameter seed: The seed to be used for this Blockies.
 * - parameter size: The number of blocks per side for this image. Defaults to 8.
 * - parameter scale: The number of pixels per block. Defaults to 4.
 * - parameter color: The foreground color. Defaults to random.
 * - parameter bgColor: The background color. Defaults to random.
 * - parameter spotColor: A color which forms mouths and eyes. Defaults to random.
 */
@property (nonatomic, copy) NSString *seed;
@property (nonatomic) NSInteger size;
@property (nonatomic) NSInteger scale;
@property (nonatomic, strong) Color *color;
@property (nonatomic, strong) Color *bgColor;
@property (nonatomic, strong) Color *spotColor;

- (Image *)createImage;

+ (Image *)getImgWithSeed:(NSString *)seed;

@end
