//
//  ChartMaxDataValueFormatter.h
//  ChartsDemo
//
//  Created by 陈海峰 on 2019/1/8.
//  Copyright © 2019年 dcg. All rights reserved.
//

#import <Foundation/Foundation.h>
/// 设置 柱形上显示的 数据格式，只显示最大值

@import Charts;
@interface ChartMaxDataValueFormatter : NSObject <IChartValueFormatter>

- (instancetype)initWithYDataVals:(NSArray *)yVals;
@end
