//
//  MWDatePicker.m
//  MWDatePicker
//
//  Created by Marcus on 06.06.13.
//  Copyright (c) 2013 mwermuth.com. All rights reserved.
//

#import "MWDatePicker.h"

@interface MWDatePicker()

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

@implementation MWDatePicker




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void) dealloc{
    
    self.tables = nil;
    self.selectedRowIndexes = nil;
    
    self.backgroundView = nil;
    self.overlay = nil;
    self.selector = nil;
    
    [super ah_dealloc];
}

-(void)setDataSource:(id<MWPickerDataSource>)dataSource{
    
    if (dataSource == self.dataSource) {
        return;
    }
    
    [self removeContent];
    
    self.dataSource = dataSource;
    if (self.dataSource) {
        [self addContent];
        [self updateDelegateSubviews];
        [self reloadData];
    }
}

-(void)setDelegate:(id<MWPickerDelegate>)delegate{
    
    if (delegate == self.delegate) {
        return;
    }
    
    self.delegate = delegate;
    if (self.delegate) {
        [self updateDelegateSubviews];
        [self reloadData];
    }
}

- (UITableView *)tableViewForComponent:(NSInteger)component{
    
    return [self.tables objectAtIndex:component];
}

- (NSInteger) selectedRowInComponent:(NSInteger)component{
    
    return [[self.selectedRowIndexes objectAtIndex:component] integerValue];
}

-(void) selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated{
    
    [self.selectedRowIndexes replaceObjectAtIndex:component withObject:[NSNumber numberWithInteger:row]];
    
    UITableView *table = [self.tables objectAtIndex:component];
    
    const CGPoint alignedOffset = CGPointMake(0, row*table.rowHeight - table.contentInset.top);
    [table setContentOffset:alignedOffset animated:animated];
    
    if ([self.delegate respondsToSelector:@selector(datePicker:didSelectRow:inComponent:)]) {
        [self.delegate datePicker:self didSelectRow:row inComponent:component];
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
    return [self.dataSource datePicker:self numberOfRowsInComponent:component];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"PickerCell";
    static const NSInteger tag = 4223;
    
    const NSInteger component = [self componentFromTableView:tableView];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UIView *view = nil;
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        const CGRect viewRect = cell.contentView.bounds;
        
        if ([self.dataSource respondsToSelector:@selector(datePicker:viewForComponent:inRect:)]) {
            view = [self.dataSource datePicker:self viewForComponent:component inRect:viewRect];
        }
        else{
            view = [self.dataSource datePicker:self viewForComponent:component];
        }
        
        view.frame = viewRect;
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        view.tag = tag;
        [cell.contentView addSubview:view];
    }
    else{
        
        view = [cell.contentView viewWithTag:tag];
    }
    
    [self.dataSource datePicker:self setDataForView:view row:indexPath.row inComponent:component];
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    const NSInteger component = [self componentFromTableView:tableView];
    
    if([self.delegate respondsToSelector:@selector(datePicker:didClickRow:inComponent:)]){
        [self.delegate datePicker:self didClickRow:indexPath.row inComponent:component];
    }

    [self selectRow:indexPath.row inComponent:component animated:YES];
}

#pragma mark - UIScrollView Delegate Methods

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate) {
        [self alignTableViewToRowBoundary:(UITableView *)scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self alignTableViewToRowBoundary:(UITableView *)scrollView];
}

#pragma mark - Content managemet

