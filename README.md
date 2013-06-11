MWDatePicker - Custom UIDatePicker
===================================

An UIDatePicker replacement with custom Background and Selector Styles. (As seen in [nextr](https://itunes.apple.com/de/app/nextr/id628098698?mt=8))

### Still in work :)

##Preview

![With Shadows and Colors](http://f.cl.ly/items/2F0k1C0y0r2E453l2F3B/Bildschirmfoto%202013-06-11%20um%2016.50.06.png)
![With Shadows and Black](http://f.cl.ly/items/1A171P1q1z1r070G2s30/Bildschirmfoto%202013-06-11%20um%2016.50.41.png)
![With Shadows and Black and Selector](http://f.cl.ly/items/072H2m3n3o010E211f2Q/Bildschirmfoto%202013-06-11%20um%2016.52.00.png)
![Without Shadows and White](http://f.cl.ly/items/1p1o1g1t183C2t0Y161e/Bildschirmfoto%202013-06-11%20um%2016.52.40.png)


## Features

- customize the Look and Feel of your UIDatePicker in order to suit your App Design
- change Background of each Component either with UIColor or an UIView
- change and style the Date Selector Overlay (again with UIColor or an UIView)

## Installation

1. Add `MWDatePicker.h` and `MWDatePicker.m` to your project
2. Add `QuartzCore.framework` to your project

## Requirements

- iOS 6.0 and greater
- ARC

## Delegate Methods

1. Add 'MWDatePicker.h' to your ViewController
2. Add 'MWPickerDelegate' to your Class
3. Implement MWDatePicker Delegate Methods

- (void)datePicker:(MWDatePicker \*)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)datePicker:(MWDatePicker \*)picker didClickRow:(NSInteger)row inComponent:(NSInteger)component;

- (UIView \*)backgroundViewForDatePicker:(MWDatePicker \*)picker;
- (UIColor \*)backgroundColorForDatePicker:(MWDatePicker \*)picker;

- (UIView \*)datePicker:(MWDatePicker \*)picker backgroundViewForComponent:(NSInteger)component;
- (UIColor \*)datePicker:(MWDatePicker \*)picker backgroundColorForComponent:(NSInteger)component;

- (UIView \*)overlayViewForDatePickerSelector:(MWDatePicker \*)picker;
- (UIColor \*)overlayColorForDatePickerSelector:(MWDatePicker \*)picker;

- (UIView \*)viewForDatePickerSelector:(MWDatePicker \*)picker;
- (UIColor \*)viewColorForDatePickerSelector:(MWDatePicker \*)picker;

## Credits
The base of MWDatePicker is used from [keeshux](https://github.com/keeshux/KSAdvancedPicker)

MWDatePicker was created by [Marcus Wermuth](http://www.mwermuth.com) in the development of [nextr](https://itunes.apple.com/de/app/nextr/id628098698?mt=8).


## License
MWDatePicker is available under the MIT license. See the LICENSE file for more info.

