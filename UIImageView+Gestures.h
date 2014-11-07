//
//  UIImageView+Gestures.h
//  Shop-Menu
//
//  Created by james.dunay on 11/5/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, Gesture) {
    GestureNone = 0,
    GestureDoubleTap,
    GestureSwipe,
    GestureLongPress,
    GestureTap
};

@interface UIImageView (Gestures)

+ ( UIImageView * )create:( Gesture )gesture withRepeatCount:( NSInteger )repeatCount;

@end
