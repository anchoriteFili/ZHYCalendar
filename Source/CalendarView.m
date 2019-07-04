//
//  CalendarView.m
//  开始编写日历控件
//
//  Created by 赵宏亚 on 16/6/30.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import "CalendarView.h"

CGFloat scrollHeight = 216.0; // 全局变量scrollView的高度

@implementation CalendarView

/**
 view的xib创建：直接创建view的xib,创建view，两者classname一致，连接xib要调用下面方法
 */
#pragma mark 要想调用xib，需写下面部分
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"CalendarView" owner:self options:nil] lastObject];
        
#pragma mark 获取当前月份和年份
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
        
        self.currentYear = [dateComponent year];
        self.currentMonth =  [dateComponent month];
        
        [self.yearButton setTitle:[NSString stringWithFormat:@"%ld",(long)self.currentYear] forState:UIControlStateNormal];
        [self.monthButton setTitle:[NSString stringWithFormat:@"%ld月",(long)self.currentMonth] forState:UIControlStateNormal];
        
        // 年份大按钮的赋值
        [self.currentYearButton setTitle:[NSString stringWithFormat:@"%ld",(long)self.currentYear] forState:UIControlStateNormal];
        [self.followYearButton setTitle:[NSString stringWithFormat:@"%ld",(long)self.currentYear+1] forState:UIControlStateNormal];
        
        self.lastMonthButton.enabled = NO;
        self.lastYearButton.enabled = NO;
        
        self.yearSelectView.hidden = YES;
        self.monthSelectView.hidden = YES;
                
        self.yearTag = 2016;
        self.monthTag = 1000 + self.currentMonth;
        
        // 取消按钮设置边框
        self.cancalButton.layer.borderWidth = 2;  // 给图层添加一个有色边框
        self.cancalButton.layer.borderColor = RGB_COLOR(255, 153, 0).CGColor;
        
        [self setup];

    }
    return self;
}

- (void)setup {
    CGFloat viewH = 36 * 6;
    
#pragma mark scrollView部分
    self.scrollView.scrollEnabled = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    // today month
    self.calendarView = [[MyCalendarItem alloc] init];
    self.calendarView.tag = 2000;
    
    if (self.isOrdersTime) {
        self.calendarView.isOrderTime = YES;
    }
    self.calendarView.frame = CGRectMake(0, 0, WIDTH, viewH);
    if (self.isOrdersTime) {
        self.calendarView.frame = CGRectMake(0, 0 + 4*viewH, WIDTH, viewH);
    }
    [self.scrollView addSubview:self.calendarView];
    
    self.calendarView.date = [NSDate date];
    
    self.calendarView.delegate = self;
    
    // other month
    
#pragma mark 创建日历
    NSInteger totalMonth = 24 - self.currentMonth;
    self.totalMonth = totalMonth;
//    NSLog(@"totalMonth ===== %ld",(long)totalMonth);
    
    for (int i = 0; i < totalMonth; i ++) {
        MyCalendarItem *ca = [[MyCalendarItem alloc] init];
        ca.tag = 2001 + i;
        
        CGFloat caY = self.calendarView.frame.origin.y + viewH * (i + 1);
        if (self.isOrdersTime) {
            caY = self.calendarView.frame.origin.y - viewH * (i + 1);
        }
        ca.frame = CGRectMake(0, caY, WIDTH, viewH);
        
        NSDate *date = [NSDate date];
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        
        dateComponents.month = + (i + 1);
        if (self.isOrdersTime) {
            dateComponents.month = - (i + 1);
        }
        
        NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
        ca.date = newDate;
        ca.delegate = self;
        
        [self.scrollView addSubview:ca];
    }
    self.scrollView.contentSize = CGSizeMake(WIDTH, viewH * (totalMonth + 1) + 25);
}

#pragma mark 在scrollView停止减速时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    float currentPage = self.scrollView.contentOffset.y / scrollHeight;
    self.currentPage = [self floatToInt:currentPage];
    [self yearAndMonthButtonTitleChange];
}

#pragma mark 设置scrollView偏移量的地方
#pragma mark 上一年
- (IBAction)lastYearButtonClick:(UIButton *)sender {
    
    if (self.monthTag <= self.currentMonth+1000) {
        self.currentPage = 0;
        
    } else {
        self.currentPage -= 12;
    }
    [self scrollViewScrollToCurrentPage];
    
}

