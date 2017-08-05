//
//  FullScreenImageViewer.h
//  TouAnDai
//
//  Created by sai on 15/9/30.
//  Copyright (c) 2015年 李猛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollImageView : UIView
- (instancetype)initWithFrame:(CGRect)frame imageUrl:(NSString*)aImageUrl;
@end

@interface FullScreenImageViewer : UIScrollView
+ (void)showWith:(NSArray*)aArray atIndex:(NSInteger)aIndex;


@end
