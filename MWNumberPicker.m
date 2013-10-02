//
//  MWNumberPicker.m
//  MWNumberPicker
//
//  Created by Marcus on 06.06.13.
//  Adapted by John Pope
//  Copyright (c) 2013 mwermuth.com. All rights reserved.
//
//http://stackoverflow.com/questions/4404745/change-the-speed-of-setcontentoffsetanimated


#import "MWNumberPicker.h"
#import "JPTableView.h"


@interface MWNumberPicker()

@property (nonatomic, strong)NSMutableArray *tables;
@property (nonatomic, strong)NSMutableArray *selectedRowIndexes;
@property (nonatomic, strong)UIView *backgroundView;
@property (nonatomic, strong)UIView *overlay;
@property (nonatomic, strong)UIView *selector;


- (void)addContent;
- (void)removeContent;
- (void)updateDelegateSubviews;

- (NSInteger)componentFromTableView:(UITableView*)tableView;
- (void)alignTableViewToRowBoundary:(UITableView*)tableView;

@end

@implementation MWNumberPicker


@synthesize autoScrollingDict;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        self.autoScrollingDict = [[NSMutableDictionary alloc]init];
        animationArray = [[NSMutableArray alloc]init];
        
        /* To emulate infinite scrolling...
         
         The table data was doubled to join the head and tail.
         When the user scrolls backwards to 1/8th of the new table, user is at the 1/4th of actual data, so we scroll to 5/8th of the new table where the cells are exactly the same.
         
         Similarly, when user scrolls to 6/8th of the table, we will scroll back to 3/8th where the cells are same.
         
         In simple words, when user reaches 1/4th of the first part of table, we scroll to 1/4th of the second part, when he reaches 3/4th of the second part of table, we scroll to the 3/4 of first part. This is done simply by subtracting OR adding half the length of the new table.
         
         (C) Anup Kattel, you can copy this code, please leave these comments if you don't mind.
         */
   

        digits = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    
        
        self.fontColor = [UIColor blackColor];
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

        self.shouldUseShadows = NO;
    }
    return self;
}

- (void) dealloc{
    
    self.tables = nil;
    self.selectedRowIndexes = nil;
    
    self.backgroundView = nil;
    self.overlay = nil;
    self.selector = nil;
    
}

- (void)update{
    [self removeContent];
    [self addContent];
    [self updateDelegateSubviews];
    [self reloadData];
}


- (UITableView *)tableViewForComponent:(NSInteger)component{
    
    return [self.tables objectAtIndex:component];
}

- (NSInteger) selectedRowInComponent:(NSInteger)component{
    
    return [[self.selectedRowIndexes objectAtIndex:component] integerValue];
}

-(void) selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated{
    [self selectRow:row inComponent:component animated:animated duration:1];
}
-(void) selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated duration:(float)duration{
    NSLog(@"selectRow row:%d  component:%d",row,component);
    [self.selectedRowIndexes replaceObjectAtIndex:component withObject:[NSNumber numberWithInteger:row]];
    
    JPTableView *table = [self.tables objectAtIndex:component];
    [table  cancelScrolling];

    //int r = arc4random() % 10;
    const CGPoint alignedOffset = CGPointMake(0, row*table.rowHeight - table.contentInset.top);
    [(JPTableView*)table doAnimatedScrollTo:alignedOffset duration:duration timingFuntion:PRTweenTimingFunctionUIViewEaseIn];

    if ([self.delegate respondsToSelector:@selector(numberPicker:didSelectRow:inComponent:)]) {
        [self.delegate numberPicker:self didSelectRow:row inComponent:component];
    }
}

-(void) reloadData{
    
    for (UITableView *table in self.tables) {
        [table reloadData];
    }
}


-(void) reloadDataInComponent:(NSInteger)component{
    
    [[self.tables objectAtIndex:component] reloadData];
}


