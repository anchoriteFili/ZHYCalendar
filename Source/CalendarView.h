//
//  CalendarView.h
//  开始编写日历控件
//
//  Created by 赵宏亚 on 16/6/30.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCalendarItem.h"
#import <QuartzCore/QuartzCore.h>

// 底部三个按钮的选择
typedef NS_ENUM(NSInteger, DateStyleEnum) {
    EarlestDateStyleEnum, // 完成按钮点击_起始时间状态
    LatestDateStyleEnum, // 完成按钮点击_结束时间状态
    CancelDateStyleEnum  // 取消按钮点击
};

@protocol CalendarViewDelegate <NSObject>


/**
日历返回的日期

 @param ensureDate 返回的日期
 @param style 标记状态是起始时间/结束时间/取消按钮取消了选择
 */
- (void)calendarViewDelegateEnsureDate:(NSString *)ensureDate withDateStyle:(DateStyleEnum)style;

@end

@interface CalendarView : UIView<UIScrollViewDelegate,MyCalendarItemDelegate>

@property (nonatomic,assign) BOOL isCurrent;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) NSDate *date; // 当前选中的date
@property (nonatomic,strong) NSDate *goDate; // 出发时间
@property (nonatomic,assign) BOOL isOrdersTime;
@property (nonatomic,assign) NSInteger totalMonth; // 总月数


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView; // 承载日历
@property (weak, nonatomic) IBOutlet UIButton *yearButton; // 年按钮
@property (weak, nonatomic) IBOutlet UIButton *monthButton; // 月按钮
@property (weak, nonatomic) IBOutlet UIButton *lastYearButton; // 上一年按钮
@property (weak, nonatomic) IBOutlet UIButton *nextYearButton; // 下一年按钮
@property (weak, nonatomic) IBOutlet UIButton *lastMonthButton; // 上一月按钮
@property (weak, nonatomic) IBOutlet UIButton *nextMonthButton; // 下一月按钮
@property (weak, nonatomic) IBOutlet UIView *monthSelectView; // 月份按钮点击后创建view
@property (weak, nonatomic) IBOutlet UIView *yearSelectView; // 点击年时显示的页面
@property (weak, nonatomic) IBOutlet UIButton *cancalButton; // 取消按钮

@property (weak, nonatomic) IBOutlet UIButton *currentYearButton; // 当前年份按钮
@property (weak, nonatomic) IBOutlet UIButton *followYearButton; // 下一年大按钮

@property (nonatomic,strong) MyCalendarItem *calendarView; // 日历view
@property (nonatomic,retain) NSDateComponents *dateComponent; // 今日日历相关
@property (nonatomic,assign) NSInteger currentYear; // 当前的年份
@property (nonatomic,assign) NSInteger currentMonth; // 当前的月份
@property (nonatomic,assign) NSInteger yearTag; // 记录当前选择年的tag
@property (nonatomic,assign) NSInteger monthTag; // 记录当前选择月份的tag

@property (nonatomic,assign) NSInteger currentPage; //当前正在显示的页面页数
@property (nonatomic,assign) NSInteger transferPage; // 点击日期时记录日期所在页面
@property (nonatomic,assign) NSInteger earliestDatePage; //存储最早时间页面
@property (nonatomic,assign) NSInteger latestDatePage; //存储最晚时间页面

@property (nonatomic,strong) UIButton *currentButton; // 当前按钮
@property (nonatomic,strong) UIButton *earliestDateButton; // 存储最早时间按钮
@property (nonatomic,strong) UIButton *latestDateButton; // 存储最晚时间按钮

@property (nonatomic,copy) NSString *selectedDate; // 选择的时间
@property (nonatomic,copy) NSString *earliestDate; // 存储最早时间
@property (nonatomic,copy) NSString *latestDate; // 存储最晚时间

@property (nonatomic,assign) DateStyleEnum dateStyleEnum; // 最早时间和昨晚时间的判断
#pragma mark 创建代理属性
@property (nonatomic,assign) id<CalendarViewDelegate,NSObject> delegate;



/**
 当选用有时间区间日历时刷新状态

 @param dateStyleEnum 调起日历时标记是开始时间或者是结束时间
 */
- (void)updateCalendarViewWithDateStyleEnum:(DateStyleEnum)dateStyleEnum;

#pragma mark 日历内部按钮是否可点击做处理
- (void)enableSubviewsOfCalendarViews;


@end
