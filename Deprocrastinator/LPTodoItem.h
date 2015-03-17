//
//  LPTodoItem.h
//  Deprocrastinator
//
//  Created by Leandro Pessini on 3/16/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPTodoItem : NSObject

@property NSString *itemName;
@property BOOL completed;
@property NSNumber *priority;

-(void)deleteItem;

@end
