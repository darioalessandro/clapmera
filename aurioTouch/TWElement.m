//
//  TWElement.m
//  Graphic tweets
//
//  Created by Dario Lencina on 9/29/12.
//  Copyright (c) 2012 Dario Lencina. All rights reserved.
//

#import "TWElement.h"

@implementation TWElement

+(TWElement *)elementWithType:(TWElementType)type text:(NSString *)text range:(NSRange)range index:(NSInteger)index{
    if(!text || !type)
        return nil;
    
    TWElement * element= [TWElement new];
    element.elementType=type;
    element.text=text;
    element.range=range;
    element.index=index;
    return element;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"type: %d text: %@ index: %ld range: %@",self.elementType, self.text, (long)self.index, NSStringFromRange(self.range)];
}

@end
