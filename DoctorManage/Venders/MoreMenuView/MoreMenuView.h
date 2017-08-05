//
//  MoreView.h
//  CCBClientV2
//
//  Created by zengxinyuan on 13-11-20.
//  Copyright (c) 2013年 llbt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MoreMenuView;
@protocol MoreMenuClickDelegate <NSObject>

- (void)moreMenuWithMenuView:(MoreMenuView *)menuView withIndex:(NSInteger)index;

@end

@interface MoreMenuView : UIView<UITableViewDataSource, UITableViewDelegate>
{
    BOOL m_hidden;
    UIButton *m_skinBtn;
    UIButton *m_helpBtn;
    UIButton *m_shareBtn;
    UIButton *m_favorBtn;
    
    UIButton *m_settingBtr;
    NSObject<MoreMenuClickDelegate> *m_delegate;
    
}

@property (nonatomic, retain)UIButton *relatedBtn;
@property(nonatomic,retain) NSObject<MoreMenuClickDelegate> *m_delegate;

@end
