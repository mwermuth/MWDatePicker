#import <UIKit/UIKit.h>
#import "MWNumberPicker.h"

@interface JPTableView : UITableView{
    
}
@property (nonatomic,assign) MWNumberPicker *pickerDelegate;
- (id)initWithFrame:(CGRect)frame;
- (void) doAnimatedScrollTo:(CGPoint)offset;
- (void)bounceScrollView;
- (void)unbounceScrollView;
-(void)cancelBouncing;
@end
