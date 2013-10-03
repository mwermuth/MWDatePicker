//
//  MWViewController.h
//  MWDatePicker
//
//  Created by Marcus on 08.05.13.
//  Copyright (c) 2013 mwermuth.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWDatePicker.h"
#import "MWNumberPicker.h"
#import "PRTween.h"

@interface MWViewController : UIViewController < MWNumberPickerDelegate>{
    UILabel *tweenLabel;
    UILabel *titleLabel;
    MWNumberPicker *numberPicker;
    PRTweenOperation *activeTweenOperation;
    CGFloat tInterval;
    BOOL black;
    int idx;
    
}
@property (nonatomic,assign) NSTimeInterval timeInterval;
@end
