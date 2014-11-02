//
//  AGAssetsPreviewController.h
//  AGImagePickerController Demo
//
//  Created by SpringOx on 14/11/1.
//  Copyright (c) 2014年 Artur Grigor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "AGImagePickerControllerDefines.h"

@interface AGAssetsPreviewController : UIViewController

@property (nonatomic, strong, readonly) ALAsset *targetAsset;

@property (nonatomic, strong, readonly) NSArray *assets;

- (id)initWithAssets:(NSArray *)assets targetAsset:(ALAsset *)targetAsset;

@end
