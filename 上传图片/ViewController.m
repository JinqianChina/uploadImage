//
//  ViewController.m
//  上传图片
//
//  Created by 郭进 on 16/6/30.
//  Copyright © 2016年 郭进前. All rights reserved.
//

#import "ViewController.h"
#import "RequestTool.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 150, 60)];
    [btn setTitle:@"点击获取图片" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(btnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnOnClick
{
    [self localPhoto];
}

// 打开本地相册
-(void)localPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

//上传图片到服务器
- (void)doAddPhoto:(UIImage *)image
{
    [RequestTool requestUploadPhotoWithImage:image withSucess:^(NSURLSessionDataTask *task, id response) {
        NSLog(@"成功");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"失败");
    }];
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate Call Back Implementation

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        NSString *key = nil;
        
        if (picker.allowsEditing)
        {
            key = UIImagePickerControllerEditedImage;
        }
        else
        {
            key = UIImagePickerControllerOriginalImage;
        }
        //获取图片
        UIImage *image = [info objectForKey:key];
        //处理图片
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            //固定方向
            //image = [image fixOrientation];
            //压缩图片质量
            image = [self reduceImage:image percent:0.1];
            CGSize imageSize = image.size;
            imageSize.height = 320;
            imageSize.width = 320;
            //压缩图片尺寸
            image = [self imageWithImageSimple:image scaledToSize:imageSize];
        }else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            if (image.size.height / image.size.width < 1) {
                image = [self cutImage:image];
            }
        }
        
        //上传到服务器
        [self doAddPhoto:image];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

//压缩图片质量
-(UIImage *)reduceImage:(UIImage *)image percent:(float)percent
{
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}

//压缩图片尺寸
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//裁剪图片
- (UIImage *)cutImage:(UIImage*)image
{
    CGSize newSize;
    CGImageRef imageRef = nil;
    if (image.size.width < image.size.height) {
        newSize = CGSizeMake(image.size.width, image.size.width);
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
    } else {
        newSize = CGSizeMake(image.size.height, image.size.height);
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
    }
    return [UIImage imageWithCGImage:imageRef];
}

@end
