//
//  BmobHttpApiDelete.h
//  ZYXColorNote
//
//  Created by 极客天地 on 2018/2/5.
//  Copyright © 2018年 极客天地. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BmobNetWork.h"
@class BmobHttpApiDeleteItem;
@interface BmobHttpApiDelete : NSObject
/**
 *  删除数据
 *
 *  @param array        删除的对象
 *  @param show         是否显示加载提示
 *  @param sucessBlock  成功回调
 *  @param failedBlock  失败回调
 */
+ (void)deleteDataWithArray:(NSArray<BmobHttpApiDeleteItem*>*)array showProgress:(BOOL)show sucess:(BmobDictionarySucessBlock)sucessBlock failed:(BmobStringFailedBlock)failedBlock;
/**
 *  删除数据
 *
 *  @param item         删除的对象
 *  @param show         是否显示加载提示
 *  @param sucessBlock  成功回调
 *  @param failedBlock  失败回调
 */
+ (void)deleteDataWithBmobHttpApiDeleteItem:(BmobHttpApiDeleteItem*)item showProgress:(BOOL)show sucess:(BmobDictionarySucessBlock)sucessBlock failed:(BmobStringFailedBlock)failedBlock;

@end
@interface BmobHttpApiDeleteItem : NSObject
@property (copy,nonatomic) NSString * tableName;
@property (copy,nonatomic) NSString * objectId;
@end
