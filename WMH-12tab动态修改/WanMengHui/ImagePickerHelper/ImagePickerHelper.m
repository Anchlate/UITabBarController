//
//  ImagePickerHelper.m
//  WenLou
//
//  Created by Steven on 16/3/23.
//  Copyright © 2016年 Steven. All rights reserved.
//

#import "ImagePickerHelper.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ImagePickerHelper () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    ImagePickerHandle _imagePickerHandle; // call back
}

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, weak) UIViewController *currentController;

@end

@implementation ImagePickerHelper

+ (instancetype)helper {
    return [[self alloc] init];
}

/*! @brief 展示 */
- (void)showInViewController:(UIViewController *)viewController pickerCompletion:(ImagePickerHandle)completion {
    _currentController = viewController;
    _imagePickerHandle = completion;
    
    [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil] showInView:viewController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // 拍照
        [self takeImageByCamera];
    }
    if (buttonIndex == 1) { // 从相册选择
        [self pickImageInLibrary];
    }
}

- (UIImagePickerController *)imagePickerController {
    if (_imagePickerController) return _imagePickerController;
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
    _imagePickerController.mediaTypes = mediaTypes;
    _imagePickerController.delegate   = self;
    _imagePickerController.allowsEditing = YES;
        
    return _imagePickerController;
}

/*! @brief 相册选择单张图片 */
- (void)pickImageInLibrary {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary]) { // 检测相册是否可用
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [_currentController presentViewController:self.imagePickerController animated:YES completion:nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:nil message:@"请在iPhone的“设置-隐私-照片”选项中，允许 万盟汇 访问你的照片。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}

/*! @brief 照相机拍照图片 */
- (void)takeImageByCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) { // 检测相机是否可用
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        if(iOS_VERSION() >= 8.0) {
            self.imagePickerController.modalPresentationStyle = UIModalPresentationOverFullScreen;
        }
        [_currentController presentViewController:self.imagePickerController animated:YES completion:nil];
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            [[[UIAlertView alloc] initWithTitle:nil message:@"请在iPhone的“设置-隐私-相机”选项中，允许 万盟汇 访问你的相机。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
        }
    } else {
        [[[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在iPhone的“设置-隐私-相机”选项中，允许 万盟汇 访问你的相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil] show];
    }
}

// 用户取消拍照 || 取消选择图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(void){
        WQNSLog(@"sss");
    }];
}

// 完成拍照或者选择完成图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *image = info[UIImagePickerControllerEditedImage];
        if (image == nil) {
            image = [UIImage fixOrientation:info[UIImagePickerControllerOriginalImage]];
        }
        image = [self fixOrientation:image];
        if (_imagePickerHandle) {
            _imagePickerHandle(image);
        }
    }];
}

/*! @brief 图片旋转处理 */
- (UIImage *)fixOrientation:(UIImage *)aImage {
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
