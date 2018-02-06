//
//  NSString+Bmob.m
//  ZYXColorNote
//
//  Created by 极客天地 on 2018/2/5.
//  Copyright © 2018年 极客天地. All rights reserved.
//

#import "NSString+Bmob.h"

@implementation NSString (Bmob)
- (NSString *)urlEncodeString{
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodeUrl = [self stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
    return encodeUrl;
}
@end
