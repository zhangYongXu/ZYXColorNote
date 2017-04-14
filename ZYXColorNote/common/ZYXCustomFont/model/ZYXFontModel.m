//
//  ZYXFontModel.m
//  TourNote
//
//  Created by 极客天地 on 2017/2/6.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "ZYXFontModel.h"

#import <CoreText/CoreText.h>

#import "YXFileOrDirItemModel.h"

@implementation ZYXFontModel
-(NSString *)showImageUrl{
    if(!DICTIONARY_IS_EMPTY(self.showImage)){
        _showImageUrl = self.showImage[@"url"];
    }
    return _showImageUrl;
}
-(NSString *)fontFileUrl{
    if(!DICTIONARY_IS_EMPTY(self.fontFile)){
        _fontFileUrl = self.fontFile[@"url"];
    }
    return _fontFileUrl;
}
-(NSString *)fontLocalFilePath{
    if(!STR_IS_NIL(self.fontFileUrl)){
        NSString * fileName = [NSString stringWithFormat:@"%@.ttf",[self.fontFileUrl md5]];
        NSString * filePath= [YXFileOrDirItemModel.documentDir stringByAppendingPathComponent:fileName];
        _fontLocalFilePath = filePath;
    }
    return _fontLocalFilePath;
}
-(BOOL)isExistfontLocalFile{
    NSFileManager * FM = [NSFileManager defaultManager];
    _isExistfontLocalFile = [FM fileExistsAtPath:self.fontLocalFilePath];
    return _isExistfontLocalFile;
}
-(UIFont *)fontWithFontSize:(NSInteger)fontSize{
    NSURL * url = [[NSURL alloc] initFileURLWithPath:self.fontLocalFilePath];
    UIFont * font = [ZYXFontModel customFontWithFontUrl:url size:fontSize];
    self.fontName = font.fontName;
    return font;
}

+(UIFont*)customFontWithFontUrl:(NSURL*)customFontUrl size:(CGFloat)size
{
    NSURL *fontUrl = customFontUrl;
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CFErrorRef error;
    bool isSuccess = CTFontManagerRegisterGraphicsFont(fontRef, &error);
    if(!isSuccess){
        //如果注册失败，则不使用
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
    }
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    UIFont *font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(fontRef);
    return font;
}
@end
