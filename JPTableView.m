#import "JPTableView.h"
#include <stdlib.h>

@implementation JPTableView

@synthesize pickerDelegate;

#define kAutoScrolling @"AUTOSCROLLING"
#define kBouncing @"BOUNCING"
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        @try {
             float r = arc4random() % 10;
            r = r/1000;
            float d  = 1-r;
            if (d==1) {
                d =0.9999;
            }
            CGFloat decelerationRate = d;//0.9999;//UIScrollViewDecelerationRateNormal +(UIScrollViewDecelerationRateNormal) * .0001;
           // CGFloat decelerationRate = 0.1;
            [self setValue:[NSValue valueWithCGSize:CGSizeMake(decelerationRate,decelerationRate)] forKey:@"_decelerationFactor"];
            NSLog(@"decelerationRate:%f",decelerationRate);
        }
        @catch (NSException *exception) {
            // if they modify the way it works under us.
        }
        
        
    }
    return self;
}

- (void) doAnimatedScrollTo:(CGPoint)offset
{

    [self lockWithState:kAutoScrolling];
    [self setContentOffset:offset animated:YES]; //  yes screws up the animation  timing but correctly shows all rows
    //[self setContentOffset:offset animated:NO]; //  no screws up the rows from all showing properly WTF
    [self unlock];
    return;

    
     [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
         return;
         // GOTO A RANDOM POINT FOR EFFECT
         float f = self.contentSize.height;
         NSString *str = [NSString stringWithFormat:@"%.2f", f];
         int fi = [str intValue];
             int r = arc4random() % fi;
          CGPoint pt = CGPointMake(0,r);
         
         
          [self lockWithState:kAutoScrolling];
         [self setContentOffset:pt]; // go to random position first
         [self unlock];

       
         
     }   completion:^(BOOL finished){
         // ignore this first random positioning
       
         [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseIn animations:^{
             
             [self lockWithState:kAutoScrolling];
             [self setContentOffset:offset animated:YES];
             [self unlock];
             
         }   completion:^(BOOL finished){
             
             
             
         }];

     }];
    
    
   
}
-(void)cancelBouncing{

    if ([[self lockedState]isEqualToString:kBouncing]) {
        NSLog(@"cancelBouncing");
        [self.pickerDelegate.autoScrollingDict setValue:nil forKey:[NSString stringWithFormat:@"%d",self.tag]];
        [NSTimer cancelPreviousPerformRequestsWithTarget:self];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
   
}
- (void)bounceScrollView
{
    NSString *locked =[self lockedState];
    NSLog(@"scrollstate:%@",locked);
    if ([locked isEqualToString:kAutoScrolling]) return;
    [self lockWithState:kBouncing];
    [self setPagingEnabled:NO];
    [self setScrollEnabled:NO];
    [self setContentOffset:CGPointMake(0, -400) animated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(unbounceScrollView) userInfo:nil repeats:NO];


}
- (void)unbounceScrollView
{
    [self setContentOffset:CGPointMake(0, 0) animated:YES];
    [self setPagingEnabled:YES];
    [self setScrollEnabled:YES];
    if ([[self lockedState] isEqualToString:kBouncing]) {
        NSLog(@"kBouncing");
       [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(bounceScrollView) userInfo:nil repeats:NO];
    }else{
       
    }
    
}

-(void)lockWithState:(NSString*)state{
    NSLog(@"scrolling:%@",self.pickerDelegate.autoScrollingDict);
    [self.pickerDelegate.autoScrollingDict setValue:state forKey:[NSString stringWithFormat:@"%d",self.tag]];
}
-(void)unlock{
    NSLog(@"scrolling:%@",self.pickerDelegate.autoScrollingDict);
    [self.pickerDelegate.autoScrollingDict setValue:nil forKey:[NSString stringWithFormat:@"%d",self.tag]];
}
-(NSString*)lockedState{
     return [self.pickerDelegate.autoScrollingDict valueForKey:[NSString stringWithFormat:@"%d",self.tag]];
}


@end
