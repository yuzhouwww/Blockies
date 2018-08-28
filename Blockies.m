//
//  Blockies.m
//  NasWallet
//
//  Created by 于宙 on 2018/8/27.
//  Copyright © 2018年 NAS. All rights reserved.
//

#import "Blockies.h"

@implementation Blockies {
    NSMutableArray<NSNumber *> *randSeed;
}

+ (Image *)getImgWithSeed:(NSString *)seed {
    Blockies *blockies = [Blockies new];
    blockies.seed = seed;
    return [blockies createImage];
}

- (Image *)createImage {
    randSeed = [self createRandSeed:_seed];
    _size = _size ?: 8;
    _scale = _scale ?: 4;
    _color = _color ?: [self createColor];
    _bgColor =  _bgColor ?: [self createColor];
    _spotColor = _spotColor ?: [self createColor];
    
    NSArray *data = [self createImageData];
    Image *image = [self imageWithData:data customScale:1];
    return image;
}

- (NSArray<NSNumber *> *)createImageData {
    NSInteger width = self.size;
    NSInteger height = self.size;
    NSInteger dataWidth = (NSInteger)ceil(width * 0.5f);
    NSInteger mirrorWidth = width - dataWidth;
    
    NSMutableArray *data = [NSMutableArray array];
    for (int i = 0; i < height; i ++) {
        NSMutableArray *row = [NSMutableArray arrayWithCapacity:dataWidth];
        for (int a = 0; a < dataWidth; a++) {
            [row addObject:@(0)];
        }
        for (int j = 0; j < dataWidth; j++) {
            row[j] = @((NSInteger)(floor([self rand] * 2.3f)));
        }
        for (NSInteger k = mirrorWidth - 1; k >= 0; k--) {
            [row addObject:row[k]];
        }
        [data addObjectsFromArray:row];
    }
    return data.copy;
}

- (Image *)imageWithData:(NSArray<NSNumber *> *)data customScale:(NSInteger)customScale {
    NSInteger finalSize = _size * _scale * customScale;
    
#if TARGET_OS_IOS || TARGET_OS_WATCH || TARGET_OS_TV
    UIGraphicsBeginImageContext(CGSizeMake(finalSize, finalSize));
    CGContextRef nilContext = UIGraphicsGetCurrentContext();
#else
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef nilContext = CGBitmapContextCreate(NULL, finalSize, finalSize, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
#endif
    
    if (!nilContext) {
        return nil;
    }
    
    NSInteger width = (NSInteger)sqrt((double)data.count);
    CGContextSetFillColorWithColor(nilContext, _bgColor.CGColor);
    CGContextFillRect(nilContext, CGRectMake(0, 0, _size * _scale, _size * _scale));
    
    for (int i = 0; i < data.count; i ++) {
        NSInteger row = (NSInteger)(floor(1.0f * i / width));
        NSInteger col = i % width;
        
        NSInteger number = data[i].intValue;
        
        Color *uiColor = nil;
        if (number == 0) {
            uiColor = _bgColor;
        } else if (number == 1) {
            uiColor = _color;
        } else if (number == 2) {
            uiColor = _spotColor;
        } else {
            uiColor = [Color blackColor];
        }
        
        CGContextSetFillColorWithColor(nilContext, uiColor.CGColor);
        CGContextFillRect(nilContext, CGRectMake(col * _scale *customScale, row * _scale *customScale, _scale * customScale, _scale * customScale));
    }
#if TARGET_OS_IOS || TARGET_OS_WATCH || TARGET_OS_TV
    Image *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
#else
    CGImageRef image = CGBitmapContextCreateImage(nilContext);
    return [[NSImage alloc] initWithCGImage:image size:NSMakeSize(finalSize, finalSize)];
#endif
}

- (NSMutableArray<NSNumber *> *)createRandSeed:(NSString *)seed {
    NSMutableArray<NSNumber *> *randSeed = @[@(0), @(0), @(0), @(0)].mutableCopy;
    for (int i = 0; i < seed.length; i++) {
        NSInteger a = (randSeed[i % 4].intValue * (2 << 4)) - randSeed[i % 4].intValue;
        [randSeed replaceObjectAtIndex:i % 4 withObject:@(a)];
        
        NSInteger b = randSeed[i % 4].intValue + (int)[seed characterAtIndex:i];
        [randSeed replaceObjectAtIndex:i % 4 withObject:@(b)];
    }
    return randSeed;
}

- (double)rand {
    double t = randSeed[0].intValue ^ (randSeed[0].intValue << 11);
    
    randSeed[0] = randSeed[1];
    randSeed[1] = randSeed[2];
    randSeed[2] = randSeed[3];
    SInt32 tmp = (SInt32)randSeed[3].intValue;
    SInt32 tmpT = (SInt32)t;
    randSeed[3] = @((tmp ^ (tmp >> 19) ^ tmpT ^ (tmpT >> 8)));
    
    SInt32 divisor = INT32_MAX;
    
    double ret = (double)((UInt32)(randSeed[3].intValue >> (UInt32)0)) / (double)divisor;
    return ret;
}

- (Color *)createColor {
    double h = [self rand] * 360;
    double s = (([self rand] * 60) + 40) / 100;
    double l = ([self rand] + [self rand] + [self rand] + [self rand]) * 25 / 100;
    
    double c = (1 - fabs(2 * l - 1)) * s;
    double x = c * (1 - fabs(h / 60 - floor(h / 60 / 2) * 2 - 1));
    
    double m = l - (c / 2);
    
    double tmpR, tmpG, tmpB;
    if (0 <= h && h < 60) {
        tmpR = c;
        tmpG = x;
        tmpB = 0;
    } else if (60 <= h && h < 120) {
        tmpR = x;
        tmpG = c;
        tmpB = 0;
    } else if (120 <= h && h < 180) {
        tmpR = 0;
        tmpG = c;
        tmpB = x;
    } else if (180 <= h && h < 240) {
        tmpR = 0;
        tmpG = x;
        tmpB = c;
    } else if (240 <= h && h < 300) {
        tmpR = x;
        tmpG = 0;
        tmpB = c;
    } else if (300 <= h && h < 360) {
        tmpR = c;
        tmpG = 0;
        tmpB = x;
    } else {
        return [Color blackColor];
    }
    
    double r = (tmpR + m);
    double g = (tmpG + m);
    double b = (tmpB + m);
    
    return [Color colorWithRed:r green:g blue:b alpha:1];
}

@end
