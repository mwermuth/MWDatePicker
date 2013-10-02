#import "JPTableView.h"
#include <stdlib.h>


@implementation JPTableView

@synthesize pickerDelegate;

#define kAutoScrolling @"AUTOSCROLLING"
#define kBouncing @"BOUNCING"
#define kInfiniteScrolling  @"kInfiniteScrolling"

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
-(void)dealloc{

}
/*
- (void) doAnimatedScrollTo:(CGPoint)offset
{
 I'm curious as to whether you found a solution to your problem. My first idea was to use an animateWithDuration:animations: call with a block setting the contentOffset:
 
 [UIView animateWithDuration:2.0 animations:^{
 scrollView.contentOffset = CGPointMake(x, y);
 }];
 Side effects
 
 Although this works for simple examples, it also has very unwanted side effects. Contrary to the setContentOffset:animated: everything you do in delegate methods also gets animated, like the scrollViewDidScroll: delegate method.
 
 I'm scrolling through a tiled scrollview with reusable tiles. This gets checked in the scrollViewDidScroll:. When they do get reused, they get a new position in the scroll view, but that gets animated, so there are tiles animating all the way through the view. Looks cool, yet utterly useless. Another unwanted side effect is that possible hit testing of the tiles and my scroll view's bounds is instantly rendered useless because the contentOffset is already at a new position as soon as the animation block executes. This makes stuff appear and disappear while they're still visible, as to where they used to be toggled just outside of the scroll view's bounds.
 
 With setContentOffset:animated: this is all not the case. Looks like UIScrollView is not using the same technique internally.
 
 Is there anyone with another suggestion for changing the speed/duration of the UIScrollView setContentOffset:animated: execution?
 
 
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0f
                              delay:0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self lockWithState:kAutoScrolling];
                             [self setContentOffset:offset animated:YES];
                         }
                         completion:^(BOOL finished) {}];
    });
    
 
    
   
}*/

-(void)cancelScrolling{

    if ([[self lockedState]isEqualToString:kBouncing]) {
        NSLog(@"cancelScrolling");
        [self.pickerDelegate.autoScrollingDict setValue:nil forKey:[NSString stringWithFormat:@"%d",self.tag]];
        [NSTimer cancelPreviousPerformRequestsWithTarget:self];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
   
}


- (void)bounceScrollView
{

    return;
    
    NSString *locked =[self lockedState];
    NSLog(@"scrollstate:%@",locked);
    if ([locked isEqualToString:kAutoScrolling]) return;
    [self lockWithState:kBouncing];
    [self setPagingEnabled:NO];
    [self setScrollEnabled:NO];
    float f = self.contentSize.height;
    NSString *str = [NSString stringWithFormat:@"%.2f", f];
    int fi = [str intValue];
    int r = arc4random() % fi;
    
    [self setContentOffset:CGPointMake(0, -r) animated:YES];
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


- (void) doAnimatedScrollTo:(CGPoint)destinationOffset duration:(CGFloat)duration timingFuntion:(PRTweenTimingFunction)timingFunction
{
    CGPoint offset = [self contentOffset];
    
    //activeTweenOperation.timingFunction = ;//PRTweenTimingFunctionUIViewEaseOut;
    activeTweenOperation = [PRTweenCGPointLerp lerp:self property:@"contentOffset" from:offset to:destinationOffset duration:duration];
    PRTweenTimingFunction f;
    
    int rnd = idx;//arc4random() % 40;
    NSLog(@"rn:%d",rnd);
    switch (rnd) {
        case 0:   f = PRTweenTimingFunctionLinear;  break;
        case 1:   f = PRTweenTimingFunctionBackOut; break;
        case 2:   f = PRTweenTimingFunctionBackIn; break;
        case 3:   f = PRTweenTimingFunctionBackInOut; break;
        case 4:   f = PRTweenTimingFunctionBounceOut; break;
        case 5:   f = PRTweenTimingFunctionBounceIn; break;
        case 6:   f = PRTweenTimingFunctionBounceInOut; break;
        case 7:   f = PRTweenTimingFunctionCircOut; break;
        case 8:   f = PRTweenTimingFunctionCircIn; break;
        case 9:   f = PRTweenTimingFunctionCircInOut; break;
        case 10:   f = PRTweenTimingFunctionCubicOut; break;
        case 11:   f = PRTweenTimingFunctionCubicIn; break;
        case 12:   f = PRTweenTimingFunctionCubicInOut; break;
        case 13:   f = PRTweenTimingFunctionElasticOut; break;
        case 14:   f = PRTweenTimingFunctionElasticIn; break;
        case 15:   f = PRTweenTimingFunctionElasticInOut; break;
        case 16:   f = PRTweenTimingFunctionExpoOut; break;
        case 17:   f = PRTweenTimingFunctionExpoIn; break;
        case 18:   f = PRTweenTimingFunctionExpoInOut; break;
        case 19:   f = PRTweenTimingFunctionQuadOut; break;
        case 20:   f = PRTweenTimingFunctionQuadIn; break;
        case 21:   f = PRTweenTimingFunctionQuadInOut; break;
        case 22:   f = PRTweenTimingFunctionQuartOut; break;
        case 23:   f = PRTweenTimingFunctionQuartIn; break;
        case 24:   f = PRTweenTimingFunctionQuartInOut; break;
        case 25:   f = PRTweenTimingFunctionQuintOut; break;
        case 26:   f = PRTweenTimingFunctionQuintIn; break;
        case 27:   f = PRTweenTimingFunctionQuintInOut; break;
        case 28:   f = PRTweenTimingFunctionSineOut; break;
        case 29:   f = PRTweenTimingFunctionSineIn; break;
        case 30:   f = PRTweenTimingFunctionSineInOut; break;
        case 31:   f = PRTweenTimingFunctionCALinear;        break;
        case 32:   f = PRTweenTimingFunctionCAEaseIn;        break;
        case 33:   f = PRTweenTimingFunctionCAEaseOut;       break;
        case 34:   f = PRTweenTimingFunctionCAEaseInOut;     break;
        case 35:   f = PRTweenTimingFunctionCADefault;      break;
        case 36:   f = PRTweenTimingFunctionUIViewLinear;        break;
        case 37:   f = PRTweenTimingFunctionUIViewEaseIn;      break;
        case 38:   f = PRTweenTimingFunctionUIViewEaseOut;       break;
        case 39:   f = PRTweenTimingFunctionUIViewEaseInOut;     break;
    }
  
    activeTweenOperation.timingFunction = f;
    activeTweenOperation.target = self;
    activeTweenOperation.updateSelector = @selector(update:);
    idx++;
}

- (void)update:(PRTweenPeriod*)period {
   // NSLog(@"period");
    if (self.contentOffset.y >= (self.contentSize.height - self.bounds.size.height)){
        NSLog(@"we're bouncing");
        
    }

 
}

@end
