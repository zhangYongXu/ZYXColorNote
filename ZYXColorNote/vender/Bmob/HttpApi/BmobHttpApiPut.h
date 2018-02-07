//
//  BmobHttpApiPut.h
//  ZYXColorNote
//
//  Created by 极客天地 on 2018/2/6.
//  Copyright © 2018年 极客天地. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BmobNetWork.h"
@class BmobHttpApiUpdateItem;
@interface BmobHttpApiPut : NSObject
/**
 *  修改数据
 *
 *  @param item         修改的对象
 *  @param show         是否显示加载提示
 *  @param sucessBlock  成功回调
 *  @param failedBlock  失败回调
 */
+ (void)updateDataWithBmobHttpApiUpdateItem:(BmobHttpApiUpdateItem*)item showProgress:(BOOL)show sucess:(BmobDictionarySucessBlock)sucessBlock failed:(BmobStringFailedBlock)failedBlock;
@end
@interface BmobHttpApiUpdateItem : NSObject
@property (copy,nonatomic) NSString * tableName;
@property (copy,nonatomic) NSString * objectId;
@property (strong,nonatomic) NSDictionary * updateDataDict;
@end
