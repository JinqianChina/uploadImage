//
//  RequestTool.h
//  上传图片
//
//  Created by 郭进 on 16/6/30.
//  Copyright © 2016年 郭进前. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^HLSucessBlock)(NSURLSessionDataTask *task, id response);
typedef void(^HLFailureBlock)(NSURLSessionDataTask *task, NSError *error);

@interface RequestTool : NSObject
// 上传图片
+ (void)requestUploadPhotoWithImage:(UIImage *)image
                         withSucess:(HLSucessBlock)success
                            failure:(HLFailureBlock)failure;
@end
