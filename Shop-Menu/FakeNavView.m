//
//  FakeNavView.m
//  Shop-Menu
//
//  Created by james.dunay on 10/16/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "FakeNavView.h"

@interface FakeNavView()

@property(nonatomic, strong)UILabel* title;

@end

@implementation FakeNavView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver:self forKeyPath:@"currentTitle" options:0 context:nil];
        self.title = [[UILabel alloc] initWithFrame:frame];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22];
        [self addSubview:self.title];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"currentTitle"]) {
     
        [UIView animateWithDuration:.2 animations:^{
            self.title.alpha = 0;
        }completion:^(BOOL finished) {
            self.title.text = self.currentTitle;
            [UIView animateWithDuration:.4 animations:^{
                self.title.alpha = 1;
            }];
        }];
    }
}

@end
