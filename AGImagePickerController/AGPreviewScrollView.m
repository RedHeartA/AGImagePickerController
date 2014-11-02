//
//  AGPreviewScrollView.m
//  AGImagePickerController Demo
//
//  Created by SpringOx on 14/11/1.
//  Copyright (c) 2014年 Artur Grigor. All rights reserved.
//

#import "AGPreviewScrollView.h"

@interface AGPreviewScrollView()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *imageViewPool;

@property (assign) NSInteger imageNumber;

@property (assign) CGSize imageSize;

@property (assign) NSInteger currentIndex;

@end

@implementation AGPreviewScrollView

- (id)initWithFrame:(CGRect)frame preDelegate:(id)preDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.preDelegate = preDelegate;
        self.imageViewPool = [NSMutableArray array];
        
        self.imageNumber = [self.preDelegate previewScrollViewNumberOfImage:self];
        self.imageSize = [self.preDelegate previewScrollViewSizeOfImage:self];
        self.currentIndex = [self.preDelegate previewScrollViewCurrentIndexOfImage:self];
        
        if (0 >= _imageNumber || 0 >= _imageSize.width || 0 >= _imageSize.height) {
            self.contentSize = CGSizeZero;
            self.contentOffset = CGPointZero;
        } else {
            self.contentSize = CGSizeMake(_imageSize.width*_imageNumber, _imageSize.height);
            self.contentOffset = CGPointMake(_imageSize.width*_currentIndex, 0);
        }
        
        [self layoutImageViewsForCurrentIndex];
        
        self.delegate = self;
        self.pagingEnabled = YES;
        
        //self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"preview scroll view layoutSubviews");
}

- (void)layoutImageViewsForIndex:(NSUInteger)index
{
    if (_currentIndex == index) {
        return;
    }
    
    self.currentIndex = index;
    [self layoutImageViewsForCurrentIndex];
}

- (void)layoutImageViewsForCurrentIndex
{
    if (![self hangUpImageViewAtIndex:_currentIndex]) {
        NSLog(@"preview scroll view hang up image view fail!");
    }
    
    // preload before image views
    NSInteger index = (NSInteger)_currentIndex;
    NSInteger i = index-1;
    while (0 <= i) {
        if (index-2 <= i) {
            [self hangUpImageViewAtIndex:i];
        } else {
            [self takeOffImageViewAtIndex:i];
        }
        i--;
    }
    
    // preload after image views
    NSInteger j = index+1;
    while (_imageNumber > j) {
        if (index+2 >= j) {
            [self hangUpImageViewAtIndex:j];
        } else {
            [self takeOffImageViewAtIndex:j];
        }
        j++;
    }
}

- (NSUInteger)viewTagWithIndex:(NSUInteger)index
{
    return index+1000;
}

- (CGRect)viewFrameWithIndex:(NSUInteger)index
{
    return CGRectMake(_imageSize.width*index, 0, _imageSize.width, _imageSize.height);
}

- (BOOL)hangUpImageViewAtIndex:(NSUInteger)index
{
    if (nil != [self viewWithTag:[self viewTagWithIndex:index]]) {
        return YES;
    }
    
    UIImageView *imgView = [self findImageView];
    if (nil == imgView) {
        return NO;
    }
    
    imgView.tag = [self viewTagWithIndex:index];
    imgView.frame = [self viewFrameWithIndex:index];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.image = [self.preDelegate previewScrollView:self imageAtIndex:index];
    [self addSubview:imgView];
    return YES;
}

- (BOOL)takeOffImageViewAtIndex:(NSUInteger)index
{
    UIView *view = [self viewWithTag:[self viewTagWithIndex:index]];
    
    if (nil == view) {
        return NO;
    }
    
    [self recoverImageView:(UIImageView *)view];
    return YES;
}

- (UIImageView *)findImageView
{
    UIImageView *imageView = [_imageViewPool lastObject];
    [_imageViewPool removeLastObject];
    
    if (nil != imageView) {
        imageView.frame = CGRectZero;
        return imageView;
    }
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return imageView;
}

- (void)recoverImageView:(UIImageView *)imageView
{
    if (nil == imageView || ![imageView isKindOfClass:[UIImageView class]]) {
        return;
    }
    
    [imageView removeFromSuperview];
    imageView.image = nil;
    
    if (![_imageViewPool containsObject:imageView]) {
        [_imageViewPool addObject:imageView];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSUInteger curIndex = (NSUInteger)self.contentOffset.x/_imageSize.width;
    
    NSLog(@"preview scroll view current index : %d", (int)curIndex);
    
    [self layoutImageViewsForIndex:curIndex];
}

@end
