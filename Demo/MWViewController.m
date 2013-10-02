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
    UIBarButtonItem *flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.toolbarItems = @[btn,btn1,flex,btn2];
    
    
    [self.view setBackgroundColor:[UIColor blueColor]];
    if (IS_IPAD) {
        numberPicker = [[MWNumberPicker alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 100)];
    }else{
             numberPicker = [[MWNumberPicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height/2, self.view.bounds.size.width, 50)];
    }
    
 
    [numberPicker setDelegate:self];
    [numberPicker setFontColor:[UIColor whiteColor]];
    [numberPicker update];
    
    [numberPicker setNumber:[NSNumber numberWithInt:12000] animated:YES];
    
    //numberPicker.shouldUseShadows = YES;
    
    [self performSelector:@selector(changeNumber) withObject:nil afterDelay:2];
    
    [self.view addSubview:numberPicker];
    

    
}
-(void)refresh{
        [numberPicker stop];
    int r = arc4random() % 3;
      [self performSelector:@selector(changeNumber) withObject:nil afterDelay:r];
}
-(void)stopTimer{
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
     int r = arc4random() % 9999999;
    [numberPicker setNumber:[NSNumber numberWithInt:r] animated:YES];
    //int r2 = arc4random() % 3;
    [self performSelector:@selector(changeNumber) withObject:nil afterDelay:5];
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 1;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    [self.view setBackgroundColor:color];
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