#pragma mark - UITableView DataSource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    const NSInteger component = [self componentFromTableView:tableView];
    return [self numberOfRowsInComponent:component];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"PickerCell";
    static const NSInteger tag = 4223;
    
    const NSInteger component = [self componentFromTableView:tableView];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UIView *view = nil;
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [UIView new];
        cell.backgroundColor = [UIColor clearColor];
        
        const CGRect viewRect = cell.contentView.bounds;
        
        view = [self viewForComponent:component inRect:viewRect];

        
        view.frame = viewRect;
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        view.tag = tag;
        cell.userInteractionEnabled = YES;
        [cell.contentView addSubview:view];
    }
    else{
        
        view = [cell.contentView viewWithTag:tag];
    }
    
    
    [self setDataForView:view row:indexPath.row inComponent:component];
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    const NSInteger component = [self componentFromTableView:tableView];
    
    if([self.delegate respondsToSelector:@selector(numberPicker:didClickRow:inComponent:)]){
        [self.delegate numberPicker:self didClickRow:indexPath.row inComponent:component];
    }

    [self selectRow:indexPath.row inComponent:component animated:YES duration:0.5];
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate) {
        [self alignTableViewToRowBoundary:(UITableView *)scrollView];
    }
}
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
   


}
-(NSString*)lockedStateForTableView:(UIScrollView *)scrollView{
     NSString *str = [self.autoScrollingDict valueForKey:[NSString stringWithFormat:@"%d",scrollView.tag]];
    NSLog(@"lockedStateForTableView:%@",str);
    if (str == nil) {
        return @"";
    }
    return str;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
  
      NSLog(@"scrollViewDidEndDecelerating");
    [(JPTableView*)scrollView cancelScrolling];
    [(JPTableView*)scrollView bounceScrollView];
    
    
}



#pragma mark - Content managemet

- (void)addContent{
    
    if (IS_IPAD) {
            rowHeight = 100;
    }else{
        rowHeight = 50;
    }

    
    centralRowOffset = (self.frame.size.height - rowHeight)/2;
    
    const NSInteger components = [self numberOfComponents];
    
    self.tables = [[NSMutableArray alloc] init];
    self.selectedRowIndexes = [[NSMutableArray alloc] init];
    
    CGRect tableFrame = CGRectMake(0, 0, 0, self.bounds.size.height);
    for (NSInteger i = 0; i<components; ++i) {
        
        tableFrame.size.width = [self widthForComponent:i];

        
        JPTableView *table = [[JPTableView alloc] initWithFrame:tableFrame];
        table.pickerDelegate = self;
        //table.pagingEnabled = NO;
        table.alwaysBounceVertical = YES;
        table.rowHeight = rowHeight;
        
        //table.contentInset = UIEdgeInsetsMake(centralRowOffset, 0, centralRowOffset, 0);
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.showsVerticalScrollIndicator = NO;
        if ([table respondsToSelector:@selector(separatorInset)]) {
            table.separatorInset = UIEdgeInsetsZero;
        }
        table.dataSource = self;
        table.delegate = self;
        table.tag = i;
        [self addSubview:table];
        
        [self.tables addObject:table];
        [self.selectedRowIndexes addObject:[NSNumber numberWithInteger:0]];
        
        tableFrame.origin.x += tableFrame.size.width-5;
    }
    
    if (_shouldUseShadows) {
        UIView *upperShadow = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height*1/3)];
        //[v setBackgroundColor:[UIColor greenColor]];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = upperShadow.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor], nil];
        [upperShadow.layer insertSublayer:gradient atIndex:0];
        [upperShadow setUserInteractionEnabled:NO];
        
        [self addSubview:upperShadow];
        
        UIView *lowerShadow = [[UIView alloc] initWithFrame:CGRectMake(0.0f, self.bounds.size.height-self.bounds.size.height*1/3, self.bounds.size.width, self.bounds.size.height*1/3)];
        //[v setBackgroundColor:[UIColor greenColor]];
        CAGradientLayer *gradient2 = [CAGradientLayer layer];
        gradient2.frame = lowerShadow.bounds;
        gradient2.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor blackColor] CGColor], nil];
        [lowerShadow.layer insertSublayer:gradient2 atIndex:0];
        [lowerShadow setUserInteractionEnabled:NO];
        
        [self addSubview:lowerShadow];
    }


}


- (void)removeContent
{
    // remove tables
    for (UITableView *table in self.tables) {
        [table removeFromSuperview];
    }
    self.tables = nil;
    
    // remove indexes
    self.selectedRowIndexes = nil;
    
    // remove background
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    
    // remove overlay
    [self.overlay removeFromSuperview];
    self.overlay = nil;
    
    // remove selector
    [self.selector removeFromSuperview];
    self.selector = nil;
}


