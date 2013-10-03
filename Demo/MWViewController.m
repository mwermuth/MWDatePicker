//
//  MWViewController.m
//  MWNumberPicker
//
//  Created by Marcus on 08.05.13.
//  Copyright (c) 2013 mwermuth.com. All rights reserved.
//

#import "MWViewController.h"
#import "MWNumberPicker.h"
#include <stdlib.h>

@interface MWViewController ()

@end

@implementation MWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(timerStart)];
    UIBarButtonItem *btn1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(stopTimer)];
    UIBarButtonItem *btn2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
      UIBarButtonItem *btn3 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(black)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
     UIBarButtonItem *btnBounce = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(bounceAllTables)];
    
    self.toolbarItems = @[btn,btn1,btn3,flex,btnBounce,btn2];
    
    
    [self.view setBackgroundColor:[UIColor blueColor]];
    if (IS_IPAD) {
        numberPicker = [[MWNumberPicker alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 100)];
    }else{
        numberPicker = [[MWNumberPicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height/2, self.view.bounds.size.width, 50)];
    }
    
 
    [numberPicker setDelegate:self];
    [numberPicker setFontColor:[UIColor whiteColor]];
    [numberPicker update];
    [numberPicker bounceAllTables];

    
    [self.view addSubview:numberPicker];
    
    
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    titleLabel.font = [UIFont boldSystemFontOfSize:30];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"PRTweenTimingFunction";
    [self.view addSubview:titleLabel];
    
    
    tweenLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, 80)];
    tweenLabel.backgroundColor = [UIColor clearColor];
    tweenLabel.font = [UIFont boldSystemFontOfSize:30];
    tweenLabel.textColor = [UIColor redColor];
    [self.view addSubview:tweenLabel];
    
    
    tInterval = 5;
    [self changeNumber];
    [self runTimerTween];
   
}

