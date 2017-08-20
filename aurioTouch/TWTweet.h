//
//  NSString+TweeterExtensions.h
//  Graphic tweets
//
//  Created by Dario Lencina on 5/19/12.
//  Copyright (c) 2012 Dario Lencina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWTweet : NSObject

-(NSArray *)hashTagsRanges;
+(TWTweet *)tweetFromText:(NSString *)text;
-(BOOL)containsHashTags;

@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSArray * elements;

@end

