//
//  MWViewController.m
//  MWNumberPicker
//
//  Created by Marcus on 08.05.13.
//  Copyright (c) 2013 mwermuth.com. All rights reserved.
//

#import "MWViewController.h"
#import "MWNumberPicker.h"


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
    
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    if (IS_IPAD) {
        numberPicker = [[MWNumberPicker alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 100)];
    }else{
             numberPicker = [[MWNumberPicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height/2, self.view.bounds.size.width, 50)];
    }
    //numberPicker.autoresizesSubviews = YES;
    //numberPicker.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;

    [numberPicker setDelegate:self];
    [numberPicker setFontColor:[UIColor whiteColor]];
    [numberPicker update];
    
    [numberPicker setNumber:[NSNumber numberWithInt:12000] animated:YES];
    
    [self performSelector:@selector(changeNumber) withObject:nil afterDelay:2];
    
    [self.view addSubview:numberPicker];
    

    
}
-(void)refresh{
        [numberPicker stop];
      [self performSelector:@selector(changeNumber) withObject:nil afterDelay:2];
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
    
    [numberPicker setNumber:[NSNumber numberWithInt:3557842] animated:YES];
    [self performSelector:@selector(changeNumber2) withObject:nil afterDelay:2];
}
-(void)changeNumber2{
    // max 7 digits
    
    [numberPicker setNumber:[NSNumber numberWithInt:9432577] animated:YES];
    [self performSelector:@selector(changeNumber3) withObject:nil afterDelay:1];
}
-(void)changeNumber3{
    // max 7 digits
    
    [numberPicker setNumber:[NSNumber numberWithInt:121112] animated:YES];
    [self performSelector:@selector(changeNumber) withObject:nil afterDelay:2];
}



#pragma mark - MWMWNumberPickerPickerDelegate

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
   
}

@end
