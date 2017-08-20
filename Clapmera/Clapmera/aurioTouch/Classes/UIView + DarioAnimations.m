/*Copyright (C) <2011> <Dario Alessandro Lencina Talarico>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 of the Software, and to permit persons to whom the Software is furnished to do
 so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.*/

#import "UIView + DarioAnimations.h"
//#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>


@implementation UIView  (DarioAnimations) 

#define wobblelenghtX 10
#define kduraciondedesplazamiento 0.1
#define knumeroDeRepeticiones 3
#define kTipoDeCurvaDeAnimacion UIViewAnimationCurveLinear

-(void)animarRechazo:(UIView *)view{
//	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	[self rechazoLogin1:view];	
}

-(void)escalarYContraer:(UIView *)view{
//	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	[self expandir:view];
}

-(void)expandir:(UIView *)view{
	CGAffineTransform escalar= CGAffineTransformMakeScale( 1.1, 1.1);
	[UIView beginAnimations:@"expandir" context:view];
	[UIView setAnimationDuration:0.15];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidDidStop:finished:context:)];
//	view.layer.borderColor = [UIColor redColor].CGColor;
//	view.layer.borderWidth = 2;	
    [view setAlpha:1.0];
	[view setTransform:escalar]; 
	[UIView commitAnimations];
}

-(void)contraer:(UIView *)view{
	CGAffineTransform leftWobble = CGAffineTransformMakeTranslation(0,0);
	CGAffineTransform escalar= CGAffineTransformScale(leftWobble, 1, 1);
	[UIView beginAnimations:@"contraer" context:view];
	[UIView setAnimationDuration:0.15];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidDidStop:finished:context:)];
//	view.layer.borderColor = [UIColor clearColor].CGColor;
//	view.layer.borderWidth = 2;
	[view setTransform:escalar]; 
	[UIView commitAnimations];
}

-(void)rechazoLogin1:(UIView *)view{
	CGAffineTransform leftWobble = CGAffineTransformMakeTranslation(-wobblelenghtX, 0);
	[UIView beginAnimations:@"rechazoLogin1" context:view];
	[UIView setAnimationDuration:kduraciondedesplazamiento];
	[UIView setAnimationCurve:kTipoDeCurvaDeAnimacion];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidDidStop:finished:context:)];
	[view setTransform:leftWobble]; 
	[UIView commitAnimations];
	
}


-(void)rechazoLogin2:(UIView *)view{
	CGAffineTransform leftWobble = CGAffineTransformMakeTranslation(-wobblelenghtX, 0);
	CGAffineTransform rightWobble = CGAffineTransformMakeTranslation(wobblelenghtX, 0);
	
	[view setTransform:leftWobble];
	[UIView beginAnimations:@"rechazoLogin2" context:view];
	[UIView setAnimationRepeatAutoreverses:YES];
	[UIView setAnimationRepeatCount:knumeroDeRepeticiones];
	[UIView setAnimationDuration:kduraciondedesplazamiento];
	[UIView setAnimationCurve:kTipoDeCurvaDeAnimacion];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidDidStop:finished:context:)];
	[view setTransform:rightWobble]; 
	[UIView commitAnimations];
}

-(void)rechazoLogin3:(UIView *)view{
	CGAffineTransform center = CGAffineTransformIdentity;
	CGAffineTransform leftWobble = CGAffineTransformMakeTranslation(-wobblelenghtX, 0);
	// starting point
	[view setTransform:leftWobble];
	[UIView beginAnimations:@"rechazoLogin3" context:view];
	[UIView setAnimationCurve:kTipoDeCurvaDeAnimacion];
	[UIView setAnimationDuration:kduraciondedesplazamiento];
	[view setTransform:center]; // end here & auto-reverse
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];
	
}


- (void)animationDidDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	if([animationID isEqualToString:@"rechazoLogin1"])
		[self rechazoLogin2:context];
	
	if([animationID isEqualToString:@"rechazoLogin2"])
		[self rechazoLogin3:context];
	
	if([animationID isEqualToString:@"expandir"])
		[self contraer:context];
}
	

@end
