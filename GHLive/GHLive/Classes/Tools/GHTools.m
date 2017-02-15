
//
//  GHTools.m
//  GHLive
//
//  Created by kalian on 2017/2/15.
//  Copyright © 2017年 kalian. All rights reserved.
//

#import "GHTools.h"

@implementation GHTools

+(UIColor*)colorWithHexString:(NSString*)hexString andAlpha:(float)alpha {
    UIColor *col;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#"
                                                     withString:@"0x"];
    uint hexValue;
    if ([[NSScanner scannerWithString:hexString] scanHexInt:&hexValue]) {
        col = [self colorWithHexValue:hexValue andAlpha:alpha];
    } else {
        // invalid hex string
        col = [UIColor blackColor];
    }
    return col;
}
+(UIColor*)colorWithHexValue:(uint)hexValue andAlpha:(float)alpha {
    return [UIColor
            colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
            green:((float)((hexValue & 0xFF00) >> 8))/255.0
            blue:((float)(hexValue & 0xFF))/255.0
            alpha:alpha];
}
@end
