//
//  CCView.m
//  DoctorManage
//
//  Created by 陈海峰 on 2019/1/14.
//  Copyright © 2019年 chenshengchang. All rights reserved.
//

#import "CCView.h"
// 自定义数据格式
#import "YAxisValueFormatter1.h"
#import "XAxisValueFormatter1.h"
#import "ChartDataValueFormatter1.h"
#import "ChartMaxDataValueFormatter.h"
@interface CCView ()<ChartViewDelegate>

// 柱状图
@property (nonatomic, strong) HorizontalBarChartView *barChartView;

// 滑动时 Y 值标签
@property (nonatomic,strong) UILabel *markYLabel;

@end


@implementation CCView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:230/255.0f green:253/255.0f blue:253/255.0f alpha:1];
        
        // 创建柱状图
        [self createdBarView];
        
        
    }
    return self;
}

- (void)setDataSource:(NSMutableArray*)array{
    // 设置柱状图的数据
    self.barChartView.data = [self setData:array];
}

// 创建柱状图
- (void)createdBarView {
    
    // 初始化柱状图对象
    self.barChartView = [[HorizontalBarChartView alloc] initWithFrame:self.bounds];
    
    self.barChartView = [[HorizontalBarChartView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 10, 400)];
    self.barChartView.center = self.center;
    [self addSubview:self.barChartView];
    
    // 设置基本样式
    self.barChartView.backgroundColor = [UIColor colorWithRed:230/255.0f green:253/255.0f blue:253/255.0f alpha:1];
    self.barChartView.delegate = self;                                          // 设置代理，需遵守 ChartViewDelegate 协议
    self.barChartView.noDataText = @"暂无数据";                                   // 没有数据时的文字提示
    self.barChartView.drawValueAboveBarEnabled = YES;                           // 数值显示在柱形的上面还是下面
    self.barChartView.drawBarShadowEnabled = NO;                                // 是否绘制柱形的阴影背景
    
    // 设置交互样式
    self.barChartView.scaleYEnabled = NO;                                       // 取消 Y 轴缩放
    self.barChartView.doubleTapToZoomEnabled = NO;                              // 取消双击缩放
    self.barChartView.dragEnabled = YES;                                        // 启用拖拽图标
    self.barChartView.dragDecelerationEnabled = YES;                            // 拖拽后是否有惯性效果
    self.barChartView.dragDecelerationFrictionCoef = 0.9;                       // 拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    
    // 设置滑动时 Y 值标签
    ChartMarkerView *markerY = [[ChartMarkerView alloc] init];
    markerY.offset = CGPointMake(-17, -25);                                     // 设置显示位置
    markerY.chartView = self.barChartView;
    [markerY addSubview:self.markYLabel];
    self.barChartView.marker = markerY;
    
    // 设置 X 轴样式
    ChartXAxis *xAxis = self.barChartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;                             // 设置 X 轴的显示位置，默认是显示在上面的
    xAxis.axisLineWidth = 1.0 / [UIScreen mainScreen].scale;                    // 设置 X 轴线宽
    xAxis.axisLineColor = [UIColor blackColor];                                 // 设置 X 轴颜色
    xAxis.valueFormatter = [[XAxisValueFormatter1 alloc] init];                  // label 文字样式，自定义格式，默认时不显示特殊符号
    xAxis.labelTextColor = [UIColor brownColor];                                // label 文字颜色
    xAxis.drawGridLinesEnabled = NO;                                            // 不绘制网格线
    xAxis.gridColor = [UIColor clearColor];                                     // 网格线颜色
    
    // 设置 Y 轴样式
    self.barChartView.rightAxis.enabled = NO;                                   // 不绘制右边轴
    ChartYAxis *leftAxis = self.barChartView.leftAxis;                          // 获取左边 Y 轴
    leftAxis.inverted = NO;                                                     // 是否将 Y 轴进行上下翻转
    leftAxis.axisMinimum = 0;                                                  // 设置 Y 轴的最小值
    leftAxis.axisMaximum = 10;                                                // 设置 Y 轴的最大值
    leftAxis.axisLineWidth = 1.0 / [UIScreen mainScreen].scale;                 // 设置 Y 轴线宽
    leftAxis.axisLineColor = [UIColor blackColor];                              // 设置 Y 轴颜色
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;                    // label 文字位置
    leftAxis.valueFormatter = [[YAxisValueFormatter1 alloc] init];               // label 文字样式，自定义格式，默认时不显示特殊符号
    leftAxis.labelTextColor = [UIColor brownColor];                             // label 文字颜色
    leftAxis.labelFont = [UIFont systemFontOfSize:10.0f];                       // label 文字字体
    leftAxis.labelCount = 5;                                                    // label 数量，数值不一定，
    // 如果 forceLabelsEnabled 等于 YES,
    // 则强制绘制制定数量的 label, 但是可能不平均
    leftAxis.forceLabelsEnabled = NO;                                           // 不强制绘制指定数量的 label
    leftAxis.gridLineDashLengths = @[@3.0f, @3.0f];                             // 设置虚线样式的网格线
    leftAxis.gridColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];    // 网格线颜色
    leftAxis.gridAntialiasEnabled = YES;                                        // 网格线开启抗锯齿
    
    // 添加限制线
    ChartLimitLine *limitLine = [[ChartLimitLine alloc] initWithLimit:80 label:@"限制线"];     // 设置限制值和标题
    limitLine.lineWidth = 2;                                                    // 限制线的宽度
    limitLine.lineColor = [UIColor greenColor];                                 // 限制线的颜色
    limitLine.lineDashLengths = @[@5.0f, @5.0f];                                // 虚线样式
    limitLine.labelPosition = ChartLimitLabelPositionRightTop;                  // label 位置
    limitLine.valueTextColor = [UIColor grayColor];                             // label 文字颜色
    limitLine.valueFont = [UIFont systemFontOfSize:12];                         // label 字体
    [leftAxis addLimitLine:limitLine];                                          // 添加到 Y 轴上
    leftAxis.drawLimitLinesBehindDataEnabled = YES;                             // 设置限制线绘制在柱状图的下面
    
    // 设置柱状图描述
    self.barChartView.chartDescription.enabled = YES;                           // 显示柱状图描述，默认 YES 显示
