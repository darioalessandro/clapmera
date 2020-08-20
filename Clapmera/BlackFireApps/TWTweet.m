//
//  NSString+TweeterExtensions.m
//  Graphic tweets
//
//  Created by Dario Lencina on 5/19/12.
//  Copyright (c) 2012 Dario Lencina. All rights reserved.
//

#import "TWTweet.h"
#import "TWElement.h"

@interface  TWTweet (Private)

-(void)sortElements;
-(NSArray *)hashTagsRanges;
-(NSArray *)mentionsRanges;

@end

@implementation TWTweet

+(TWTweet *)tweetFromText:(NSString *)text{
    if(text==nil || [text isEqualToString:@""])
        return nil;
    
    TWTweet * tweet= [TWTweet new];
    [tweet setText:text];
    [tweet sortElements];
    return tweet;
}

-(BOOL)containsHashTags{
    NSArray * hashTags= [self.elements filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        TWElement * element= (TWElement *)evaluatedObject;
        return element.elementType==TWElementTypeHashtag;
    }]];
    return [hashTags count]>0;
}

-(NSArray *)hashTagsRanges{
    return [self resultsForRegex:@"\\b#\\S*"];
}

-(NSArray *)mentionsRanges{
    return [self resultsForRegex:@"\\b@\\S*"];
}

-(NSArray *)resultsForRegex:(NSString *)regexStr{
    NSError * error= nil;
    NSRegularExpression * regex= [NSRegularExpression regularExpressionWithPattern:regexStr
                                                                           options:NSRegularExpressionCaseInsensitive | NSRegularExpressionUseUnicodeWordBoundaries
                                                                             error:&error];
    NSMutableArray * hashTags= [NSMutableArray array];
    if(error)
        BFLog(@"error %@", [error localizedDescription]);
    
    NSArray * matches= [regex matchesInString:self.text
                                      options:0
                                        range:NSMakeRange(0, [self.text length])];
    
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match range];
        [hashTags addObject:[NSValue valueWithRange:matchRange]];
    }
    
    return hashTags;
}

NSInteger arraySorterBasedOnRangeOfElements(TWElement *val1, TWElement *val2, void * context)
{
    NSRange range1 = [val1 range];
    NSRange range2 = [val2 range];
    if(range1.location == range2.location)
        return NSOrderedSame;
    if(range1.location < range2.location)
        return NSOrderedAscending;
    if(range1.location > range2.location)
        return NSOrderedDescending;
    assert(!"Impossible");
}

-(void)sortElements{
    NSArray * hashTagsRanges= [self hashTagsRanges];
    NSMutableArray * dirtyArray= [NSMutableArray array];
    for(NSValue * rangeAsValue in hashTagsRanges){
        TWElement * element= [TWElement new];
        [element setRange:[rangeAsValue rangeValue]];
        [element setElementType:TWElementTypeHashtag];
        [element setText:[self.text substringWithRange:[rangeAsValue rangeValue]]];
        [dirtyArray addObject:element];
    }

    [dirtyArray sortUsingFunction:arraySorterBasedOnRangeOfElements context:NULL];
    
    NSScanner * scanner= [NSScanner scannerWithString:self.text];
    int i=0;
    NSMutableArray * _plainTextFragments= [NSMutableArray array];
    while (!scanner.isAtEnd && i<dirtyArray.count){
        NSString * textFragment=nil;
        NSString * elemento= [dirtyArray[i] text];
        NSInteger initialLocation= [scanner scanLocation];
        [scanner scanUpToString:elemento intoString:&textFragment];
        NSInteger index= 0;
        if(textFragment!=nil){
            TWElement * txtElement= [TWElement new];
            [txtElement setElementType:TWElementTypePlainText];
            NSRange range= {initialLocation, textFragment.length};
            [txtElement setRange:range];
            [txtElement setText:textFragment];
            [_plainTextFragments addObject:txtElement];
            index= [scanner scanLocation]+elemento.length;
        }else{
            index= [scanner scanLocation]+elemento.length+1;
        }
        if(index<= self.text.length){
            [scanner setScanLocation:index];
        }else{
            [scanner setScanLocation:self.text.length];
        }

        i++;
        //last chunk
        if(i==dirtyArray.count){
            if(!scanner.isAtEnd){
                TWElement * txtElement= [TWElement new];
                [txtElement setElementType:TWElementTypePlainText];
                NSRange range= {scanner.scanLocation, self.text.length - scanner.scanLocation};
                [txtElement setRange:range];
                [txtElement setText:[self.text substringFromIndex:scanner.scanLocation]];
                [_plainTextFragments addObject:txtElement];
            }
        }
    }
    
    [dirtyArray addObjectsFromArray:_plainTextFragments];
    [dirtyArray sortUsingFunction:arraySorterBasedOnRangeOfElements context:NULL];
    
    for(NSInteger i=0;i<dirtyArray.count;i++){
        [dirtyArray[i] setIndex:i];
    }
    
    self.elements=dirtyArray;
}

@end