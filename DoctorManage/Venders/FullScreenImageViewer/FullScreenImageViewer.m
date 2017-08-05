//
//  FullScreenImageViewer.m
//  TouAnDai
//
//  Created by sai on 15/9/30.
//  Copyright (c) 2015年 李猛. All rights reserved.
//

#import "FullScreenImageViewer.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImageView+WebCache.h"
//控件尺寸
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
@interface ScrollImageView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation ScrollImageView

- (instancetype)initWithFrame:(CGRect)frame imageUrl:(NSString*)aImageUrl {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.scrollEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.maximumZoomScale = 2;
        _scrollView.zoomScale = _scrollView.minimumZoomScale;
        [self addSubview:_scrollView];
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        if ([aImageUrl length]) {
            [_imageView sd_setImageWithURL:[NSURL URLWithString:aImageUrl]];
        }
        [_scrollView addSubview:_imageView];
        
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _indicator.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self addSubview:_indicator];
    }
    return self;
}

#pragma UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}



@end

@interface FullScreenImageViewer ()<UIActionSheetDelegate>
@property (nonatomic, strong) NSArray *array;
@property (nonatomic,strong)NSArray *imageArray;//我的添加

@end

@implementation FullScreenImageViewer

- (void)handleTapGesture:(UIGestureRecognizer*)aGesture {
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)handlePressGesture:(UIGestureRecognizer *)aGesture{
    if (aGesture.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到手机", nil];
        actionSheet.delegate = self;
        [actionSheet showInView:self];
        
    }

    

    
}


+ (void)showWith:(NSArray*)aArray atIndex:(NSInteger)aIndex {
    FullScreenImageViewer *view = [[FullScreenImageViewer alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor blackColor];
    
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(handleTapGesture:)]];
    //我的添加  长按手势
    //[view addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:view action:@selector(handlePressGesture:)]];
    view.alpha = 1;
    [view setData:aArray];
    
    view.contentOffset = CGPointMake(kScreenWidth*aIndex, 0);
    
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

- (instancetype)initWithArray:(NSArray*)aArray {
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        [self setData:aArray];
    }
    return self;
}

- (void)setData:(NSArray*)aArray {
    _array = aArray;
    for (int i=0;i<[_array count];i++) {
        id obj = [_array objectAtIndex:i];
        
        ScrollImageView *scImageView = [[ScrollImageView alloc] initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, kScreenHeight) imageUrl:nil];
        [self addSubview:scImageView];

        if ([obj isKindOfClass:[ALAsset class]]) {
            scImageView.imageView.image = [UIImage imageWithCGImage:((ALAsset*)obj).aspectRatioThumbnail];
        } else if ([obj isKindOfClass:[NSString class]]) {
            [scImageView.imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:nil];
        }

    }
    
    self.pagingEnabled = YES;
    self.contentSize = CGSizeMake(kScreenWidth*[_array count], kScreenHeight);
}
#pragma UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            int a= self.contentOffset.x/kScreenWidth;
            UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_array[a]]]];
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
//            TTAlert(@"已保存到手机相册");
            
        }
    
    
    
    
}



@end
