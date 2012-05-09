//
//  ILTodo.m
//  Todo
//
//  Created by jeremy Templier on 08/05/12.
//  Copyright (c) 2012 particulier. All rights reserved.
//

#import "ILTodo.h"

@implementation ILTodo
@synthesize name = _name;

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName 
                   error:(NSError **)outError
{
    
    if ([contents length] > 0) {
        self.name = [[NSString alloc] 
                            initWithBytes:[contents bytes] 
                            length:[contents length] 
                            encoding:NSUTF8StringEncoding];        
    } else {
        self.name = @"No name"; 
    }
    
    return YES;    
}

- (id)contentsForType:(NSString *)typeName error:(NSError **)outError 
{
    
    if ([self.name length] == 0) {
        self.name = @"No Name";
    }
    
    return [NSData dataWithBytes:[self.name UTF8String] 
                          length:[self.name length]];
    
}

@end
