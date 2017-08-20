//
//  UIBlockButton.m
//  EcoHub
//
//  Created by Dario Lencina on 2/25/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import "UIBlockButton.h"

@implementation UIBlockButton

-(void)awakeFromNib{
    self.backgroundColor=[UIColor blackColor];
}

-(void) handleControlEvent:(UIControlEvents)event
                 withBlock:(UIBlockButtonHandler) handler
{
    self.handler=handler;
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

-(void) callActionBlock:(id)sender{
    if(self.handler){
        self.handler(self);
    }
}

-(void)dealloc{
    self.handler=nil;
}

@end