#pragma mark 下一年
- (IBAction)nextYearButtonClick:(UIButton *)sender {
    
    self.currentPage += 12;
    [self scrollViewScrollToCurrentPage];

}

#pragma mark 上个月
- (IBAction)lastMonthButtonClick:(UIButton *)sender {
    
    self.currentPage -= 1;
    [self scrollViewScrollToCurrentPage];
}

#pragma mark 下个月
- (IBAction)nextMonthButtonClick:(UIButton *)sender {
    
    self.currentPage ++;
    [self scrollViewScrollToCurrentPage];
}


- (void)scrollViewScrollToCurrentPage {
    
    // 直接设置当前的偏移量
    self.scrollView.contentOffset = CGPointMake(0, self.currentPage * scrollHeight);
    
    [self yearAndMonthButtonTitleChange];
    
}

- (void)yearAndMonthButtonTitleChange {
    
    /**
     下面的基本逻辑：
     如果：当前显示页数 > 12 - 当前月份 表示当前显示月份在第二年，则上一年按钮直接关闭
     如果：当前显示页数 <= 12 - 当前月份，表示当前显示月份为第一年，则下一年按钮关闭，上一年按钮打开
     如果：当前显示页数 > 12 - 当前月份，则月份显示 = 当前显示页 - (12 - 当前月份)
     如果：当前显示页数 <= 12 - 当前月份，则月份显示 = 当前月份 + 当前显示页
     */
    
    if (self.currentPage <= 0) {
        
        self.lastMonthButton.enabled = NO;
        self.nextMonthButton.enabled = YES;
        self.lastYearButton.enabled = NO;
        self.nextYearButton.enabled = YES;
        self.yearTag = 2016;
        self.monthTag = 1000+(long)self.currentMonth;
        
        [self.yearButton setTitle:[NSString stringWithFormat:@"%ld",(long)self.currentYear] forState:UIControlStateNormal];
        
        [self.monthButton setTitle:[NSString stringWithFormat:@"%ld月",(long)self.currentMonth] forState:UIControlStateNormal];
        
    } else if (self.currentPage > 0 && self.currentPage <= 12 - self.currentMonth) {
        
        self.lastMonthButton.enabled = YES;
        self.nextMonthButton.enabled = YES;
        self.lastYearButton.enabled = NO;
        self.nextYearButton.enabled = YES;
        self.yearTag = 2016;
        self.monthTag = 1000+self.currentPage + (long)self.currentMonth;
        
        [self.yearButton setTitle:[NSString stringWithFormat:@"%ld",(long)self.currentYear] forState:UIControlStateNormal];
        
        [self.monthButton setTitle:[NSString stringWithFormat:@"%ld月",self.currentPage + (long)self.currentMonth] forState:UIControlStateNormal];
        
    } else if (self.currentPage > 12 - self.currentMonth && self.currentPage < 24 - self.currentMonth) {
        
        self.lastMonthButton.enabled = YES;
        self.nextMonthButton.enabled = YES;
        self.lastYearButton.enabled = YES;
        self.nextYearButton.enabled = NO;
        self.yearTag = 2017;
        self.monthTag = 1000 + self.currentPage - (12 - (long)self.currentMonth);
        
        [self.yearButton setTitle:[NSString stringWithFormat:@"%ld",(long)self.currentYear+1] forState:UIControlStateNormal];
        
        [self.monthButton setTitle:[NSString stringWithFormat:@"%ld月",self.currentPage - (12 - (long)self.currentMonth)] forState:UIControlStateNormal];
        
    } else {
        
        self.lastMonthButton.enabled = YES;
        self.nextMonthButton.enabled = NO;
        self.lastYearButton.enabled = YES;
        self.nextYearButton.enabled = NO;
        self.yearTag = 2017;
        self.monthTag = 1012;
        
        [self.yearButton setTitle:[NSString stringWithFormat:@"%ld",(long)self.currentYear+1] forState:UIControlStateNormal];
        
        [self.monthButton setTitle:@"12月" forState:UIControlStateNormal];
        
    }
    
    // 两个页面没有隐藏的情况下进行实时更新
    if (self.yearSelectView.hidden == NO || self.monthSelectView.hidden == NO) {
        [self yearViewChange];
        [self monthViewChange];
    }
    
}

