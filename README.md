![](https://github.com/anchoriteFili/ZHYCalendar/blob/master/ZHYCalendar.png)<br>

### 说明：

> 可进行`单个日期选择`和`日期区间选择`的简约的`日历小工具`。<br>
> **时间区间逻辑**：`开始日期`不能大于`结束日期`，`结束日期`不能小于`开始日期`。

#### 添加方法

```ruby
pod 'ZHYCalendar'
```

### 使用方法

1. 添加头文件和代理 `<CalendarViewDelegate>`

```objc
#import "CalendarView.h"
```

2. 直接添加CalendarView

```objc
@property (nonatomic,retain) CalendarView *calenderView; // 日历view

#pragma mark 日历view懒加载
- (CalendarView *)calenderView {
    if (!_calenderView) {
        _calenderView = [[CalendarView alloc] init];
        _calenderView.frame = CGRectMake(0, HEIGHT, WIDTH, 350);
        _calenderView.delegate = self; // 设置日历代理
    }
    return _calenderView;
}

[self.view addSubview:self.calenderView];
```

3. 调取日历

> 有时间区间调取方法
```objc
// 点击调取日历
- (IBAction)buttonClick:(UIButton *)sender {
    
    // 对日历中的各种的状态进行处理
    if ([sender.titleLabel.text isEqualToString:@"日期开始"]) {
        [self.calenderView updateCalendarViewWithDateStyleEnum:EarlestDateStyleEnum];
    } else if ([sender.titleLabel.text isEqualToString:@"日期结束"]) {
        [self.calenderView updateCalendarViewWithDateStyleEnum:LatestDateStyleEnum];
    }
    
    // 日历显示动画
    [UIView animateWithDuration:0.2 animations:^{
        self.calenderView.frame = CGRectMake(0, HEIGHT-350, WIDTH, 350);
    }];
}
```

> 没有时间区间调取方法

```objc
// 点击调取日历
- (IBAction)buttonClick:(UIButton *)sender {
    // 日历显示动画
    [UIView animateWithDuration:0.2 animations:^{
        self.calenderView.frame = CGRectMake(0, HEIGHT-350, WIDTH, 350);
    }];
}
```

4. 代理方法实现

> 有无时间区间都会调用此代理，无区间默认返回起始时间
```objc
// 返回时间代理方法
- (void)calendarViewDelegateEnsureDate:(NSString *)ensureDate withDateStyle:(DateStyleEnum)style {
    
    NSLog(@"ensureDate **** %@",ensureDate);
    
    if (style == EarlestDateStyleEnum) { // 返回起始时间

    } else if (style == LatestDateStyleEnum) { // 返回结束时间

    } else if (style == CancelDateStyleEnum) { // 点击取消方法
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.calenderView.frame = CGRectMake(0, HEIGHT, WIDTH, 350);
    }];
}
```

**具体使用可详见[demo](https://github.com/anchoriteFili/ZHYCalendar)**
