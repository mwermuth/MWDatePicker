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

@interface MWViewController : UIViewController < MWNumberPickerDelegate>{
    MWNumberPicker *numberPicker;
}

@end