//    self.barChartView.descriptionText = @"柱状图";                               // 柱状图描述
//    self.barChartView.descriptionFont = [UIFont systemFontOfSize:15];           // 柱状图描述字体
//    self.barChartView.descriptionTextColor = [UIColor darkGrayColor];           // 柱状图描述颜色
    
    // 设置柱状图图例
    self.barChartView.legend.enabled = NO;                                      // 显示图例，默认 YES 显示
    
    // 设置动画效果，可以设置 X 轴和 Y 轴的动画效果
    [self.barChartView animateWithYAxisDuration:1.0f];
}

// 设置柱状图数据
- (RadarChartData *)setData:(NSMutableArray*)array {

    int vals_count = 7;                                                        // 要显示多少条数据
    
    // 设置表格数据，包含 x 值和 y 值
    NSMutableArray *chartVals1 = [[NSMutableArray alloc] init];
    for (int i = 1; i <= vals_count; i++) {
        
        double xValue = i-1;                              // 设置区块值
        double yValue = [array[i-1] doubleValue];

        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:xValue y:yValue];
        [chartVals1 addObject:entry];
        
    }
    
    // 绘制柱状图
    
    // 创建 BarChartDataSet 对象
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithValues:chartVals1 label:nil];
    
    // 设置柱形的样式
    [set1 setColors:ChartColorTemplates.material];                              // 设置柱形图颜色
    set1.drawValuesEnabled = YES;                                               // 是否显示数据，默认 YES
    set1.valueColors = @[[UIColor brownColor]];                                 // 显示数据的颜色
    set1.highlightEnabled = YES;                                                // 点击选中柱形图是否有高亮效果，（双击空白处取消选中）
    // set1.valueFormatter = [[ChartMaxDataValueFormatter alloc] initWithYDataVals:chartVals1];    // 设置数据显示的格式，只显示最大值
    
    // 将 BarChartDataSet 对象放入数组中
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    // 创建 BarChartData 对象, 此对象就是 BarChartData 需要最终数据对象
    BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:8.f]];  // 文字字体
    [data setValueTextColor:[UIColor grayColor]];                               // 文字颜色
    
    // 自定义数据显示格式
    ChartDataValueFormatter1 *formatter = [[ChartDataValueFormatter1 alloc] init];// 统一设置数据显示的格式
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
    
    // 将点击的数据滑动到中间
    [self.barChartView centerViewToAnimatedWithXValue:entry.x
                                               yValue:entry.y
                                                 axis:[self.barChartView.data
                                                       getDataSetByIndex:highlight.dataSetIndex].axisDependency
                                             duration:1.0];
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
