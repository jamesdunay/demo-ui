//
//  UIImageView+Gestures.m
//  Shop-Menu
//
//  Created by james.dunay on 11/5/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "UIImageView+Gestures.h"
#import "UIImage+GestureImages.h"

@implementation UIImageView (Gestures)


+ ( UIImageView * )create:( Gesture )gesture withRepeatCount:( NSInteger )repeatCount{
 
    UIImageView* imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    switch (gesture) {
        case GestureDoubleTap:{
            imageView.image = [UIImage doubleTapImage];
            break;
        }
        case GestureSwipe:{
            imageView.image = [UIImage swipeImage];
            break;
        }
            
        case GestureTap:{
            imageView.image = [UIImage tapImage];
            break;
        }
            
        case GestureLongPress:{
            imageView.image = [UIImage longPressImage];
            break;
        }
            
        default:
            break;
    }
    
    return imageView;
}


@end
