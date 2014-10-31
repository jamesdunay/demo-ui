//
//  FeedDetailView.h
//  Shop-Menu
//
//  Created by james.dunay on 10/1/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DetailViewState){
    detailViewStateNormal = 0,
    detailViewStateTagsDisplayed
};

@protocol FeedDetailViewDelegate <NSObject>
-(void)toggleFocusWithState:(DetailViewState)itemViewState;
@end

@interface FeedDetailView : UIView <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView* scrollView;
@property(nonatomic) id <FeedDetailViewDelegate> kFeedDetailViewDelegate;
@property(nonatomic)DetailViewState detailViewState;

@end
