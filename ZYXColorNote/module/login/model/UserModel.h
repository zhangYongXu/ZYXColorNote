//
//  UserModel.h
//  LuNengHotel
//
//  Created by 极客天地 on 16/10/24.
//  Copyright © 2016年 极客天地. All rights reserved.
//

//
/*
 {
     "user_sina": "222",
     "flag": 0,
     "address": "a6w5da61d5",
     "create_time": 1473746218000,
     "user_name": "admin",
     "last_login": 1477497600000,
     "modify_time": 1473746213000,
     "sex": 1,
     "user_db": "333",
     "booktypeid": "1",
     "photo": "111",
     "user_pwd": "admin",
     "user_role": 0,
     "book_count": 0,
     "book_count_money": 0,
     "user_id": 1,
     "phone": "15001388817",
     "brithday": 1477501020000,
     "case_number": 0,
     "user_weixin": "111",
     "udet_id": 1
 }
*/
#import "GWRootModel.h"
typedef NS_ENUM(NSInteger,SexTypes) {
    SexTypeMale = 1, //男
    SexTypeFemale = 2 //女
};
typedef NS_ENUM(NSInteger,EducationTypes) {
    EducationTypeNone = -1, //没选
    EducationTypePrimarySchool = 0, //小学
    EducationTypeMiddleSchool = 1,  //初中
    EducationTypeHighSchool = 2,    //中专/高中
    EducationTypeUniversity = 3,    //专科/本科
    EducationTypePostgraduate = 4,  //硕士研究生
    EducationTypeDoctor = 5         //博士研究生
};
@interface UserModel : GWRootModel
@property(copy,nonatomic) NSString * firstLetter;
@property(copy,nonatomic)NSString* hx_id;
@property(copy,nonatomic)NSString* hx_password;
@property(copy,nonatomic)NSString* user_name;
@property(assign,nonatomic)NSInteger u_id;
@property(copy,nonatomic)NSString* objectId;
@property(copy,nonatomic)NSString* nick_name;
@property(copy,nonatomic)NSString* user_pwd;
@property(copy,nonatomic)NSString* phone;
@property(assign,nonatomic)SexTypes sex; //性别  1为男性，2为女性
@property(copy,nonatomic)NSString* sexString;
@property(copy,nonatomic)NSString* birthday;
@property(assign,nonatomic)EducationTypes education;
@property(copy,nonatomic)NSString* educationString;
@property(copy,nonatomic)NSString* trade;
@property(copy,nonatomic)NSString* interest;
@property(copy,nonatomic)NSString* img_url;
@property(strong,nonatomic)NSDictionary* headerImageUrl;
@property(assign,nonatomic)NSInteger age;
@property(assign,nonatomic)NSInteger d_flag;
@property(assign,nonatomic)BOOL signstate;//是否已签到

@property(copy,nonatomic)NSString* user_Hx_id;



//本地文件路径
@property (copy,nonatomic) NSString * userHomePath;

@property(copy,nonatomic)NSString*verifyCode;

+(NSString*)stringEducationWithType:(EducationTypes)type;
+(EducationTypes)educationWithString:(NSString*)string;

+(NSString*)stringSexWithType:(SexTypes)type;
+(SexTypes)sexWithString:(NSString*)string;

@end
