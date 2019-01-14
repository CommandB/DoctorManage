//
//  MoreView.m
//  CCBClientV2
//
//  Created by zengxinyuan on 13-11-20.
//  Copyright (c) 2013年 llbt. All rights reserved.
//

#import "MoreMenuView.h"

#define MARGIN_LEFT  15
#define MENU_HEIGHT  30

@implementation MoreMenuView
@synthesize m_delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, frame.size.height)];
//        bgImageView.image = [[UIImage imageNamed:@"more_bg"]stretchableImageWithLeftCapWidth:13 topCapHeight:13];
        [self addSubview:bgImageView];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 100, 150)];
        tableView.delegate = self;
        tableView.layer.cornerRadius=5.0f;
        tableView.dataSource = self;
        tableView.scrollEnabled = NO;
        tableView.backgroundColor = [UIColor lightGrayColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self addSubview:tableView];
    }
    return self;
}

#pragma mark - UITableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    if(indexPath.row == 0){
        cell.textLabel.text = @"历史考试";
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"历史评价";
    }else {
        cell.textLabel.text = @"历史CEX";
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self selectIndex:indexPath.row + 100];
}

- (void)selectIndex:(NSInteger)index
{
    switch (index) {
        case 100:
            if (m_delegate != nil && [m_delegate respondsToSelector:@selector(moreMenuWithMenuView:withIndex:)]) {
                [m_delegate moreMenuWithMenuView:self withIndex:index];
            }
            break;
        case 101:
            if (m_delegate != nil && [m_delegate respondsToSelector:@selector(moreMenuWithMenuView:withIndex:)]) {
                [m_delegate moreMenuWithMenuView:self withIndex:index];
            }
            break;
        case 102:
            if (m_delegate != nil && [m_delegate respondsToSelector:@selector(moreMenuWithMenuView:withIndex:)]) {
                [m_delegate moreMenuWithMenuView:self withIndex:index];
            }
            break;
        default:
        {
            
        }
            break;
    }
}


@end
