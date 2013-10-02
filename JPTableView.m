#import "JPTableView.h"
#include <stdlib.h>

@implementation JPTableView



- (void) doAnimatedScrollTo:(CGPoint)offset
{
//    self.alwaysBounceVertical = YES;
   [self setContentOffset:offset animated:YES];
    return;
    
         int r = arc4random() % 2;
     [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
         float f = self.contentSize.height;
         NSString *str = [NSString stringWithFormat:@"%.2f", f];
         int fi = [str intValue];
             int r = arc4random() % fi;
          CGPoint pt = CGPointMake(0,r);
         
         [self setContentOffset:pt animated:NO]; // go to random position first
         
         
       
         
     }   completion:^(BOOL finished){
         // ignore this first random positioning
         [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
             
             [self setContentOffset:offset animated:NO];
             
         }   completion:^(BOOL finished){
             
             
             
         }];

     }];
    
    
   
}




@end
