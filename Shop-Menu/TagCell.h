//
//  TagCell.h
//  Shop-Menu
//
//  Created by james.dunay on 10/6/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagCellDelegate
-(void)closeTagCell;
@end

@interface TagCell : UITableViewCell <UIGestureRecognizerDelegate>

@property(nonatomic, strong) id <TagCellDelegate> tagCellDelegate;

@property(nonatomic)BOOL isOpen;
-(void)openCell;
-(void)cellExpanded;

@end
