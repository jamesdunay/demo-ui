//
//  FeedDetailView.m
//  Shop-Menu
//
//  Created by james.dunay on 10/1/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "FeedDetailView.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

static CGFloat detailsDefaultTopPosition = -200;
static CGFloat imageDefaultTopPosition = 64;
static CGFloat tagButtonDefaultTopPosition = 70;


@interface FeedDetailView()

@property(nonatomic) CGFloat firstX;
@property(nonatomic) CGFloat firstY;

@property(nonatomic, strong)UIImageView* productImage;
@property(nonatomic, strong)UIImageView* details;
@property(nonatomic, strong)UIButton* tagsButton;

@property(nonatomic, strong)UILabel* designerTag;
@property(nonatomic, strong)UILabel* categoryTag;

@property(nonatomic, strong)NSLayoutConstraint* scrollViewTopConstraint;
@property(nonatomic, strong)NSLayoutConstraint* detailsTopConstraint;
@property(nonatomic, strong)NSLayoutConstraint* tagButtonTopConstraint;
@property(nonatomic, strong)UIPanGestureRecognizer* panGesture;

@property(nonatomic, strong)UIScrollView* imageScrollView;


@end

@implementation FeedDetailView

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
     
        self.detailViewState = detailViewStateNormal;
        
        //NOT USED
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panImage:)];
        [self.panGesture setDelegate:self];
//        [self addGestureRecognizer:self.panGesture];
        
        self.productImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 280, self.frame.size.height - 64)];
        [self.productImage setBackgroundColor:[UIColor grayColor]];
        [self.imageScrollView addSubview:self.productImage];
        
        UITapGestureRecognizer* categoryTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedTag:)];
        [categoryTap setDelegate:self];
        
        UITapGestureRecognizer* designerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedTag:)];
        [designerTap setDelegate:self];
        
        self.designerTag = [[UILabel alloc] init];
        self.designerTag.text = @"Designer Tag";
        self.designerTag.alpha = 0.f;
        self.designerTag.translatesAutoresizingMaskIntoConstraints = NO;
        self.designerTag.textAlignment = NSTextAlignmentCenter;
        [self.designerTag addGestureRecognizer:designerTap];
        self.designerTag.userInteractionEnabled = YES;
        [self addSubview:self.designerTag];
        
        self.categoryTag = [[UILabel alloc] init];
        self.categoryTag.text = @"Category Tag";
        self.categoryTag.alpha = 0.f;
        self.categoryTag.translatesAutoresizingMaskIntoConstraints = NO;
        self.categoryTag.textAlignment = NSTextAlignmentCenter;
        [self.categoryTag addGestureRecognizer:categoryTap];
        self.categoryTag.userInteractionEnabled = YES;
        [self addSubview:self.categoryTag];
        
        self.imageScrollView = [[UIScrollView alloc] init];
        self.imageScrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height * 2);
        [self.imageScrollView addSubview:self.productImage];
        [self.imageScrollView setPagingEnabled:YES];
        [self.imageScrollView setDelegate:self];
        [self.imageScrollView canCancelContentTouches];
        [self.imageScrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.imageScrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview:self.imageScrollView];
        
        self.details = [[UIImageView alloc] init];
        [self.details setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.details setBackgroundColor:[UIColor colorWithWhite:.8f alpha:1.f]];
        [self addSubview:self.details];
        
        self.tagsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.tagsButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.tagsButton setBackgroundColor:[UIColor redColor]];
        [self.tagsButton addTarget:self action:@selector(toggleItemTags) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.tagsButton];
        
        [self setupConstraints];
        [self setupTagConstraints];
        [self setupDetailViewsAndConstraints];
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    [self updateConstraints];
}

-(void)setupConstraints{
    
    NSMutableArray* constraints = [[NSMutableArray alloc] init];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageScrollView]|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(_imageScrollView)
                            ]];

    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_details]|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(_details)
                            ]];
    
    self.scrollViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.imageScrollView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.f
                                                         constant:imageDefaultTopPosition
                            ];
    [constraints addObject:self.scrollViewTopConstraint];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.imageScrollView
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeHeight
                                                       multiplier:1.f
                                                         constant:0.f
                            ]];
    
    
    self.detailsTopConstraint = [NSLayoutConstraint constraintWithItem:self.details
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.f
                                                         constant:-200.f
                            ];
    [constraints addObject:self.detailsTopConstraint];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.details
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.f
                                                         constant:0.f
                            ]];
    
    
//    Tag Button Constraints
    self.tagButtonTopConstraint = [NSLayoutConstraint constraintWithItem:self.tagsButton
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.f
                                                         constant:70.f
                            ];
    [constraints addObject:self.tagButtonTopConstraint];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.tagsButton
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.f
                                                         constant:-27.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.tagsButton
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f
                                                         constant:40.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.tagsButton
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f
                                                         constant:40.f
                            ]];
    
    
    
    [self addConstraints:constraints];
}


