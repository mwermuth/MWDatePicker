/*
 * KSAdvancedPicker.h
 *
 * Copyright 2011 Davide De Rosa
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#import <UIKit/UIKit.h>
#import "ARCHelper.h"

@protocol KSAdvancedPickerDataSource;
@protocol KSAdvancedPickerDelegate;

@interface KSAdvancedPicker : UIView<UITableViewDataSource, UITableViewDelegate> {
    CGFloat rowHeight;
    CGFloat centralRowOffset;
}

@property (nonatomic, ah_weak) id<KSAdvancedPickerDataSource> dataSource;
@property (nonatomic, ah_weak) id<KSAdvancedPickerDelegate> delegate;

- (UITableView *) tableViewForComponent:(NSInteger)component;
- (NSInteger) selectedRowInComponent:(NSInteger)component;
- (void) selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
- (void) reloadData;
- (void) reloadDataInComponent:(NSInteger)component;

@end

@protocol KSAdvancedPickerDataSource<NSObject>

// row view (multiple components)
- (NSInteger) numberOfComponentsInAdvancedPicker:(KSAdvancedPicker *)picker;
- (NSInteger) advancedPicker:(KSAdvancedPicker *)picker numberOfRowsInComponent:(NSInteger)component;

// content
- (UIView *) advancedPicker:(KSAdvancedPicker *)picker viewForComponent:(NSInteger)component inRect:(CGRect)rect;
- (void) advancedPicker:(KSAdvancedPicker *)picker setDataForView:(UIView *)view row:(NSInteger)row inComponent:(NSInteger)component;

@optional

- (UIView *) __attribute__((deprecated)) advancedPicker:(KSAdvancedPicker *)picker viewForComponent:(NSInteger)component;

// row height
- (CGFloat) heightForRowInAdvancedPicker:(KSAdvancedPicker *)picker;

// component width
- (CGFloat) advancedPicker:(KSAdvancedPicker *)picker widthForComponent:(NSInteger)component;

@end

@protocol KSAdvancedPickerDelegate<NSObject>

@optional

// selected row
- (void) advancedPicker:(KSAdvancedPicker *)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void) advancedPicker:(KSAdvancedPicker *)picker didClickRow:(NSInteger)row inComponent:(NSInteger)component;

// picker background view (checked in the same order)
- (UIView *) backgroundViewForAdvancedPicker:(KSAdvancedPicker *)picker;
- (UIColor *) backgroundColorForAdvancedPicker:(KSAdvancedPicker *)picker;

// components background view (checked in the same order)
- (UIView *) advancedPicker:(KSAdvancedPicker *)picker backgroundViewForComponent:(NSInteger)component;
- (UIColor *) advancedPicker:(KSAdvancedPicker *)picker backgroundColorForComponent:(NSInteger)component;

// overlay view (checked in the same order)
- (UIView *) overlayViewForAdvancedPickerSelector:(KSAdvancedPicker *)picker;
- (UIColor *) overlayColorForAdvancedPickerSelector:(KSAdvancedPicker *)picker;

// selector view (checked in the same order)
- (UIView *) viewForAdvancedPickerSelector:(KSAdvancedPicker *)picker;
- (UIColor *) viewColorForAdvancedPickerSelector:(KSAdvancedPicker *)picker;

@end
