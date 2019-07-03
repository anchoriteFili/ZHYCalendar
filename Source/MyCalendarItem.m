//
//  MyCalendarItem.m
//  开始编写日历控件
//
//  Created by 赵宏亚 on 16/6/30.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import "MyCalendarItem.h"


@implementation MyCalendarItem
{
    UIButton  *_selectButton;
    NSMutableArray *_daysArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _daysArray = [NSMutableArray arrayWithCapacity:42];
        for (int i = 0; i < 42; i++) {
            UIButton *button = [[UIButton alloc] init];
            [self addSubview:button];
            [_daysArray addObject:button];
        }
    }
    return self;
}

#pragma mark - date

- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
//  获取返回今天的日期
//    NSLog(@"---- %ld", [components day]);
    return [components day];
}

#pragma mark 获取给定的时间的月
- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
  //  获取返回yue
    return [components month];
}

#pragma mark 获取年？
- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
//    NSLog(@"--year---- %ld", [components year]);
//    返回年
    return [components year];
}

#pragma mark 获取每个月的第一周？
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];

    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
//   comp 信息为年月日
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
//        NSLog(@"--comp---- %@", comp);

    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
//    设定每月的第一天从星期几开始 周日为1
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
//    NSLog(@"--firstWeekday---- %ld", firstWeekday);
//    NSLog(@"--firstDayOfMonthDate---- %@", firstDayOfMonthDate);

    return firstWeekday - 1;
}

#pragma mark 获取给定时间的某月的总共天数
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

#pragma mark 选定日期后退一个月
- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
//    上个月的今天
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
//    NSLog(@"lastMonth:newDate===== %@", newDate);
    return newDate;
}

#pragma mark 下个月的某个日期
- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
//    NSLog(@"nextMonth:newDate===== %@", newDate);

    return newDate;
}

#pragma mark 根据日期创建view
#pragma mark - create View
- (void)setDate:(NSDate *)date{
    _date = date;
    
    [self createCalendarViewWith:date];
}

#pragma mark ********创建view的地方在这里**********
- (void)createCalendarViewWith:(NSDate *)date{
    
    //  3.days (1-31)
    for (int i = 0; i < 42; i++) {
        
        int x = (i % 7) * WIDTH/7;
        int y = (i / 7) * 36;
        
        UIButton *dayButton = _daysArray[i];
        dayButton.frame = CGRectMake(x, y, WIDTH/7, 36);
        dayButton.titleLabel.font = [UIFont systemFontOfSize:12];
        dayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        dayButton.backgroundColor = RGB_COLOR(247, 247, 247);
        [dayButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [dayButton addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
        
//      此处添加tag值，用于处理交互
        dayButton.tag = 1000 + i;
        
        NSInteger daysInLastMonth = [self totaldaysInMonth:[self lastMonth:date]];
        NSInteger daysInThisMonth = [self totaldaysInMonth:date];
        NSInteger firstWeekday    = [self firstWeekdayInThisMonth:date];
        
        NSInteger day = 0;
        
        if (i < firstWeekday) {
            day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else{
            day = i - firstWeekday + 1;
            [self setStyle_AfterToday:dayButton];
        }
        
        [dayButton setTitle:[NSString stringWithFormat:@"%li", (long)day] forState:UIControlStateNormal];
        
        // this month
        if ([self month:date] == [self month:[NSDate date]] && [self year:date] == [self year:[NSDate date]]) {
            
            NSInteger todayIndex = [self day:date] + firstWeekday - 1;
            
            if (i < todayIndex && i >= firstWeekday) {
                [self setStyle_BeforeToday:dayButton];
            
            }else if(i ==  todayIndex){
                [self setStyle_Today:dayButton];
                
            }
        }
    }
}

#pragma mark - output date
-(void)logDate:(UIButton *)dayBtn
{
    
    
    NSInteger day = [[dayBtn titleForState:UIControlStateNormal] integerValue];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear) fromDate:self.date];
    
    NSDate *tmpDate = [self dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld",(long)[comp year],(long)[comp month],(long)day]];
    
    // 判断是否是今天
    if ([[dayBtn titleForState:UIControlStateNormal] isEqualToString:@"今天"]) {
        day = [comp day];
    }
    
#pragma mark 将按钮和日期数据传过去 注：按钮的背景颜色变化和字体的变化都放到上级页面中
    if (self.delegate && [self.delegate respondsToSelector:@selector(getCurrentButton:day:month:year:andDate:)]) {
        
        [self.delegate getCurrentButton:dayBtn day:day month:[comp month] year:[comp year] andDate:tmpDate];
    }
    
}

- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
}

#pragma mark - date button style
#pragma mark 超出本月的月份的点击事件
- (void)setStyle_BeyondThisMonth:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    if (self.isOrderTime) {
//        btn.enabled = YES;
//        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    }

}

#pragma mrak 超过当前日期的按钮状态设置
- (void)setStyle_BeforeToday:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    if (self.isOrderTime) {
        btn.enabled = YES;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }

}

#pragma mark 今天按钮的点击事件
- (void)setStyle_Today:(UIButton *)btn
{
    btn.enabled = YES;
    if (self.isOrderTime) {
        btn.enabled = YES;
    }
    [btn setTitle:@"今天" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:19/255.0 green:143/255.0 blue:221/255.0 alpha:1] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
}

- (void)setStyle_AfterToday:(UIButton *)btn
{
    btn.enabled = YES;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if (self.isOrderTime) {
        btn.enabled = NO;
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }

}


@end
