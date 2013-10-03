//
//  MWNumberPicker.h
//  MWNumberPicker
//
//  Created by Marcus on 06.06.13.
//  Adapted by John Pope
//  Copyright (c) 2013 mwermuth.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include <stdlib.h>

@protocol MWPickerDataSource;
@protocol MWPickerDelegate;
@protocol MWNumberPickerDelegate;
@interface MWNumberPicker : UIView <UITableViewDelegate, UITableViewDataSource> {

    // handle animations
     NSMutableArray *digitArray;
    int idx;

    CGFloat rowHeight;
    CGFloat centralRowOffset;
    
    NSArray *digits;
    int masterDigit;
    
}

@property (nonatomic)     BOOL shouldUseShadows;
@property (nonatomic, strong) id<MWNumberPickerDelegate> delegate;
@property (nonatomic, copy)NSCalendar *calendar;

@property (nonatomic, strong)UIColor *fontColor;
@property (nonatomic,strong) NSTimer *animationTimer;

- (UITableView *)tableViewForComponent:(NSInteger)component;
- (NSInteger)selectedRowInComponent:(NSInteger)component;
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
- (void)reloadData;
- (void)update;
- (void)reloadDataInComponent:(NSInteger)component;
- (void)setShouldUseShadows:(BOOL)useShadows;
- (void)start;
- (void)stop;
- (void)setNumber:(NSNumber*)num animated:(BOOL)animated;
-(void)cancelBounceAllTables;
- (void)bounceAllTables;
@end


@protocol MWNumberPickerDelegate <NSObject>

@optional

- (void)numberPicker:(MWNumberPicker*)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)numberPicker:(MWNumberPicker *)picker didClickRow:(NSInteger)row inComponent:(NSInteger)component;

- (UIView *)backgroundViewForNumberPicker:(MWNumberPicker*)picker;
- (UIColor *)backgroundColorForNumberPicker:(MWNumberPicker*)picker;

- (UIView *)numberPicker:(MWNumberPicker*)picker backgroundViewForComponent:(NSInteger)component;
- (UIColor *)numberPicker:(MWNumberPicker*)picker backgroundColorForComponent:(NSInteger)component;

- (UIView *)overlayViewForNumberPickerSelector:(MWNumberPicker *)picker;
- (UIColor *)overlayColorForNumberPickerSelector:(MWNumberPicker *)picker;

- (UIView *)viewForNumberPickerSelector:(MWNumberPicker *)picker;
- (UIColor *)viewColorForNumberPickerSelector:(MWNumberPicker *)picker;

@end


