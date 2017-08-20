//
//  TWElement.h
//  Graphic tweets
//
//  Created by Dario Lencina on 9/29/12.
//  Copyright (c) 2012 Dario Lencina. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum TWElementType {
    TWElementTypeHashtag=0,
    TWElementTypePlainText
} TWElementType;

@interface TWElement : NSObject

@property(nonatomic) NSRange range;
@property(nonatomic, strong) NSString * text;
@property(nonatomic) TWElementType elementType;
@property(nonatomic) NSInteger index;
+(TWElement *)elementWithType:(TWElementType)type text:(NSString *)text range:(NSRange)range index:(NSInteger)index;
@end
