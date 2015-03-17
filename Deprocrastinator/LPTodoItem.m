//
//  LPTodoItem.m
//  Deprocrastinator
//
//  Created by Leandro Pessini on 3/16/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "LPTodoItem.h"

@implementation LPTodoItem

-(void)deleteItem
{
    self.itemName = nil;
    self.completed = nil;
    self.priority = nil;
}


@end
