//
//  GGTypeDef.h
//  WOfficeApp
//
//  Created by Static Ga on 13-10-9.
//  Copyright (c) 2013年 Static Ga. All rights reserved.
//

#ifndef WOfficeApp_GGTypeDef_h
#define WOfficeApp_GGTypeDef_h
@class AFHTTPRequestOperation;
typedef enum {
    kHttpPostMethod,
    kHttpGetMethod,
    kHttpDeleteMethod,//Not achieved
    kHttpPatchMethod,//Not achieved
    kHttpPutMethod,//Not achieved
    kHttpHeadMethod,//Not achieved
}kHttpMethod;

typedef void (^GGSucessBlock)(id responseObj);
typedef void (^GGFailedBlock)(NSString *errorMsg);
typedef void (^GGProgressBlock)(CGFloat progress);
typedef void (^GGFailedBlockWithCode)(long errorCode, NSString* errorMsg);
typedef BOOL (^GGWillStartBlock)(void);

typedef void (^UploadProgressBlock)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);
typedef void (^DownloadProgressBolck)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead);
typedef void (^UploadSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^UploadFaildBlock)(AFHTTPRequestOperation *operation, NSError *error);
#endif
