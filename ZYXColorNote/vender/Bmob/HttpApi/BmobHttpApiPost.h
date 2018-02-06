//
//  BmobHttpApiPost.h
//  RealMall
//
//  Created by 极客天地 on 2018/2/2.
//  Copyright © 2018年 极客天地. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BmobNetWork.h"
@class BmobHttpApiAddItem;
@interface BmobHttpApiPost : NSObject
/**
 *  添加数据
 *
 *  @param item         添加的对象
 *  @param show         是否显示加载提示
 *  @param sucessBlock  成功回调
 *  @param failedBlock  失败回调
 */
+ (void)addDataWithBmobHttpApiAddItem:(BmobHttpApiAddItem*)item showProgress:(BOOL)show sucess:(BmobDictionarySucessBlock)sucessBlock failed:(BmobStringFailedBlock)failedBlock;
@end
@interface BmobHttpApiAddItem : NSObject
@property (copy,nonatomic) NSString * tableName;
@property (strong,nonatomic) NSDictionary * dataDict;
@property (strong,nonatomic) NSArray * pointArray;
@property (strong,nonatomic,readonly) NSDictionary * addRequestDict;
@end
@interface BmobHttpApiAddItemPoint : NSObject
@property (copy,nonatomic) NSString * pointFeildName;
@property (copy,nonatomic) NSString * tableName;
@property (copy,nonatomic) NSString * objectId;
@property (strong,nonatomic,readonly) NSDictionary * addRequestDict;
@end
