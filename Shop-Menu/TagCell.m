//
//  TagCell.m
//  Shop-Menu
//
//  Created by james.dunay on 10/6/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "TagCell.h"

@interface TagCell()

@property(nonatomic, strong)UIImageView* expandButton;
@property(nonatomic, strong)UILabel* suggestedText;

@property(nonatomic, strong)UIButton* suggestionOne;
@property(nonatomic, strong)UIButton* suggestionTwo;
@property(nonatomic, strong)UIButton* suggestionThree;

@property(nonatomic, strong)UIButton* closeButton;

@end

@implementation TagCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.expandButton = [[UIImageView alloc] init];
        self.expandButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.expandButton.backgroundColor = [UIColor clearColor];
        self.expandButton.userInteractionEnabled = YES;
        [self addSubview:self.expandButton];
        
        self.suggestedText = [[UILabel alloc] init];
        self.suggestedText.text = @"Suggested Chanel ";
        self.suggestedText.textColor = [UIColor blackColor];
        self.suggestedText.translatesAutoresizingMaskIntoConstraints = NO;
        self.suggestedText.userInteractionEnabled = NO;
        self.suggestedText.alpha = 0;
        self.suggestedText.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.suggestedText];
        
        self.suggestionOne = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.suggestionOne setTitle:@"Chanel Tops" forState:UIControlStateNormal];
        self.suggestionOne.backgroundColor = [UIColor blueColor];
        self.suggestionOne.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        self.suggestionOne.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.suggestionOne addTarget:self action:@selector(tappedSuggestion:) forControlEvents:UIControlEventTouchUpInside];
        self.suggestionOne.translatesAutoresizingMaskIntoConstraints = NO;
        self.suggestionOne.alpha = 0.f;
        [self addSubview:self.suggestionOne];
        
        self.suggestionTwo = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.suggestionTwo setTitle:@"Chanel Bags" forState:UIControlStateNormal];
        self.suggestionTwo.backgroundColor = [UIColor blueColor];
        self.suggestionTwo.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        self.suggestionTwo.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.suggestionTwo addTarget:self action:@selector(tappedSuggestion:) forControlEvents:UIControlEventTouchUpInside];
        self.suggestionTwo.translatesAutoresizingMaskIntoConstraints = NO;
        self.suggestionTwo.alpha = 0.f;
        [self addSubview:self.suggestionTwo];
        
        self.suggestionThree = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.suggestionThree setTitle:@"Chanel Suits" forState:UIControlStateNormal];
        self.suggestionThree.backgroundColor = [UIColor blueColor];
        self.suggestionThree.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.suggestionThree.translatesAutoresizingMaskIntoConstraints = NO;
        self.suggestionThree.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        self.suggestionThree.alpha = 0.f;
        [self.suggestionThree addTarget:self action:@selector(tappedSuggestion:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.suggestionThree];

        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton.translatesAutoresizingMaskIntoConstraints = NO;
        self.closeButton.backgroundColor = [UIColor redColor];
        [self.closeButton addTarget:self action:@selector(closeTagCell) forControlEvents:UIControlEventTouchUpInside];
        self.closeButton.alpha = 0;
        [self addSubview:self.closeButton];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.isOpen = NO;
        
        [self setNeedsUpdateConstraints];
        [self setNeedsLayout];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)updateConstraints{
    [super updateConstraints];

    NSMutableArray* constraints = [[NSMutableArray alloc] init];
    
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.closeButton
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1.f
                                                         constant:-30.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.closeButton
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1.f
                                                         constant:40.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.closeButton
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f
                                                         constant:40.f
                            ]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:self.closeButton
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1.f
                                                         constant:40.f
                            ]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(<=30)-[_expandButton]-(<=30)-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_expandButton)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_expandButton]-15-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_expandButton)]];
    
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(<=30)-[_suggestedText]-(<=30)-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_suggestedText)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-30-[_suggestedText]-15-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_suggestedText)]];
    
    
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(<=30)-[_suggestionOne][_suggestionTwo(==_suggestionOne)][_suggestionThree(==_suggestionOne)]-(<=30)-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_suggestionOne, _suggestionTwo, _suggestionThree)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_suggestionOne]-15-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_suggestionOne)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_suggestionTwo]-15-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_suggestionTwo)]];
    
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[_suggestionThree]-15-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:NSDictionaryOfVariableBindings(_suggestionThree)]];
    
    [self addConstraints:constraints];
}

-(void)tappedSuggestion:(UIButton*)button{
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"Added To Feed" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

-(void)closeTagCell{
    [self.tagCellDelegate closeTagCell];
}

-(void)openCell{
    self.isOpen = YES;
    [UIView animateWithDuration:.2
                          delay:.2
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
        self.suggestedText.alpha = 1.f;}
                     completion:nil
     ];
}

-(void)cellExpanded{
    self.closeButton.alpha = self.closeButton.alpha ? 0 : 1;
    self.suggestionOne.alpha = self.suggestionOne.alpha ? 0 : 1;
    self.suggestionTwo.alpha = self.suggestionTwo.alpha ? 0 : 1;
    self.suggestionThree.alpha = self.suggestionThree.alpha ? 0 : 1;
}

@end