// spans 5 seconds to collectively tumble all the rows. 
-(void)runTimerTween{
    
    int rnd = idx;//arc4random() % 40;
    if (idx >= 30) {
        idx = 0;
    }
    PRTweenTimingFunction f;
    
    NSLog(@"rn:%d",rnd);
    switch (rnd) {
        case 0:   f = PRTweenTimingFunctionLinear; tweenLabel.text = @"Linear"; break;
        case 1:   f = PRTweenTimingFunctionBackOut;tweenLabel.text = @"BackOut"; break;
        case 2:   f = PRTweenTimingFunctionBackIn;tweenLabel.text = @"BackIn"; break;
        case 3:   f = PRTweenTimingFunctionBackInOut;tweenLabel.text = @"BackInOut"; break;
        case 4:   f = PRTweenTimingFunctionBounceOut;tweenLabel.text = @"BounceOut"; break;
        case 5:   f = PRTweenTimingFunctionBounceIn; tweenLabel.text = @"BounceIn";break;
        case 6:   f = PRTweenTimingFunctionBounceInOut; tweenLabel.text = @"BounceInOut";break;
        case 7:   f = PRTweenTimingFunctionCircOut;  tweenLabel.text = @"CircOut";break;;
        case 8:   f = PRTweenTimingFunctionCircIn;tweenLabel.text = @"CircIn"; break;
        case 9:   f = PRTweenTimingFunctionCircInOut;tweenLabel.text = @"CircInOut"; break;
        case 10:   f = PRTweenTimingFunctionCubicOut;tweenLabel.text = @"CubicOut";  break;
        case 11:   f = PRTweenTimingFunctionCubicIn;tweenLabel.text = @"CubicIn";  break;
        case 12:   f = PRTweenTimingFunctionCubicInOut;tweenLabel.text = @"CubicInOut"; break;
        case 13:   f = PRTweenTimingFunctionElasticOut;tweenLabel.text = @"ElasticOut"; break;
        case 14:   f = PRTweenTimingFunctionElasticIn;tweenLabel.text = @"ElasticIn"; break;
        case 15:   f = PRTweenTimingFunctionElasticInOut; tweenLabel.text = @"ElasticInOut";break;
        case 16:   f = PRTweenTimingFunctionExpoOut;tweenLabel.text = @"ExpoOut"; break;
        case 17:   f = PRTweenTimingFunctionExpoIn; tweenLabel.text = @"ExpoIn";break;
        case 18:   f = PRTweenTimingFunctionExpoInOut; tweenLabel.text = @"ExpoInOut"; break;
        case 19:   f = PRTweenTimingFunctionQuadOut;tweenLabel.text = @"QuadOut";  break;
        case 20:   f = PRTweenTimingFunctionQuadIn;tweenLabel.text = @"QuadIn";  break;
        case 21:   f = PRTweenTimingFunctionQuadInOut; tweenLabel.text = @"QuadInOut"; break;
        case 22:   f = PRTweenTimingFunctionQuartOut;tweenLabel.text = @"QuartOut"; break;
        case 23:   f = PRTweenTimingFunctionQuartIn;tweenLabel.text = @"QuartIn"; break;
        case 24:   f = PRTweenTimingFunctionQuartInOut;tweenLabel.text = @"QuartInOut"; break;
        case 25:   f = PRTweenTimingFunctionQuintOut;tweenLabel.text = @"QuartOut"; break;
        case 26:   f = PRTweenTimingFunctionQuintIn; tweenLabel.text = @"QuartIn";break;
        case 27:   f = PRTweenTimingFunctionQuintInOut; tweenLabel.text = @"QuintInOut"; break;
        case 28:   f = PRTweenTimingFunctionSineOut; tweenLabel.text = @"SineOut"; break;
        case 29:   f = PRTweenTimingFunctionSineIn; tweenLabel.text = @"SineIn"; break;
        case 30:   f = PRTweenTimingFunctionSineInOut;tweenLabel.text = @"SineInOut";  break;
        //case 31:   f = PRTweenTimingFunctionCALinear; tweenLabel.text = @"CALinear";       break;
        //case 32:   f = PRTweenTimingFunctionCAEaseIn; tweenLabel.text = @"CAEaseIn";       break;
        //case 33:   f = PRTweenTimingFunctionCAEaseOut;  tweenLabel.text = @"CAEaseOut";     break;
       // case 34:   f = PRTweenTimingFunctionCAEaseInOut; tweenLabel.text = @"CAEaseInOut";     break;
        //case 35:   f = PRTweenTimingFunctionCADefault;  tweenLabel.text = @"CADefault";    break;
        //case 36:   f = PRTweenTimingFunctionUIViewLinear;  tweenLabel.text = @"UIViewLinear";       break;
       // case 37:   f = PRTweenTimingFunctionUIViewEaseIn; tweenLabel.text = @"UIViewEaseIn";      break;
       // case 38:   f = PRTweenTimingFunctionUIViewEaseOut; tweenLabel.text = @"UIViewEaseOut";      break;
        //case 39:   f = PRTweenTimingFunctionUIViewEaseInOut; tweenLabel.text = @"UIViewEaseInOut";     break;
        //case 40:  f = PRTweenTimingFunctionLinear; tweenLabel.text = @"Linear";  break;
            
    }
    

    NSLog(@"runTimerTween");
    __weak MWViewController *weakSelf = self;
    PRTweenPeriod *period = [PRTweenPeriod periodWithStartValue:5 endValue:1 duration:5];
    activeTweenOperation = [[PRTween sharedInstance] addTweenPeriod:period target:self selector:@selector(update:) timingFunction:f ];
    idx++;
    activeTweenOperation.completeBlock = ^{
        [weakSelf performSelector:@selector(runSequence) withObject:nil afterDelay:4]; // do this after a delay
        
    };
}
-(void)runSequence{
    tInterval = 5.0f;
    [self changeNumber];
    [self runTimerTween];
}
- (void)update:(PRTweenPeriod*)period {
    tInterval = period.tweenedValue;
    NSLog(@"period.tweenedValue:%f",tInterval);
}

-(void)bounceAllTables{
    [numberPicker bounceAllTables];
    [numberPicker setNumber:[NSNumber numberWithInt:12000] animated:YES];
}
-(void)refresh{
        [numberPicker stop];
    int r = arc4random() % 3;
      [self performSelector:@selector(changeNumber) withObject:nil afterDelay:r];
}
-(void)stopTimer{
    [[PRTween sharedInstance] removeAllTweenOperations];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
     [numberPicker stop];
}
-(void)timerStart{
    [numberPicker setNumber:[NSNumber numberWithInt:0] animated:YES];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [numberPicker start];
}



-(void)changeNumber{
    // max 7 digits
     int r = arc4random() % 999999;
    [numberPicker setNumber:[NSNumber numberWithInt:r] animated:YES];
    //int r2 = arc4random() % 3;
    if (1) {
        [self.view setBackgroundColor:[UIColor blackColor]];
    }else{
        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 1;  //  0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        [self.view setBackgroundColor:color];
    }
    [self performSelector:@selector(changeNumber) withObject:nil afterDelay:tInterval];

}

-(void)black{
    [numberPicker cancelBounceAllTables];
    black = YES;
}
#pragma mark - MWMWNumberPickerPickerDelegate
/*
- (UIColor *) backgroundColorForNumberPicker:(MWNumberPicker *)picker
{
    return [UIColor blackColor];
}


- (UIColor *) numberPicker:(MWNumberPicker *)picker backgroundColorForComponent:(NSInteger)component
{
    
 return [UIColor blackColor];
}


- (UIColor *) viewColorForNumberPickerSelector:(MWNumberPicker *)picker
{
    return [UIColor clearColor];
}

-(void)numberPicker:(MWNumberPicker *)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
   
}*/

@end
