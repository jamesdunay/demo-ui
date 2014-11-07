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
-(void)displayAllScreensWithStartingDisplayOn:(CGFloat)startingPosition;
@end

@interface BottomMenu : UIView <UIGestureRecognizerDelegate>
@property(nonatomic) id <BottomMenuDelegate> mBottomMenuDelegate;

@property(nonatomic) CGFloat displayOverviewYCoord;
@property(nonatomic) CGFloat screenHeight;
@property(nonatomic) CGSize defaultFrameSize;

-(void)scrollOverviewButtonsWithPercentage:(CGFloat)offsetPercentage;
-(void)returnMenuToSelected:(NSInteger)index;
-(void)defaultToShopPressed;

@end