//
//  AGAssetsPreviewController.m
//  AGImagePickerController Demo
//
//  Created by SpringOx on 14/11/1.
//  Copyright (c) 2014年 Artur Grigor. All rights reserved.
//

#import "AGAssetsPreviewController.h"

#import "AGPreviewScrollView.h"

@interface AGAssetsPreviewController ()<AGPreviewScrollViewDelegate>

@property (nonatomic, strong) AGPreviewScrollView *preScrollView;

@end

@implementation AGAssetsPreviewController

- (id)initWithAssets:(NSArray *)assets targetAsset:(ALAsset *)targetAsset
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
        _assets = assets;
        _targetAsset = targetAsset;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (nil == _preScrollView) {
        _preScrollView = [[AGPreviewScrollView alloc] initWithFrame:self.view.bounds preDelegate:self];
        _preScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _preScrollView.bounces = NO;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapGestureRecognizer)];
        [_preScrollView addGestureRecognizer:tapGesture];
    }
    
    [self.view addSubview:_preScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapGestureRecognizer
{
    if (nil != self.navigationController && 1 < [self.navigationController.viewControllers count]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark - AGPreviewScrollViewDelegate

- (NSInteger)previewScrollViewNumberOfImage:(AGPreviewScrollView *)scrollView
{
    return [_assets count];
}

- (CGSize)previewScrollViewSizeOfImage:(AGPreviewScrollView *)scrollView
{
    return self.view.bounds.size;
}

- (NSUInteger)previewScrollViewCurrentIndexOfImage:(AGPreviewScrollView *)scrollView
{
    return [_assets indexOfObject:_targetAsset];
}

- (UIImage *)previewScrollView:(AGPreviewScrollView *)scrollView imageAtIndex:(NSUInteger)index
{
    if ([_assets count] <= index) {
        return nil;
    }
    
    ALAsset *asset = [_assets objectAtIndex:index];
    UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    return image;
}

@end
