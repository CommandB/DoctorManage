//
//  DDView.m
//  DoctorManage
//
//  Created by 陈海峰 on 2019/1/8.
//  Copyright © 2019年 chenshengchang. All rights reserved.
//

#import "DDView.h"
// 自定义数据格式
#import "XAxisValueFormatter.h"
#import "ChartDataValueFormatter.h"
@interface DDView ()<ChartViewDelegate>
// 雷达图
@property (nonatomic, strong) RadarChartView *radarChartView;

// 滑动时 Y 值标签
@property (nonatomic,strong) UILabel *markYLabel;
@end
@implementation DDView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 创建雷达图
        [self createdPieView];
        
        
        NSLog(@"dsadada");
    }
    return self;
}

- (void)setDataSource:(NSMutableArray*)array{
    // 设置雷达图的数据
    self.radarChartView.data = [self setData:array];
}
// 创建雷达图
- (void)createdPieView {
    
    // 初始化雷达图对象
    self.radarChartView = [[RadarChartView alloc] initWithFrame:self.bounds];
    self.radarChartView.center = self.center;
    [self addSubview:self.radarChartView];
    
    // 设置基本样式
    self.radarChartView.backgroundColor = [UIColor colorWithRed:230/255.0f green:253/255.0f blue:253/255.0f alpha:1];
    self.radarChartView.delegate = self;                                        // 设置代理，需遵守 ChartViewDelegate 协议
    self.radarChartView.noDataText = @"暂无数据";                                 // 没有数据时的文字提示
    
    // 设置交互样式
    self.radarChartView.rotationEnabled = YES;                                  // 是否允许转动
    self.radarChartView.highlightPerTapEnabled = YES;                           // 是否能被选中
    
    // 设置雷达图线条样式
    self.radarChartView.webLineWidth = 1.0;                                     // 主干线线宽，辐射线
    self.radarChartView.webColor = [UIColor lightGrayColor];                    // 主干线颜色
    self.radarChartView.innerWebLineWidth = 1.0;                                // 边线宽度，圆形线
    self.radarChartView.innerWebColor = [UIColor lightGrayColor];               // 边线颜色
    self.radarChartView.webAlpha = 0.5;                                         // 雷达图线的透明度
    
    // 设置滑动时 Y 值标签
    ChartMarkerView *markerY = [[ChartMarkerView alloc] init];
    markerY.offset = CGPointMake(-17, -25);                                     // 设置显示位置
    markerY.chartView = self.radarChartView;
    [markerY addSubview:self.markYLabel];
    self.radarChartView.marker = markerY;
    
    // 设置 X 轴 label 样式，由中心向外延伸的线
    ChartXAxis *xAxis = self.radarChartView.xAxis;
    xAxis.valueFormatter = [[XAxisValueFormatter alloc] init];                  // label 文字样式，自定义格式，默认时不显示特殊符号
    xAxis.labelFont = [UIFont systemFontOfSize:15];                             // 字体
    xAxis.labelTextColor = [UIColor colorWithRed:5/255.0f green:119/255.0f blue:72/255.0f alpha:1]; // 颜色
    
    // 设置 Y 轴 label 样式，圆形的线
    ChartYAxis *yAxis = self.radarChartView.yAxis;
    yAxis.axisMinimum = 0.0;                                                   // 最小值，中心的值
    yAxis.axisMaximum = 10.0;                                                 // 最大值，最外边的值
    yAxis.drawLabelsEnabled = YES;                                              // 是否显示 label 值
    yAxis.labelCount = 5;                                                       // label 个数
    yAxis.labelFont = [UIFont systemFontOfSize:9];                              // label 字体
    yAxis.labelTextColor = [UIColor lightGrayColor];                            // label 颜色
    
    // 设置雷达图描述
    self.radarChartView.chartDescription.enabled = YES;                         // 显示雷达图描述，默认 YES 显示
    
    
    // 设置雷达图图例
    self.radarChartView.legend.enabled = YES;                                   // 显示图例，默认 YES 显示
    self.radarChartView.legend.form = ChartLegendFormCircle;                    // 图示样式: 方形、线条、圆形
    self.radarChartView.legend.formSize = 12;                                   // 图示大小
    //    self.radarChartView.legend.position = ChartLegendPositionBelowChartCenter;  // 图例在雷达图中的位置
    self.radarChartView.legend.maxSizePercent = 1;                              // 图例在雷达图中的大小占比, 这会影响图例的宽高
    self.radarChartView.legend.formToTextSpace = 5;                             // 文本间隔
    self.radarChartView.legend.font = [UIFont systemFontOfSize:10];             // 字体大小
    self.radarChartView.legend.textColor = [UIColor grayColor];                 // 字体颜色
    
    // 设置动画效果，可以设置 X 轴和 Y 轴的动画效果
    [self.radarChartView animateWithXAxisDuration:1.4 yAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
}

// 设置雷达图数据
- (RadarChartData *)setData:(NSMutableArray*)array {
    
    int vals_count = 7;                                                        // 维度的个数
    
    // 每个维度的名称或描述
    NSMutableArray *chartVals1 = [[NSMutableArray alloc] init];
    for (int i = 1; i <= vals_count; i++) {
        
        double partValue = [array[i-1] doubleValue];                              // 设置区块值
        
        RadarChartDataEntry *entry = [[RadarChartDataEntry alloc] initWithValue:partValue];
        [chartVals1 addObject:entry];
    }
    
    // 绘制雷达图
    
    // 创建 RadarChartDataSet 对象
    RadarChartDataSet *set1 = [[RadarChartDataSet alloc] initWithValues:chartVals1 label:nil];
    
    // 设置数据块
    set1.lineWidth = 0.5;                                                       // 数据折线线宽
    [set1 setColor:[UIColor redColor]];                                         // 数据折线颜色
    set1.drawFilledEnabled = YES;                                               // 是否填充颜色
    set1.fillColor = [UIColor orangeColor];                                     // 填充颜色
    set1.fillAlpha = 0.5;                                                       // 填充透明度
    
    // 设置数据块折点样式
    set1.drawHighlightCircleEnabled = NO;                                       // 是否绘制选中的拐点处的圆形
    set1.highlightCircleStrokeColor = [UIColor greenColor];                     // 拐点处的圆形颜色
    [set1 setDrawHighlightIndicators:NO];                                       // 是否绘制选中拐点处的十字线
    
    // 设置显示数据
    set1.drawValuesEnabled = YES;                                               // 是否绘制显示数据
    set1.valueFont = [UIFont systemFontOfSize:9];                               // 字体
    set1.valueTextColor = [UIColor grayColor];                                  // 颜色
    
    // 创建 RadarChartData 对象, 此对象就是 PieChartData 需要最终数据对象
    RadarChartData *data = [[RadarChartData alloc] initWithDataSets:@[set1]];
    [data setValueFont:[UIFont systemFontOfSize:15]];
    [data setValueTextColor:[UIColor brownColor]];
    
    // 自定义数据显示格式
    ChartDataValueFormatter *formatter = [[ChartDataValueFormatter alloc] init];// 统一设置数据显示的格式
    [data setValueFormatter:formatter];
    
    return data;
}

#pragma mark - ChartViewDelegate

// 点击选中柱形图时的代理方法
- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView
                     entry:(ChartDataEntry * _Nonnull)entry
                 highlight:(ChartHighlight * _Nonnull)highlight {
    
    // 设置滑动时 Y 值标签
    self.markYLabel.text = [NSString stringWithFormat:@"%ld%%", (NSInteger)entry.y];
}

// 没有选中柱形图时的代理方法，当选中一个柱形图后，在空白处双击，就可以取消选择，此时会回调此方法
- (void)chartValueNothingSelected:(ChartViewBase * _Nonnull)chartView {
    
}

// 捏合放大或缩小柱形图时的代理方法
- (void)chartScaled:(ChartViewBase * _Nonnull)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY {
    
}

// 拖拽图表时的代理方法
- (void)chartTranslated:(ChartViewBase * _Nonnull)chartView dX:(CGFloat)dX dY:(CGFloat)dY {
    
}

// 懒加载滑动时 Y 值标签
- (UILabel *)markYLabel {
    
    if (!_markYLabel) {
        _markYLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -5, 35, 25)];
        _markYLabel.font = [UIFont systemFontOfSize:15.0];
        _markYLabel.textAlignment = NSTextAlignmentCenter;
        _markYLabel.text = @"";
        _markYLabel.textColor = [UIColor whiteColor];
        _markYLabel.backgroundColor = [UIColor grayColor];
    }
    return _markYLabel;
}


@end
