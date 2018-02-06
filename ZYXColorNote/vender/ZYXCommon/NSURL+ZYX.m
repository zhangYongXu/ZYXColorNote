//
//  NSURL+ZYX.m
//  RealMall
//
//  Created by 极客天地 on 2017/11/17.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "NSURL+ZYX.h"

@implementation NSURL (ZYX)
+(NSURL *)ZYXURLWithString:(NSString *)string{
    NSString * urlString = [self URLEncodedStringWithString:string];
    NSURL * url = [NSURL URLWithString:urlString];
    return url;
}

+(NSString *)URLEncodedStringWithString:(NSString*)stirng
{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)stirng,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              NULL,
                                                              kCFStringEncodingUTF8));
    return encodedString;
}
@end
