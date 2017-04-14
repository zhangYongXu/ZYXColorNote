//
//  ZYXFontModel.h
//  TourNote
//
//  Created by 极客天地 on 2017/2/6.
//  Copyright © 2017年 极客天地. All rights reserved.
//

#import "GWRootModel.h"

@interface ZYXFontModel : GWRootModel
@property(copy,nonatomic) NSString * fontID;
@property(copy,nonatomic) NSString * fontName;
@property(copy,nonatomic) NSString * fontFileUrl;
@property(copy,nonatomic) NSString * fontLocalFilePath;
@property(assign,nonatomic) BOOL isExistfontLocalFile;
@property(copy,nonatomic) NSString * showImageUrl;


@property(strong,nonatomic) NSDictionary * showImage;
@property(strong,nonatomic) NSDictionary * fontFile;
@property(copy,nonatomic) NSString * fontFileName;

-(UIFont*)fontWithFontSize:(NSInteger)fontSize;

+(UIFont*)customFontWithFontUrl:(NSURL*)customFontUrl size:(CGFloat)size;
@end
