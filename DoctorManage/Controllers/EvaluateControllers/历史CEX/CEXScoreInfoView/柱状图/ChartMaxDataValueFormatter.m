//
//  ChartMaxDataValueFormatter.m
//  ChartsDemo
//
//  Created by 陈海峰 on 2019/1/8.
//  Copyright © 2019年 dcg. All rights reserved.
//

#import "ChartMaxDataValueFormatter.h"
@interface ChartMaxDataValueFormatter ()

@property (nonatomic, strong) NSArray *yDataValueArray;
@property (nonatomic, assign) double maxDataSetIndex;

@end
@implementation ChartMaxDataValueFormatter

- (instancetype)initWithYDataVals:(NSArray *)yVals {
    if (self = [super init]) {
        
        self.yDataValueArray = yVals;
        NSMutableArray *muArr = [NSMutableArray arrayWithArray:yVals];
        [muArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            ChartDataEntry *entry1 =(ChartDataEntry *)obj1;
            ChartDataEntry *entry2 =(ChartDataEntry *)obj2;
            if (entry1.y >= entry2.y){
                return NSOrderedAscending;
            } else {
                return NSOrderedDescending;
            }
        }];
        self.maxDataSetIndex =((ChartDataEntry * )muArr[0]).x;
    }
    return self;
}

/// 实现协议方法，只显示柱形上数据的最大值
- (NSString * _Nonnull)stringForValue:(double)value
                                entry:(ChartDataEntry * _Nonnull)entry
                         dataSetIndex:(NSInteger)dataSetIndex
                      viewPortHandler:(ChartViewPortHandler * _Nullable)viewPortHandler {
    
    if (entry.x == self.maxDataSetIndex) {
        return [NSString stringWithFormat:@"%ld%%", (NSInteger)entry.y];
    } else {
        return @"";
    }
}

@end