-(void)setupTagConstraints{
    
    NSMutableArray* constraints = [[NSMutableArray alloc] init];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.designerTag
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.f
                                                         constant:100.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.categoryTag
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self.designerTag
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1.f
                                                         constant:0.f
                            ]];
    
    
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.designerTag
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f
                                                         constant:50.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.categoryTag
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f
                                                         constant:50.f
                            ]];
    
    
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_designerTag]-20-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_designerTag)
                                      ]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[_categoryTag]-20-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_categoryTag)
                                      ]];
    
    [self addConstraints:constraints];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.y < 0 && self.detailViewState == detailViewStateNormal) {
//      ^^  If state is 'normal', allow to be dragged down
        scrollView.frame = CGRectOffset(scrollView.frame, 0, -scrollView.contentOffset.y);
        scrollView.contentOffset = CGPointMake(0, 0);
    }else if (scrollView.contentOffset.y > 0 && self.detailViewState == detailViewStateTagsDisplayed) {
//      ^^  If state is 'displayed', allow scrollView to be moved up
        scrollView.frame = CGRectOffset(scrollView.frame, 0, -scrollView.contentOffset.y);
        scrollView.contentOffset = CGPointMake(0, 0);
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.frame.origin.y > 100 && self.detailViewState == detailViewStateNormal) {
        [self toggleItemTags];
    }else if(self.detailViewState == detailViewStateTagsDisplayed){
        [self toggleItemTags];
    }
}

-(void)setupDetailViewsAndConstraints{
    UIImageView* detailText = [[UIImageView alloc] initWithFrame:CGRectMake(30, 30, self.frame.size.width - 60, 16)];
    detailText.layer.cornerRadius = 8;
    [detailText setBackgroundColor:[UIColor colorWithWhite:.4f alpha:1.f]];
    [self.details addSubview:detailText];
    
    UIImageView* detailText2 = [[UIImageView alloc] initWithFrame:CGRectMake(50, 65, self.frame.size.width - 100, 16)];
    detailText2.layer.cornerRadius = 8;
    [detailText2 setBackgroundColor:[UIColor colorWithWhite:.4f alpha:1.f]];
    [self.details addSubview:detailText2];
}

-(void)toggleItemTags{
    
    if (self.detailViewState == detailViewStateNormal) {
        [self minimizeItem];
        [self showTags];
    }else{
        [self maximizeItem];
        [self hideTags];
    }
    
    [self.kFeedDetailViewDelegate toggleFocusWithState:self.detailViewState];
}

-(void)minimizeItem{
    self.detailViewState = detailViewStateTagsDisplayed;
    void(^ animations)(void) = ^{
        self.scrollViewTopConstraint.constant = self.frame.size.height - 300.f;
        self.detailsTopConstraint.constant = -150;
        self.tagsButton.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-45));
//        self.tagButtonTopConstraint.constant = 20.f;
        [self layoutIfNeeded];
    };
    [UIView animateWithDuration:.2f animations:animations];
    
//  Hack below
    [self bringSubviewToFront:self.categoryTag];
    [self bringSubviewToFront:self.designerTag];
}

-(void)maximizeItem{
    self.detailViewState = detailViewStateNormal;
    void(^ animations)(void) = ^{
        self.scrollViewTopConstraint.constant = imageDefaultTopPosition;
        self.detailsTopConstraint.constant = detailsDefaultTopPosition;
        self.tagsButton.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
//        self.tagButtonTopConstraint.constant = tagButtonDefaultTopPosition;
        [self layoutIfNeeded];
    };
    [UIView animateWithDuration:.2f animations:animations];
    
    
    //  Hack below
    [self sendSubviewToBack:self.categoryTag];
    [self sendSubviewToBack:self.designerTag];
}


-(void)showTags{
    [UIView animateWithDuration:.4
                          delay:.1
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.categoryTag.alpha = 1.f;
                         self.designerTag.alpha = 1.f;
                     } completion:nil];
}

-(void)hideTags{
    [UIView animateWithDuration:.4f animations:^{
        self.categoryTag.alpha = 0.f;
        self.designerTag.alpha = 0.f;
    }];
}

-(void)tappedTag:(UIGestureRecognizer*)gesture{
    UILabel* tappedLabel = (UILabel*)gesture.view;
    tappedLabel.text = @"Removed from Feed";
    tappedLabel.textColor = [UIColor redColor];
}

-(void)panImage:(UIPanGestureRecognizer *)gesture{
    CGPoint translatedPoint = [gesture translationInView:self];
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        self.firstX = [self.productImage center].x;
        self.firstY = [self.productImage center].y;
    }
    
    //Reset View center to match finger swiping
    translatedPoint = CGPointMake(self.firstX, self.firstY  + translatedPoint.y);
    [self.productImage setCenter:translatedPoint];
    
    if ([gesture state] == UIGestureRecognizerStateEnded) {
        CGPoint endingLocation = [gesture translationInView:self];
        CGFloat velocityX = (0.2*[gesture velocityInView:self].x);
        CGFloat animationDuration = (ABS(velocityX)*.0002)+.2;
        if (endingLocation.y >= 70) {
            [self minimizeItem];
        }else if(endingLocation.y <= -70 && self.detailViewState == detailViewStateTagsDisplayed){
            [self maximizeItem];
        }else{
            void (^animations)(void) = ^{
                [self.productImage setCenter:CGPointMake(self.firstX, self.firstY)];
            };
            [UIView animateWithDuration:animationDuration animations:animations completion:nil];
        }
    }
}



@end