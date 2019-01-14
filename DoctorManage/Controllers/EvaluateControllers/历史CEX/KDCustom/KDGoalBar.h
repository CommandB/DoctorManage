
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "KDGoalBarPercentLayer.h"


@interface KDGoalBar : UIView {
    UIImage * thumb;
    
    KDGoalBarPercentLayer *percentLayer;
    CALayer *thumbLayer;
          
}

@property (nonatomic, strong) UILabel *percentLabel;
@property (nonatomic, strong) UILabel *nameLabel;

//- (void)setPercent:(int)percent animated:(BOOL)animated;
- (void)setScore:(NSString *)score name:(NSString *)name animated:(BOOL)animated;


@end
