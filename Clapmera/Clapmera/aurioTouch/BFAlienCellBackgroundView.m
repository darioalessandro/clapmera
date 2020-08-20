/* ====================================================================
 * Copyright (c) 2012 Dario Alessandro Lencina Talarico.  All rights
 * reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * 3. The end-user documentation included with the redistribution,
 *    if any, must include the following acknowledgment:
 *    "This product includes software developed by
 *    Dario Alessandro Lencina Talarico: darioalessandrolencina@gmail.com"
 *
 *    Alternately, this acknowledgment SHOULD in the software itself,
 *    usually where such third-party acknowledgments normally appear,
 *
 *
 * 5. Products derived from this software may not be called "Designed by Dario",
 *    nor may "Designed by Dario" appear in their name, without prior written
 *    permission of the Apache Software Foundation.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL DARIO ALESSANDRO LENCINA TALARICO OR
 * ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 *
 */


#import "BFAlienCellBackgroundView.h"
#define ROUND_SIZE 10
static NSMutableDictionary * _cachedRenders;

@implementation BFAlienCellBackgroundView

@synthesize borderColor, fillColor;

#pragma mark -
#pragma mark initialization

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(!_cachedRenders){
        _cachedRenders=[NSMutableDictionary new];
    }
    return self;
}

-(BOOL)isOpaque {
    return NO;
}

-(BOOL)clearsContextBeforeDrawing{
    return NO;
}

#pragma mark -
#pragma mark CoreGraphics Image Drawing.

-(void)CreateAlienGradient:(CGGradientRef *)gradient{
    size_t num_locations = 3;
    CGFloat locations[4] = { 0.0, 0.85, 1.0 };
    CGFloat components[16] = {
                              0.7,	0.7, 0.7, 1,
                              0.95,	0.95, 0.95, 1,
                              1.00, 1.00, 1.00, 1}; // End color
    
    CGColorSpaceRef rgbColorspace = CGColorSpaceCreateDeviceRGB();
    *gradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    CGColorSpaceRelease(rgbColorspace);
}

-(NSString *)keyForRect:(CGRect)rect andPosition:(BFAlienCellBackgroundViewPosition)viewPosition{
    return [NSString stringWithFormat:@"%@ %ld", NSStringFromCGRect(rect), (long)viewPosition];
}

-(void)setPosition:(BFAlienCellBackgroundViewPosition)newPosition{
    if(_position!=newPosition){
        _position=newPosition;
        [self setNeedsDisplay];
    }
}

