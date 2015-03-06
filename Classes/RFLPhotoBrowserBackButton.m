//
//  RFLPhotoBrowserBackBtutton.m
//  SilentLog
//
//  Created by tsutomu on 2015/03/06.
//  Copyright (c) 2015年 Rei-Frontier. All rights reserved.
//

#import "RFLPhotoBrowserBackButton.h"

@implementation RFLPhotoBrowserBackButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = self.bounds;
    // 自身の bounds を Insets 分大きさを変える
    rect.origin.x += self.tappableInsets.left;
    rect.origin.y += self.tappableInsets.top;
    rect.size.width -= (self.tappableInsets.left + self.tappableInsets.right);
    rect.size.height -= (self.tappableInsets.top + self.tappableInsets.bottom);
    // 変更した rect に point が含まれるかどうかを返す
    return CGRectContainsPoint(rect, point);
}


@end