- (void)addContent{
    
    if ([self.dataSource respondsToSelector:@selector(heightForRowInDatePicker:)]) {
        rowHeight = [self.dataSource heightForRowInDatePicker:self];
    }
    else{
        rowHeight = 50;
    }
    
    centralRowOffset = (self.frame.size.height - rowHeight)/2;
    
    //const NSInteger components = [self.dataSource numberOfComponentsInDatePicker:self];
    const NSInteger components = 3;
    
    self.tables = [[NSMutableArray alloc] init];
    self.selectedRowIndexes = [[NSMutableArray alloc] init];
    
    CGRect tableFrame = CGRectMake(0, 0, 0, self.bounds.size.height);
    for (NSInteger i = 0; i<components; ++i) {
        
        if ([self.dataSource respondsToSelector:@selector(datePicker:widthForComponent:)]) {
            tableFrame.size.width = [self.dataSource datePicker:self widthForComponent:i];
        }
        else{
            tableFrame.size.width = (NSUInteger)(self.frame.size.width /components);
        }
        
        UITableView *table = [[UITableView alloc] initWithFrame:tableFrame];
        table.rowHeight = rowHeight;
        table.contentInset = UIEdgeInsetsMake(centralRowOffset, 0, centralRowOffset, 0);
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.showsVerticalScrollIndicator = NO;
        
        table.dataSource = self;
        table.delegate = self;
        [self addSubview:table];
        
        [self.tables addObject:table];
        [self.selectedRowIndexes addObject:[NSNumber numberWithInteger:0]];
        [table release];
        
        tableFrame.origin.x += tableFrame.size.width;
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
        if ([self.delegate respondsToSelector:@selector(advancedPicker:backgroundViewForComponent:)]) {
            table.backgroundView = [self.delegate datePicker:self backgroundViewForComponent:i];
        } else if ([self.delegate respondsToSelector:@selector(advancedPicker:backgroundColorForComponent:)]) {
            table.backgroundColor = [self.delegate datePicker:self bdackgroundColorForComponent:i];
        } else {
            table.backgroundColor = [UIColor clearColor];
        }
        ++i;
    }
    
    // picker background
    if ([self.delegate respondsToSelector:@selector(backgroundViewForAdvancedPicker:)]) {
        self.backgroundView = [self.delegate backgroundViewForDatePicker:self];
        
        // add and send to back
        [self addSubview:self.backgroundView];
        [self sendSubviewToBack:self.backgroundView];
    } else if ([self.delegate respondsToSelector:@selector(backgroundColorForDatePicker:)]) {
        self.backgroundColor = [self.delegate backgroundColorForDatePicker:self];
    }
    
    // optional overlay
    if ([self.delegate respondsToSelector:@selector(overlayViewForDatePickerSelector:)]) {
        self.overlay = [self.delegate overlayViewForDatePickerSelector:self];
    } else if ([self.delegate respondsToSelector:@selector(overlayColorForDatePickerSelector:)]) {
        self.overlay = [[UIView alloc] init];
        self.overlay.backgroundColor = [self.delegate overlayColorForDatePickerSelector:self];
    }
    
    if (self.overlay) {
        
        // ignore user input on selector
        self.overlay.userInteractionEnabled = NO;
        
        // fill parent
        self.overlay.frame = self.bounds;
        [self addSubview:self.overlay];
    }
    
    // custom selector?
    if ([self.delegate respondsToSelector:@selector(viewForDatePickerSelector:)]) {
        self.selector = [self.delegate viewForDatePickerSelector:self];
    } else if ([self.delegate respondsToSelector:@selector(colorForDatePickerSelector:)]) {
        self.selector = [[UIView alloc] init];
        self.selector.backgroundColor = [self.delegate colorForDatePickerSelector:self];
    } else {
        self.selector = [[UIView alloc] init];
        self.selector.backgroundColor = [UIColor blackColor];
        self.selector.alpha = 0.3;
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
    
    //    NSLog(@"self.frame = %@", NSStringFromCGRect(self.frame));
    //    NSLog(@"table.frame = %@", NSStringFromCGRect(table.frame));
    //    NSLog(@"selector.frame = %@", NSStringFromCGRect(selector.frame));
}

#pragma mark - Other methods

- (NSInteger)componentFromTableView:(UITableView *)tableView
{
    return [self.tables indexOfObject:tableView];
}

- (void)alignTableViewToRowBoundary:(UITableView *)tableView
{
    //    NSLog(@"contentOffset = %@", NSStringFromCGPoint(tableView.contentOffset));
    //    NSLog(@"rowHeight = %f", tableView.rowHeight);
    
    const CGPoint relativeOffset = CGPointMake(0, tableView.contentOffset.y + tableView.contentInset.top);
    //    NSLog(@"relativeOffset = %@", NSStringFromCGPoint(relativeOffset));
    
    const NSUInteger row = round(relativeOffset.y / tableView.rowHeight);
    //    NSLog(@"row = %d", row);
    
    const NSInteger component = [self componentFromTableView:tableView];
    [self selectRow:row inComponent:component animated:YES];
}


@end
