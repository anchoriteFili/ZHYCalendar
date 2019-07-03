//
//  MyCalendarItem.h
//  开始编写日历控件
//
//  Created by 赵宏亚 on 16/6/30.
//  Copyright © 2016年 赵宏亚. All rights reserved.
//

#import <UIKit/UIKit.h>

#define itemWidth 50
#define itemHeight 36
#define RGB_COLOR(R, G, B) [UIColor colorWithRed:((R)/255.0f) green:((G)/255.0f) blue:((B)/255.0f) alpha:1.0f]
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@protocol MyCalendarItemDelegate <NSObject>


//^(NSInteger day, NSInteger month, NSInteger year, NSDate *date)

- (void)getCurrentButton:(UIButton *)button day:(NSInteger)day month:(NSInteger)month year:(NSInteger)year andDate:(NSDate *)date; //到AppDelegate中执行该方法

@end

@interface MyCalendarItem : UIView

- (void)createCalendarViewWith:(NSDate *)date;
- (NSDate *)nextMonth:(NSDate *)date;
- (NSDate *)lastMonth:(NSDate *)date;
@property (nonatomic, assign)BOOL isOrderTime;
@property (nonatomic, strong) NSDate *date;

@property (nonatomic,strong) UIButton *lastButton; // 承载上一个button

#pragma mark 创建代理属性
@property (nonatomic,assign) id<MyCalendarItemDelegate,NSObject> delegate;

@end
