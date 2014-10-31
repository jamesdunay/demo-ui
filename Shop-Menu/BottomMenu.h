//
//  BottomMenu.h
//  Shop-Menu
//
//  Created by james.dunay on 9/12/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomMenuDelegate <NSObject>
-(void)didSwitchToIndex:(int)pageIndex;
-(void)fadeToIndex:(int)pageIndex;
-(void)manualOffsetScrollview:(CGFloat)offset;
-(void)darkenScreen;
-(void)lightenScreen;
@end

@interface BottomMenu : UIView <UIGestureRecognizerDelegate>
@property(nonatomic) id <BottomMenuDelegate> mBottomMenuDelegate;
@end