#import <UIKit/UIKit.h>
#import "MWNumberPicker.h"
#import "PRTween.h"


@interface JPTableView : UITableView{
  PRTweenOperation *activeTweenOperation;
    int idx;
}
@property (nonatomic,assign) MWNumberPicker *pickerDelegate;
@property (nonatomic, strong) NSDate *startTime;


- (id)initWithFrame:(CGRect)frame;
- (void) doAnimatedScrollTo:(CGPoint)destinationOffset duration:(CGFloat)duration timingFuntion:(PRTweenTimingFunction)timingFunction;
- (void)bounceScrollView;
- (void)unbounceScrollView;
-(void)cancelScrolling;
@end
