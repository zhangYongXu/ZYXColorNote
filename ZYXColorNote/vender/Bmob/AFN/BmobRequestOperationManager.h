//
//  BmobRequestOperationManager.h
//  RealMall
//
//  Created by 极客天地 on 2018/2/2.
//  Copyright © 2018年 极客天地. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import "BmobHttpSessionManager.h"

@interface BmobRequestOperationManager : AFHTTPRequestOperationManager
+ (instancetype)operationManager;
+(NSDictionary*)bmobBaseHeader;
@end
