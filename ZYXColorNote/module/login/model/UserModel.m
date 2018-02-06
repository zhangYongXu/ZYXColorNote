//
//  UserModel.m
//  LuNengHotel
//
//  Created by 拓之林 on 16/3/28.
//  Copyright © 2016年 拓之林. All rights reserved.
//

#import "UserModel.h"
#import "pinyin.h"

@implementation UserModel
-(void)setValue:(id)value forKey:(NSString *)key{
    if([key isEqualToString:@"education"]){
        if([value isKindOfClass:[NSString class]]){
            if(STR_IS_NIL(value)){
                value = @"-1";
            }
        }
    }
    [super setValue:value forKey:key];
}
-(NSString*)firstLetter{
    if(STR_IS_NIL(_firstLetter)){
        NSString *firstLetter = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([self.nick_name characterAtIndex:0])] uppercaseString];
        NSRange range = [ALPHA rangeOfString:firstLetter];
        if (NSNotFound == range.location) {
            firstLetter = @"#";
        }
        _firstLetter = firstLetter;
    }
    return _firstLetter;
}
-(NSString *)HXId{
    //return [NSString stringWithFormat:@"%@",self.user_name];
    return self.user_Hx_id;
}
-(NSString *)nick_name{
    if(STR_IS_NIL(_nick_name)){
        return self.user_name;
    }else{
        return _nick_name;
    }
}
-(NSString *)user_name{
    if(STR_IS_NIL(_user_name)){
        return _phone;
    }else{
        return _user_name;
    }
}
-(NSString *)educationString{
    return [UserModel stringEducationWithType:self.education];
}
+(NSString *)stringEducationWithType:(EducationTypes)type{
    NSString * eString = @"";
    switch (type) {
        case EducationTypePrimarySchool:
            eString = @"小学";
            break;
        case EducationTypeMiddleSchool:
            eString = @"初中";
            break;
        case EducationTypeHighSchool:
            eString = @"中专/高中";
            break;
        case EducationTypeUniversity:
            eString = @"专科/本科";
            break;
        case EducationTypePostgraduate:
            eString = @"硕士研究生";
            break;
        case EducationTypeDoctor:
            eString = @"博士研究生";
            break;
        default:
            break;
    }
    return eString;
}
+(EducationTypes)educationWithString:(NSString*)string{
    EducationTypes type = EducationTypePrimarySchool;
    if([string isEqualToString:[self stringEducationWithType:EducationTypePrimarySchool]]){
        type = EducationTypePrimarySchool;
    }else if([string isEqualToString:[self stringEducationWithType:EducationTypeMiddleSchool]]){
        type = EducationTypeMiddleSchool;
    }else if([string isEqualToString:[self stringEducationWithType:EducationTypeHighSchool]]){
        type = EducationTypeHighSchool;
    }else if([string isEqualToString:[self stringEducationWithType:EducationTypeUniversity]]){
        type = EducationTypeUniversity;
    }else if([string isEqualToString:[self stringEducationWithType:EducationTypePostgraduate]]){
        type = EducationTypePostgraduate;
    }else if([string isEqualToString:[self stringEducationWithType:EducationTypeDoctor]]){
        type = EducationTypeDoctor;
    }else{
        type = EducationTypeNone;
    }
    return type;
}
-(NSString *)img_url{
    if(STR_IS_NIL(_img_url)){
        _img_url = self.headerImageUrl[@"url"];
        return _img_url;
    }else{
        return _img_url;
    }
}
-(NSString *)sexString{
    return [UserModel stringSexWithType:self.sex];
}
+(NSString *)stringSexWithType:(SexTypes)type{
    NSString * sexString = nil;
    switch (type) {
        case SexTypeMale:
            sexString = @"男";
            break;
        case SexTypeFemale:
            sexString = @"女";
            break;
        default:
            break;
    }
    return sexString;
}
+(SexTypes)sexWithString:(NSString *)string{
    SexTypes type = SexTypeMale;
    if([string isEqualToString:[self stringSexWithType:SexTypeMale]]){
        type = SexTypeMale;
    }else if([string isEqualToString:[self stringSexWithType:SexTypeFemale]]){
        type = SexTypeFemale;
    }
    return type;
}

-(NSString *)userHomePath{
    NSString* u_id = [NSString stringWithFormat:@"%@",@(self.u_id)];
    if(STR_IS_NIL(u_id)){
        u_id=@"未登录";
    }
    NSString* homePath = [self getDocDirctoryByFileName:u_id];
    if([[NSFileManager defaultManager]fileExistsAtPath:homePath]){
        _userHomePath = homePath;
    }else{
        [[NSFileManager defaultManager]createDirectoryAtPath:homePath withIntermediateDirectories:YES attributes:nil error:nil];
        _userHomePath = homePath;
    }
    return _userHomePath;
}

- (NSString*)getDocDirctoryByFileName:(NSString*)fname
{
    NSString* fileDir = nil;
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0) {
        NSString* documentDirectory = [paths objectAtIndex:0];
        NSLog(@" user document directory : %@", documentDirectory);
        if(documentDirectory){
            fileDir = [documentDirectory stringByAppendingPathComponent:fname];
        }
    }
    return fileDir;
}
@end
