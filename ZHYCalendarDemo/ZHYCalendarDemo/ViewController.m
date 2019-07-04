//
//  ViewController.m
//  ZHYCalendarDemo
//
//  Created by zetafin on 2019/7/3.
//  Copyright © 2019 赵宏亚. All rights reserved.
//

#import "ViewController.h"
#import "CalendarView.h"

@interface ViewController ()<CalendarViewDelegate>

@property (nonatomic,retain) CalendarView *calenderView; // 日历view
@property (weak, nonatomic) IBOutlet UILabel *dateLabelbBegin; // 开始日历label
@property (weak, nonatomic) IBOutlet UILabel *dateLabelEnd; // 结束日期label


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.calenderView];
}

// 点击调取日历
- (IBAction)buttonClick:(UIButton *)sender {
    
    // 对日历中的各种的状态进行处理
    if ([sender.titleLabel.text isEqualToString:@"日期开始"]) {
        
        [self.calenderView updateCalendarViewWithDateStyleEnum:EarlestDateStyleEnum];
    } else if ([sender.titleLabel.text isEqualToString:@"日期结束"]) {
        
        [self.calenderView updateCalendarViewWithDateStyleEnum:LatestDateStyleEnum];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.calenderView.frame = CGRectMake(0, HEIGHT-350, WIDTH, 350);
    }];
}

// 返回时间代理方法
- (void)calendarViewDelegateEnsureDate:(NSString *)ensureDate withDateStyle:(DateStyleEnum)style {
    
    NSLog(@"ensureDate **** %@",ensureDate);
    
    if (style == EarlestDateStyleEnum) { // 返回起始时间
        self.dateLabelbBegin.text = ensureDate;
    } else if (style == LatestDateStyleEnum) { // 返回结束时间
        self.dateLabelEnd.text = ensureDate;
    } else if (style == CancelDateStyleEnum) { // 点击取消方法
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.calenderView.frame = CGRectMake(0, HEIGHT, WIDTH, 350);
    }];
}


#pragma mark 日历view懒加载
- (CalendarView *)calenderView {
    if (!_calenderView) {
        _calenderView = [[CalendarView alloc] init];
        _calenderView.frame = CGRectMake(0, HEIGHT, WIDTH, 350);
        _calenderView.delegate = self; // 设置日历代理
    }
    return _calenderView;
}


@end