- (void)updateDelegateSubviews
{
    // remove delegate subviews
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    [self.overlay removeFromSuperview];
    self.overlay = nil;
    [self.selector removeFromSuperview];
    self.selector = nil;
    
    // component background view/color
    NSUInteger i = 0;
    for (UITableView *table in self.tables) {
        if ([self.delegate respondsToSelector:@selector(numberPicker:backgroundViewForComponent:)]) {
            table.backgroundView = [self.delegate numberPicker:self backgroundViewForComponent:i];
        } else if ([self.delegate respondsToSelector:@selector(numberPicker:backgroundColorForComponent:)]) {
            table.backgroundColor = [self.delegate numberPicker:self backgroundColorForComponent:i];
        } else {
            table.backgroundColor = [UIColor clearColor];
        }
        ++i;
    }
    
    // picker background
    if ([self.delegate respondsToSelector:@selector(backgroundViewForNumberPicker:)]) {
        self.backgroundView = [self.delegate backgroundViewForNumberPicker:self];
        
        // add and send to back
        [self addSubview:self.backgroundView];
        [self sendSubviewToBack:self.backgroundView];
    } else if ([self.delegate respondsToSelector:@selector(backgroundColorForNumberPicker:)]) {
        self.backgroundColor = [self.delegate backgroundColorForNumberPicker:self];
    }
    else{
        self.backgroundColor = [UIColor clearColor];
    }
    
    // optional overlay
    if ([self.delegate respondsToSelector:@selector(overlayViewForNumberPickerSelector:)]) {
        self.overlay = [self.delegate overlayViewForNumberPickerSelector:self];
    } else if ([self.delegate respondsToSelector:@selector(overlayColorForNumberPickerSelector:)]) {
        self.overlay = [[UIView alloc] init];
        self.overlay.backgroundColor = [self.delegate overlayColorForNumberPickerSelector:self];
    }
    
    if (self.overlay) {
        
        // ignore user input on selector
        self.overlay.userInteractionEnabled = NO;
        
        // fill parent
        self.overlay.frame = self.bounds;
        [self addSubview:self.overlay];
    }
    
    // custom selector?
    if ([self.delegate respondsToSelector:@selector(viewForNumberPickerSelector:)]) {
        self.selector = [self.delegate viewForNumberPickerSelector:self];
    } else if ([self.delegate respondsToSelector:@selector(viewColorForNumberPickerSelector:)]) {
        self.selector = [[UIView alloc] init];
        self.selector.backgroundColor = [self.delegate viewColorForNumberPickerSelector:self];
       self.selector.alpha = 0.0;
    } else {
        self.selector = [[UIView alloc] init];
        self.selector.backgroundColor = [UIColor redColor];
        self.selector.alpha = 0.0;
    }
    
    // ignore user input on selector
    self.selector.userInteractionEnabled = NO;
    
    // override selector frame
    CGRect selectorFrame;
    selectorFrame.origin.x = 0;
    selectorFrame.origin.y = centralRowOffset;
    selectorFrame.size.width = self.frame.size.width;
    selectorFrame.size.height = rowHeight;
    self.selector.frame = selectorFrame;
    
    [self addSubview:self.selector];

    
}

// TODO make this dynamic
- (NSInteger) numberOfComponents
{
    return 7;
}


- (NSInteger) numberOfRowsInComponent:(NSInteger)component
{

    return [digits count];;
}

- (void) setDataForView:(UIView *)view row:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel *label = (UILabel *) view;

    label.text = [digits objectAtIndex:row];
    
}

- (UIView *) viewForComponent:(NSInteger)component inRect:(CGRect)rect
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    label.textColor = self.fontColor;
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0, 1);
    if (IS_IPAD) {
            label.font = [UIFont systemFontOfSize:120];
    }else{
        label.font = [UIFont systemFontOfSize:60];
    }
    return label;
}


- (CGFloat) widthForComponent:(NSInteger)component
{
    CGFloat width = self.frame.size.width/[self numberOfComponents];
    

    return round(width );
}


#pragma mark - Number Picker Method
-(void)cancelBounceAllTables{
    for (JPTableView *tv in self.tables) {
        // [tv reloadData];
        
        [tv cancelScrolling];
    }
}
-(void)bounceAllTables{
    
    for (JPTableView *tv in self.tables) {
        // [tv reloadData];
        
        [tv bounceScrollView];
    }
}
- (void)setNumber:(NSNumber*)num animated:(BOOL)animated{
    

    /*int x=0;
    for (UITableView *tv in self.tables) {
       // [tv reloadData];

          int r = arc4random() % 10;
         [self selectRow:r inComponent:x animated:YES]; //reset this - to do work out how to hide rows
        x++;
    }*/
    int number = [num intValue];

    [animationArray removeAllObjects];
    
    while ( number != 0 ) {
        int right_digit = number % 10;
        // NSLog (@"arr:%@", arr);
        [animationArray addObject:[NSNumber numberWithInt:right_digit]];
        number /= 10;
    }
    
    idx =0;
    [self animateNextRowSelect];
    
    
}
-(void)animateNextRowSelect{
    int n = [animationArray count];
    if (n) {
        NSNumber *num = [animationArray objectAtIndex:0];
        
        [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            [self selectRow:[num intValue] inComponent:idx animated:NO duration:2];
            int total = [[self tables] count]-1;
            if (total ==idx ) {
                JPTableView *tv = [[self tables] objectAtIndex:idx-1];
                 [self.autoScrollingDict setValue:nil forKey:[NSString stringWithFormat:@"%d",tv.tag]];
                return;;
            }
            idx++;
            
        }   completion:^(BOOL finished){
            NSLog(@"completion");
            if ([animationArray count]) {
                JPTableView *tv = [[self tables] objectAtIndex:idx-1];
                [self.autoScrollingDict setValue:nil forKey:[NSString stringWithFormat:@"%d",tv.tag]];
                [animationArray removeObjectAtIndex:0];
                
                [self performSelector:@selector(animateNextRowSelect) withObject:nil afterDelay:0.5];
            }else{
               // [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateNextRowSelect) object:nil];
                
            }
        }];
    }
   
}