#pragma mark 四舍五入方法
- (int)floatToInt:(float)value {
    
    if (value + 0.5 - (int)value > 1) {
        return (int)value + 1;
    } else {
        return (int)value;
    }
}

#pragma mark **************年月点击部分*******************8
#pragma mark 年份按钮点击事件
- (IBAction)yearButtonClick:(UIButton *)sender {
    
    self.monthSelectView.hidden = YES;
    
    if (self.yearSelectView.hidden == NO) {
        self.yearSelectView.hidden = YES;
    } else {
        self.yearSelectView.hidden = NO;
    }
    
    [self yearViewChange];
    [self monthViewChange];
    
}

#pragma mark 年view上按钮点击事件
- (IBAction)yearViewButtonClick:(UIButton *)sender {
    /**
     逻辑：
     如果两次选择的年份tag值相等，即没有任何变化的话，不做任何操作
     如果两次选择的年份tag值不相等，则需判断新的年份tag值是2016还是2017
     如果是2016的话，则执行上一年方法即可，如果是2017，则执行下一年方法
     */
    
    if (self.yearTag == sender.tag) {
        //不做任何改变
    } else {
        
        self.yearTag = sender.tag;
        
        if (sender.tag == 2016) {
            
            if (self.monthTag <= self.currentMonth+1000) {
                self.currentPage = 0;
                
            } else {
                self.currentPage -= 12;
            }
            
        } else if (sender.tag == 2017) {
            
            self.currentPage += 12;
        }
        
        
        [self scrollViewScrollToCurrentPage];
    }
    
    [self yearViewChange];
    [self monthViewChange];
    self.monthSelectView.hidden = YES;
    self.yearSelectView.hidden = YES;
    
}

#pragma mark 年view的变化，这个点击上一年和下一年时也要调用
- (void)yearViewChange {
    
    if (self.yearTag == 2016) {
        UIButton *button = (UIButton  *)[self.yearSelectView viewWithTag:2016];
        button.backgroundColor = RGB_COLOR(255, 153, 0);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UIButton *buttonOne = (UIButton  *)[self.yearSelectView viewWithTag:2017];
        buttonOne.backgroundColor = RGB_COLOR(247, 247, 247);
        [buttonOne setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        
    } else if (self.yearTag == 2017) {
        
        UIButton *button = (UIButton  *)[self.yearSelectView viewWithTag:2017];
        button.backgroundColor = RGB_COLOR(255, 153, 0);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        UIButton *buttonOne = (UIButton  *)[self.yearSelectView viewWithTag:2016];
        buttonOne.backgroundColor = RGB_COLOR(247, 247, 247);
        [buttonOne setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
}

#pragma mark 月份按钮点击事件
- (IBAction)monthButtonClick:(UIButton *)sender {
    
    self.yearSelectView.hidden = YES;
    
    if (self.monthSelectView.hidden == NO) {
        self.monthSelectView.hidden = YES;
    } else {
        self.monthSelectView.hidden = NO;
    }
    
    [self monthViewChange];
    [self yearViewChange];
    
}

- (void)monthViewChange {
    
    /**
     基本逻辑：
     首先判断yearTag值，
     如果yearTag值为2017，全票通过，
     如果yearTag值为2016，则需要循环判断是否关闭点击事件
     并且需要循环设置背景颜色
     */
    
    for (int i = 1; i < 13; i ++) {
        
        UIButton *button = (UIButton  *)[self.monthSelectView viewWithTag:(1000+i)];
        button.backgroundColor = RGB_COLOR(247, 247, 247);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        if (self.yearTag == 2016) {
            
            if (i < self.currentMonth) {
                button.enabled = NO;
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                
            } else {
                button.enabled = YES;
            }
            
        } else if (self.yearTag == 2017) {
            
            button.enabled = YES;
        }
    }
    
    UIButton *button = (UIButton  *)[self.monthSelectView viewWithTag:self.monthTag];
    button.backgroundColor = RGB_COLOR(255, 153, 0);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    button.selected = YES;
}

#pragma mark 月view点击事件
- (IBAction)monthViewButtonClick:(UIButton *)sender {
    
    self.monthTag = sender.tag;
    [self monthViewChange];
    [self yearViewChange];
    
//    NSLog(@"self.monthTag ======= %ld",self.monthTag);
    
    /**
     计算：
     当为2016时： page = monthTag - 1000 - currentMonth;
     当为2017时： page = monthTag - 1000 + (12 - currentMonth)
     */
    
    if (self.yearTag == 2016) {
        
        self.currentPage = self.monthTag - 1000 - self.currentMonth;
    } else if (self.yearTag == 2017) {
        
        self.currentPage = self.monthTag - 1000 + (12 - self.currentMonth);
    }
    
//    NSLog(@"self.currentPage ======= %ld",self.currentPage);
    
    [self scrollViewScrollToCurrentPage];
    
    self.monthSelectView.hidden = YES;
    self.yearSelectView.hidden = YES;
    
}

#pragma mark 取消按钮点击事件
- (IBAction)cancalButtonClick:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(calendarViewDelegateEnsureDate:withDateStyle:)]) {
        [self.delegate calendarViewDelegateEnsureDate:@"" withDateStyle:CancelDateStyleEnum];
    }
}


