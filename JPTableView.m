#import "JPTableView.h"

@implementation JPTableView



- (void) doAnimatedScrollTo:(CGPoint)offset
{
    
     [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
         [self setContentOffset:offset animated:NO];
         
        // self.contentOffset = CGPointMake(0.0, offset.y);
     }   completion:^(BOOL finished){ }];
    
    
   
}


@end
