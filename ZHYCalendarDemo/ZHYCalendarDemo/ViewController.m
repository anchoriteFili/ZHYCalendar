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
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.calenderView];
}

#pragma mark 日历view的代理方法
- (void)selectEnsureDate:(NSString *)ensureDate {
    
    NSLog(@"ensureDate ***** %@",ensureDate);
    
    self.dateLabel.text = ensureDate;
}


- (IBAction)buttonClick:(UIButton *)sender {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.calenderView.frame = CGRectMake(0, HEIGHT-350, WIDTH, 350);
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