#pragma mark - Other methods

- (NSInteger)componentFromTableView:(UITableView *)tableView
{
    return [self.tables indexOfObject:tableView];
}

- (void)alignTableViewToRowBoundary:(UITableView *)tableView
{
   
    const CGPoint relativeOffset = CGPointMake(0, tableView.contentOffset.y + tableView.contentInset.top);
    const NSUInteger row = round(relativeOffset.y / tableView.rowHeight);
    
    const NSInteger component = [self componentFromTableView:tableView];
    [self selectRow:row inComponent:component animated:YES duration:0.1];
}

- (NSDate *)dateWithYear:(NSInteger)yearS month:(NSInteger)monthS day:(NSInteger)dayS hour:(NSInteger)hourS minute:(NSInteger)minuteS {
    return [NSDate date];
}


- (void)setShouldUseShadows:(BOOL)useShadows{
    _shouldUseShadows = useShadows;
    [self update];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView_
{
    
    if (scrollView_.contentOffset.y >= (scrollView_.contentSize.height - scrollView_.bounds.size.height)){
        NSLog(@"we're bouncing");
      
    }
    
    NSNumber *b = [self.autoScrollingDict valueForKey:[NSString stringWithFormat:@"%d",scrollView_.tag]];
    if (b!=nil) {
       // NSLog(@"b:%@",b);
    }
    if ([b intValue]) {
          return;
    }
    
  
 
    CGFloat currentOffsetX = scrollView_.contentOffset.x;
    CGFloat currentOffSetY = scrollView_.contentOffset.y;
    CGFloat contentHeight = scrollView_.contentSize.height;
    

    //When the user scrolls backwards to 1/8th of the new table, user is at the 1/4th of actual data, so we scroll to 5/8th of the new table where the cells are exactly the same.
    if (currentOffSetY < (contentHeight / 8.0)) {
        scrollView_.contentOffset = CGPointMake(currentOffsetX,(currentOffSetY + (contentHeight/2)));
    }
    //Similarly, when user scrolls to 6/8th of the table, we will scroll back to 3/8th where the cells are same.

    if (currentOffSetY > ((contentHeight * 6)/ 8.0)) {
        scrollView_.contentOffset = CGPointMake(currentOffsetX,(currentOffSetY - (contentHeight/2)));
    }
   

    
}

// USED FOR COUNTING 1 + 2 etc
static CGFloat kFlipAnimationUpdateInterval = 1; // 0.5 = 2 times per second
#pragma mark update timer


- (void)start;
{
    if (self.animationTimer == nil) {
        [self setupUpdateTimer];
    }
}

- (void)stop;
{
    [self.animationTimer invalidate];
    self.animationTimer = nil;
}

- (void)setupUpdateTimer;
{
    self.animationTimer = [NSTimer timerWithTimeInterval:kFlipAnimationUpdateInterval
                                                  target:self
                                                selector:@selector(handleTimer:)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
}

- (void)handleTimer:(NSTimer*)timer;
{
    [self updateValuesAnimated:YES];
}

- (void)updateValuesAnimated:(BOOL)animated;
{
 
    int number = masterDigit;
    NSLog (@"%i", masterDigit);
    NSMutableArray *arr = [NSMutableArray array];
    
    while ( number != 0 ) {
        int right_digit = number % 10;
       // NSLog (@"arr:%@", arr);
        [arr addObject:[NSNumber numberWithInt:right_digit]];
        number /= 10;
    }
    
    masterDigit++;

    int i=[[self tables] count]-1;
    for (NSNumber *num in arr) {
        [self selectRow:[num intValue] inComponent:i animated:YES duration:0.5];
        i--;
    }
    
    
 
}




@end
