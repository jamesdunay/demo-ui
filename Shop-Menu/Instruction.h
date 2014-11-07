//
//  Instruction.h
//  Shop-Menu
//
//  Created by james.dunay on 11/6/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImageView+Gestures.h"

@interface Instruction : NSObject

@property(nonatomic, strong)NSString* text;
@property(nonatomic)Gesture gesture;

-(id)initWithDict:(NSDictionary*)dict;

@end