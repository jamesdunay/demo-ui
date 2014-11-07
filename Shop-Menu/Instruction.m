//
//  Instruction.m
//  Shop-Menu
//
//  Created by james.dunay on 11/6/14.
//  Copyright (c) 2014 James.Dunay. All rights reserved.
//

#import "Instruction.h"

@implementation Instruction

-(id)initWithDict:(NSDictionary*)dict{
    self = [super init];
    if (self) {
        self.text = dict[@"text"];
        self.gesture = [dict[@"gesture"] intValue];
    }
    return self;
}

@end
