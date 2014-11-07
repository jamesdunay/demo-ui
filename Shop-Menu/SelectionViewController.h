//
//  SelectionViewController.h
//  Shop-Menu
//
//  Created by james.dunay on 11/4/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntroductionView.h"

@interface SelectionViewController : UIViewController <IntroductionViewDelegate,  UITableViewDataSource, UITableViewDelegate>

-(void)popNav;

@end
