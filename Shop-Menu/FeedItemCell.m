//
//  FeedItemCell.m
//  Shop-Menu
//
//  Created by james.dunay on 10/6/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "FeedItemCell.h"
#import <QuartzCore/QuartzCore.h>

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface FeedItemCell()

@property(nonatomic, strong)UIImageView* image;
@property(nonatomic, strong)UILabel* seeMore;
@property(nonatomic, strong)UILabel* seeLess;
@property(nonatomic, strong)UIScrollView* scrollView;
@property(nonatomic, strong)UIButton* obsessButton;


@end

@implementation FeedItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width + 15, 0, self.frame.size.width - 30, self.frame.size.height - 5)];
        self.image.backgroundColor = [UIColor lightGrayColor];
        
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width * 4, self.frame.size.height);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.clipsToBounds = NO;
        [self addSubview:self.scrollView];
        
        self.obsessButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.obsessButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.obsessButton.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:self.obsessButton];
        
        self.seeMore = [[UILabel alloc] init];
        self.seeMore.text = @"See more like this";
        self.seeMore.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:self.seeMore];
        
        self.seeLess = [[UILabel alloc] init];
        self.seeLess.text = @"See less of this";
        self.seeLess.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:self.seeLess];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setNeedsUpdateConstraints];
        [self setNeedsLayout];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)layoutSubviews{

    [super layoutSubviews];

    self.image.frame = CGRectMake(self.frame.size.width + 15, 0, self.frame.size.width - 30, self.frame.size.height - 5);
    
    self.seeMore.frame = CGRectMake(0, 40, self.frame.size.width - 40, 40);
    self.seeLess.frame = CGRectMake(0, 100, self.frame.size.width - 40, 40);

    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    self.scrollView.delegate = self;
    [self.scrollView addSubview:self.image];
}

-(void)updateConstraints{
    [super updateConstraints];
    
    NSMutableArray* constraints = [[NSMutableArray alloc] init];

    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.obsessButton
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.f
                                                         constant:10.f
                            ]];
    
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.obsessButton
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.f
                                                         constant:10.f
                            ]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.obsessButton
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.f
                                                         constant:-10.f
                            ]];

    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.obsessButton
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f
                                                         constant:50.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.obsessButton
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f
                                                         constant:50.f
                            ]];
    
    
    [self addConstraints:constraints];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int pageNumber = ((int)self.scrollView.contentOffset.x/320.f);
    
    if (pageNumber == 0) {
        
        int contentOffSet = scrollView.contentOffset.x;
        CGFloat offset = 100 -(contentOffSet % 320 / 3.2);
        
        float radiansToRotate = DEGREES_TO_RADIANS(offset/2);
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / 500.0;
        rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, radiansToRotate, 0.f, 1.0f, 0.0f);
        
        self.image.layer.transform = rotationAndPerspectiveTransform;
        self.image.alpha = 1 - offset/200;
        self.obsessButton.alpha = 1 - offset/100 * 2;
        
        self.seeMore.frame = CGRectMake(-100 + offset* 2, 40, self.frame.size.width - 40, 40);
        self.seeLess.frame = CGRectMake(-100 + offset* 2, 100, self.frame.size.width - 40, 40);
        
        self.seeMore.alpha = offset/100 * offset/100 * offset/100;
        self.seeLess.alpha = offset/100 * offset/100 * offset/100;
        
        self.scrollView.frame = CGRectMake(-offset, 0, self.frame.size.width, self.frame.size.height);
    }else{
        self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
}

@end









