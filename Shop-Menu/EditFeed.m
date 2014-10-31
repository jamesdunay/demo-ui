//
//  EditFeed.m
//  Shop-Menu
//
//  Created by james.dunay on 10/2/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "EditFeed.h"

@interface EditFeed()
@property(nonatomic, strong)NSMutableArray* nameLabels;


@end

@implementation EditFeed

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
    
        NSArray* names = @[@"Gender", @"Designer", @"Categories", @"Sizes"];
        self.nameLabels = [[NSMutableArray alloc] init];
        
        [names enumerateObjectsUsingBlock:^(NSString* name, NSUInteger idx, BOOL *stop) {
            UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 100+ (75*idx), 320, 50)];
            nameLabel.text = name;
            [self addSubview:nameLabel];
            [self.nameLabels addObject:nameLabel];
        }];
    }
    
    return self;
}

-(void)showItems{
    
    [self.nameLabels enumerateObjectsUsingBlock:^(UILabel* nameLabel, NSUInteger idx, BOOL *stop) {
        nameLabel.alpha = 0;
        [UIView animateWithDuration:.2
                              delay:.1 * idx + .2
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             nameLabel.alpha = 1.f;
                         }
                         completion:nil];
    }];
}

@end