-(void)drawOuterCanvasInRect:(CGRect)rect withTopPositionInContext:(CGContextRef)ctx {
    CGFloat minx = CGRectGetMinX(rect) , midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
    CGFloat miny = CGRectGetMinY(rect) , maxy = CGRectGetMaxY(rect) ;
    minx = minx + 1;
    miny = miny + 1;
    
    maxx = maxx - 1;
    maxy = maxy ;
    
    CGContextMoveToPoint(ctx, minx, maxy);
    CGContextAddArcToPoint(ctx, minx, miny, midx, miny, ROUND_SIZE);
    CGContextAddArcToPoint(ctx, maxx, miny, maxx, maxy, ROUND_SIZE);
    CGContextAddLineToPoint(ctx, maxx, maxy);
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

-(void)drawOuterCanvasInRect:(CGRect)rect withMiddlePositionInContext:(CGContextRef)ctx {
    CGFloat minx = CGRectGetMinX(rect) , maxx = CGRectGetMaxX(rect) ;
    CGFloat miny = CGRectGetMinY(rect) , maxy = CGRectGetMaxY(rect) ;
    minx = minx + 1;
    miny = miny ;
    
    maxx = maxx - 1;
    maxy = maxy ;
    
    CGContextMoveToPoint(ctx, minx, miny);
    CGContextAddLineToPoint(ctx, maxx, miny);
    CGContextAddLineToPoint(ctx, maxx, maxy);
    CGContextAddLineToPoint(ctx, minx, maxy);
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

#define UIGray [UIColor colorWithRed:0.61 green:0.61 blue:0.61 alpha:0.8]

-(void)drawOuterCanvasInRect:(CGRect)rect withBottomPositionInContext:(CGContextRef)ctx {
    CGFloat minx = CGRectGetMinX(rect) , midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
    CGFloat miny = CGRectGetMinY(rect) , maxy = CGRectGetMaxY(rect) ;
    minx = minx + 1;
    miny = miny ;
    
    maxx = maxx - 1;
    maxy = maxy - 1;
    CGContextMoveToPoint(ctx, minx, miny);
    CGContextAddArcToPoint(ctx, minx, maxy, midx, maxy, ROUND_SIZE);
    CGContextAddArcToPoint(ctx, maxx, maxy, maxx, miny, ROUND_SIZE);
    CGContextAddLineToPoint(ctx, maxx, miny);
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

-(void)drawOuterCanvasInRect:(CGRect)rect withSinglePositionInContext:(CGContextRef)ctx {
    CGFloat minx = CGRectGetMinX(rect) , midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
    CGFloat miny = CGRectGetMinY(rect) , maxy = CGRectGetMaxY(rect) ;
    CGFloat midy = CGRectGetMidY(rect);
    
    CGContextMoveToPoint(ctx, minx, midy);
    CGContextAddArcToPoint(ctx, minx, miny, midx, miny, ROUND_SIZE);
    CGContextAddArcToPoint(ctx, maxx, miny, maxx, midy, ROUND_SIZE);
    CGContextAddArcToPoint(ctx, maxx, maxy, midx, maxy, ROUND_SIZE);
    CGContextAddArcToPoint(ctx, minx, maxy, minx, midy, ROUND_SIZE);
    CGContextClosePath(ctx);
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

-(void)drawInnerRowAndShadowInRect:(CGRect)rect inContext:(CGContextRef)ctx{
    
    CGFloat minx = CGRectGetMinX(rect) , midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
    CGFloat miny = CGRectGetMinY(rect) , maxy = CGRectGetMaxY(rect) ;
    CGFloat midy = CGRectGetMidY(rect);
    
    minx=minx+10;
    miny=miny+10;
    midx=midx-10;
    maxx=maxx-10;
    maxy=maxy-10;
    
    CGContextMoveToPoint(ctx, minx, midy);
    CGContextAddArcToPoint(ctx, minx, miny, midx, miny, ROUND_SIZE);
    CGContextAddArcToPoint(ctx, maxx, miny, maxx, midy, ROUND_SIZE);
    CGContextAddArcToPoint(ctx, maxx, maxy, midx, maxy, ROUND_SIZE);
    CGContextAddArcToPoint(ctx, minx, maxy, minx, midy, ROUND_SIZE);
    CGContextClosePath(ctx);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextSetShadow(ctx, CGSizeMake(0,-4), 6);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    CGContextMoveToPoint(ctx, minx, midy);
    CGContextAddArcToPoint(ctx, minx, miny, midx, miny, ROUND_SIZE);
    CGContextAddArcToPoint(ctx, maxx, miny, maxx, midy, ROUND_SIZE);
    CGContextAddArcToPoint(ctx, maxx, maxy, midx, maxy, ROUND_SIZE);
    CGContextAddArcToPoint(ctx, minx, maxy, minx, midy, ROUND_SIZE);
    CGContextClosePath(ctx);
    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx, alienGradient, CGPointMake(midx, maxy), CGPointMake(midx, 0), kCGGradientDrawsAfterEndLocation);
    
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

-(void)configureContext:(CGContextRef)ctx withRect:(CGRect)rect{
    CGAffineTransform flipVertical = CGAffineTransformMake(
                                                           1, 0, 0, -1, 0, rect.size.height
                                                           );
    CGContextConcatCTM(ctx, flipVertical);
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1] CGColor]);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor clearColor] CGColor]);
}

-(CGImageRef)backgroundImageForRect:(CGRect)rect andPosition:(BFAlienCellBackgroundViewPosition)viewPosition{
    NSString * key=[self keyForRect:rect andPosition:viewPosition];
    UIImage * cachedRender=[_cachedRenders objectForKey:key];
    if(!cachedRender){
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale) ;
        CGContextRef c = UIGraphicsGetCurrentContext();
        [self configureContext:c withRect:rect];
        if(alienGradient==NULL)
            [self CreateAlienGradient:&alienGradient];
        
        CGContextSetLineWidth(c,1.0f);
        CGContextSetStrokeColorWithColor(c, UIGray.CGColor);
        
        if (viewPosition == BFAlienCellBackgroundViewPositionTop) {
            [self drawOuterCanvasInRect:rect withTopPositionInContext:c];
        } else if (viewPosition == BFAlienCellBackgroundViewPositionBottom) {
            [self drawOuterCanvasInRect:rect withBottomPositionInContext:c];
        } else if (viewPosition == BFAlienCellBackgroundViewPositionMiddle) {
            [self drawOuterCanvasInRect:rect withMiddlePositionInContext:c];
        }else if(viewPosition==BFAlienCellBackgroundViewPositionSingle){
            [self drawOuterCanvasInRect:rect withSinglePositionInContext:c];
        }
        [self drawInnerRowAndShadowInRect:rect inContext:c];
        cachedRender= UIGraphicsGetImageFromCurrentImageContext();
        [_cachedRenders setObject:cachedRender forKey:key];
        UIGraphicsEndImageContext();
    }
    return [cachedRender CGImage];
}

#pragma mark -
#pragma mark CoreGraphicsViewDrawing

- (void)drawRect:(CGRect)rect {
    CGImageRef img=[self backgroundImageForRect:rect andPosition:_position];
    CGContextRef viewContext = UIGraphicsGetCurrentContext();
    CGContextDrawImage(viewContext, rect, img);
}


@end
