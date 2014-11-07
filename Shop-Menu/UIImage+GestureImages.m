//
//  UIImage+GestureImages.m
//  Shop-Menu
//
//  Created by james.dunay on 11/5/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "UIImage+GestureImages.h"

@implementation UIImage (GestureImages)

+ ( UIImage * )doubleTapImage{
    return [UIImage animatedImageNamed:@"double_tap-" duration:1.0f];
}

+ ( UIImage * )swipeImage{
    return [UIImage animatedImageNamed:@"swipe-" duration:1.5f];
}

+ ( UIImage * )tapImage{
    return [UIImage animatedImageNamed:@"tap-" duration:1.0f];
}

+ ( UIImage * )longPressImage{
    return [UIImage animatedImageNamed:@"long_press-" duration:1.5f];
}

@end
