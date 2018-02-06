//
//  BmobHttpSessionManager.h
//  RealMall
//
//  Created by 极客天地 on 2018/2/2.
//  Copyright © 2018年 极客天地. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface BmobHttpSessionManager : AFHTTPSessionManager
+ (instancetype)sessionManager;
+ (NSDictionary*)bmobBaseHeader;
@end
