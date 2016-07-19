//
//  RequestTool.m
//  上传图片
//
//  Created by 郭进 on 16/6/30.
//  Copyright © 2016年 郭进前. All rights reserved.
//

#import "RequestTool.h"

@implementation RequestTool


//上传图片
+ (void)requestUploadPhotoWithImage:(UIImage *)image withSucess:(HLSucessBlock)success failure:(HLFailureBlock)failure
{
    NSData *imagedata = UIImageJPEGRepresentation(image, 0.7f);
    
    NSString *urlString = [NSString stringWithFormat:@"%@",@"你的图片服务器地址"];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:@"POST" URLString:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",str];
        [formData appendPartWithFileData:imagedata name:@"image" fileName:fileName mimeType:@"image/jpeg"];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        //进度
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            //上传图片失败
            NSLog(@"上传图片失败");
            failure(nil,error);
        }else {
            NSLog(@"上传图片成功");
            success(nil,responseObject);
        }
    }];
    [uploadTask resume];
}

@end