#pragma mark 确定按钮点击事件
- (IBAction)ensureButtonClick:(UIButton *)sender {
    
    if (self.selectedDate.length) {
        if (self.dateStyleEnum == LatestDateStyleEnum) {
            self.latestDate = self.selectedDate;
            self.latestDateButton = self.currentButton;
            self.latestDatePage = self.transferPage;
        } else {
            self.earliestDate = self.selectedDate;
            self.earliestDateButton = self.currentButton;
            self.earliestDatePage = self.transferPage;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(calendarViewDelegateEnsureDate:withDateStyle:)]) {
            [self.delegate calendarViewDelegateEnsureDate:self.selectedDate withDateStyle:self.dateStyleEnum];
        }
    }
}

#pragma mark 刷新页面的数据
- (void)updateCalendarViewWithDateStyleEnum:(DateStyleEnum)dateStyleEnum {
    
    // 按钮和时间
    if (self.currentButton) {
        self.currentButton.backgroundColor = RGB_COLOR(247, 247, 247);
        [self.currentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    if (self.selectedDate) {
        self.selectedDate = @"";
    }
    
    /**
     刷新的基本逻辑：
     1. 进行翻页，翻到指定的页数中。
     2. 对相应的button进行变色
     */
    
    self.dateStyleEnum = dateStyleEnum;
    
    if (dateStyleEnum == EarlestDateStyleEnum) {
        
        self.currentPage = self.earliestDatePage;
        [self scrollViewScrollToCurrentPage];
        
        [self enableSubviewsOfCalendarViews]; // 遍历处理按钮是否可点击状态
        
        if (self.earliestDateButton && self.latestDateButton) {
            
            self.currentButton = self.earliestDateButton;
            
            // 先设置变灰颜色，在设置变橙色，防止两者同时点击同一个按钮造成冲突
            self.latestDateButton.backgroundColor = RGB_COLOR(247, 247, 247);
            [self.latestDateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            self.earliestDateButton.backgroundColor = RGB_COLOR(255, 153, 0);
            [self.earliestDateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        } else if (self.earliestDateButton && !self.latestDateButton) {
            
            self.currentButton = self.earliestDateButton;
            
            self.earliestDateButton.backgroundColor = RGB_COLOR(255, 153, 0);
            [self.earliestDateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        } else if (!self.earliestDateButton && self.latestDateButton) {
            
            self.latestDateButton.backgroundColor = RGB_COLOR(247, 247, 247);
            [self.latestDateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
    } else if (dateStyleEnum == LatestDateStyleEnum) {
        
        
        self.currentPage = self.latestDatePage;
        [self scrollViewScrollToCurrentPage];
        
        [self enableSubviewsOfCalendarViews]; // 遍历处理按钮是否可点击状态
        
        if (self.earliestDateButton && self.latestDateButton) {
            
            self.currentButton = self.latestDateButton;
            
            self.earliestDateButton.backgroundColor = RGB_COLOR(247, 247, 247);
            [self.earliestDateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

            self.latestDateButton.backgroundColor = RGB_COLOR(255, 153, 0);
            [self.latestDateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        } else if (!self.earliestDateButton && self.latestDateButton) {
            
            self.currentButton = self.latestDateButton;
            
            self.latestDateButton.backgroundColor = RGB_COLOR(255, 153, 0);
            [self.latestDateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        } else if (self.earliestDateButton && !self.latestDateButton) {
            
            self.currentPage = self.earliestDatePage;
            [self scrollViewScrollToCurrentPage];
            
            self.earliestDateButton.backgroundColor = RGB_COLOR(247, 247, 247);
            [self.earliestDateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
//    NSLog(@"self.currentButton.tag ====== %ld",(long)self.currentButton.tag);
    
}

#pragma mark 日历内部按钮是否可点击做处理
- (void)enableSubviewsOfCalendarViews {
    
    // 1. 首先将所有的按钮刷新为可点击状态
    for (NSInteger i = 0; i <= self.totalMonth; i ++) {
        
        MyCalendarItem *calendarView = (MyCalendarItem *)[self.scrollView viewWithTag:2000+i];
        for (UIButton *button in calendarView.subviews) {
            
            button.enabled = YES;
        }
    }
    
    if (self.dateStyleEnum == EarlestDateStyleEnum) {

//         2. 如果latestDateButton.tag数据都存在，则将其后边的按钮都设成不可点

        if (self.latestDateButton) {
            
            for (NSInteger i = self.latestDateButton.tag-999; i < 42; i ++) {
                
                UIButton *button = self.latestDateButton.superview.subviews[i];
                
                button.enabled = NO;
            }
            
            for (NSInteger i = self.latestDateButton.superview.tag-1999; i <= self.totalMonth; i ++) {
                
                MyCalendarItem *calendarView = (MyCalendarItem *)[self.scrollView viewWithTag:2000+i];
                
                for (UIButton *button in calendarView.subviews) {
                    
                    button.enabled = NO;
                }
            }
        }
        
    } else if (self.dateStyleEnum == LatestDateStyleEnum) {
        
        if (self.earliestDateButton) {
            
            for (NSInteger i = self.earliestDateButton.tag-1001; i > 0; i --) {
                
                UIButton *button = self.earliestDateButton.superview.subviews[i];
                
                button.enabled = NO;
            }
            
            for (NSInteger i = self.earliestDateButton.superview.tag-2000; i >= 0; i --) {
                
                if (i == self.earliestDateButton.superview.tag-2000) {
                    continue;
                }
                
                MyCalendarItem *calendarView = (MyCalendarItem *)[self.scrollView viewWithTag:2000+i];
                
                for (UIButton *button in calendarView.subviews) {
                    
                    button.enabled = NO;
                }
            }
        }
    }
    
    // 1. 首先将所有的按钮刷新为可点击状态
    for (NSInteger i = 0; i <= self.totalMonth; i ++) {
        
        MyCalendarItem *calendarView = (MyCalendarItem *)[self.scrollView viewWithTag:2000+i];
        for (UIButton *button in calendarView.subviews) {
            
            if (button.titleLabel.textColor == [UIColor lightGrayColor]) {
//                NSLog(@"灰色的字体"); //灰色字体，不能点击
                button.enabled = NO;
            }
        }
    }
    
}

#pragma mark 日历代理方法，处理点击事件
- (void)getCurrentButton:(UIButton *)button day:(NSInteger)day month:(NSInteger)month year:(NSInteger)year andDate:(NSDate *)date {
    
#pragma mark 选择按钮处理部分
    if (!self.currentButton) {
        self.currentButton = button;
    } else {
        self.currentButton.backgroundColor = RGB_COLOR(247, 247, 247);
        [self.currentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    button.backgroundColor = RGB_COLOR(255, 153, 0);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.currentButton = button;
    
#pragma mark 点击按钮时记录当前页面
    self.transferPage = self.currentPage;
    
#pragma mark 日期处理部分
    self.date = date;
    self.selectedDate = [NSString stringWithFormat:@"%li-%li-%li",(long)year,(long)month,(long)day];
    
    NSLog(@"self.selectedDate ====== %@",self.selectedDate);
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
