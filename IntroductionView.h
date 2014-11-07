//
//  IntroductionView.h
//  Shop-Menu
//
//  Created by james.dunay on 11/4/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IntroductionViewDelegate <NSObject>

-(void)completedIntroduction;

@end

@interface IntroductionView : UIView

@property(nonatomic, strong)id <IntroductionViewDelegate> kIntroductionViewDelegate;

@end
