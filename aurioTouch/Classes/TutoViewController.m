//
//  TutoViewController.m
//  Clapmera
//
//  Created by Dario on 19/05/12.
//  Copyright (c) 2012 BlackFireApps. All rights reserved.
//

#import "TutoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CMAppDelegate.h"
#import "CMConfigurationsViewController.h"
#import "ClapmeraViewController.h"

#define FONT_NOTEWORTHY_LIGHT @"Helvetica-Light"
#define FONT_NOTEWORTHY_BOLD @"Helvetica-Bold"
#define FONT_NANUM_GOTHIC @"Helvetica-Light"

@interface TutoViewController ()
@end

@implementation TutoViewController

@synthesize titleStep1Label;
@synthesize titleStep2Label;
@synthesize titleStep3Label;
@synthesize imageStep1ImageView;
@synthesize descriptionStep1Label;
@synthesize description2Step2Label;
@synthesize descriptionStep3Label;
@synthesize leftArrowButton;
@synthesize rightArrowButton;
@synthesize step1BaseView;
@synthesize step2BaseView;
@synthesize step3BaseView;
@synthesize goAheadButton;

int stepNumber;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self = [super initWithNibName:@"TutoViewController_iPhone" bundle:nibBundleOrNil];
    } else {
        self = [super initWithNibName:@"TutoViewController_iPad" bundle:nibBundleOrNil];
    }    

    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    //setup the initial state
    
    CGFloat titleSize = 36;
    CGFloat labelSize = 13;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        titleSize = 39;
        labelSize = 15;
    }
    
    self.titleStep1Label.font = [UIFont fontWithName:FONT_NOTEWORTHY_LIGHT size:titleSize];
    self.titleStep2Label.font = [UIFont fontWithName:FONT_NOTEWORTHY_LIGHT size:titleSize];
    self.titleStep3Label.font = [UIFont fontWithName:FONT_NOTEWORTHY_LIGHT size:titleSize];
    
    self.descriptionStep1Label.font = [UIFont fontWithName:FONT_NANUM_GOTHIC size:labelSize];
    self.description2Step2Label.font = [UIFont fontWithName:FONT_NANUM_GOTHIC size:labelSize];
    self.descriptionStep3Label.font = [UIFont fontWithName:FONT_NANUM_GOTHIC size:labelSize];
    
    self.titleStep1Label.text = NSLocalizedString(@"tuto_title_step1", nil);
    self.titleStep2Label.text = NSLocalizedString(@"tuto_title_step2", nil);
    self.titleStep3Label.text = NSLocalizedString(@"tuto_title_step3", nil);
    
    self.descriptionStep1Label.text = NSLocalizedString(@"tuto_description_step1", nil);
    self.description2Step2Label.text = NSLocalizedString(@"tuto_description2_step2", nil);
    self.descriptionStep3Label.text = NSLocalizedString(@"tuto_description_step3", nil);
    
    NSString *buttonLabelString = NSLocalizedString(@"tuto_go ahead!", nil);
    [self.goAheadButton setTitle:buttonLabelString forState:UIControlStateNormal];  
    [self.goAheadButton setTitle:buttonLabelString forState:UIControlStateHighlighted];  
    [self.goAheadButton setTitle:buttonLabelString forState:UIControlStateDisabled];
    [self.goAheadButton setTitle:buttonLabelString forState:UIControlStateSelected]; 
    
    stepNumber = 0;
    self.goAheadButton.alpha = 0;
    self.leftArrowButton.alpha = 0;
    self.rightArrowButton.alpha = 1;
    [self animateWithBounceIntroNextView:self.step1BaseView completion:nil];    
}

- (void)onLeftArrowClick:(id)sender{
    stepNumber--;
    if (stepNumber < 0){
        stepNumber = 0;
    }
    
    switch (stepNumber) {
        case 0:
            self.goAheadButton.alpha = 0;
            self.leftArrowButton.alpha = 0;
            self.rightArrowButton.alpha = 1;      
            
            [self step2IntroBack];
            break;
            
        case 1:
            self.goAheadButton.alpha = 0;
            self.leftArrowButton.alpha = 1;
            self.rightArrowButton.alpha = 1;
            
            [self step3IntroBack];
            break;
    }
}

- (void)onRightArrowClick:(id)sender{
    stepNumber++;
    if (stepNumber > 2){
        stepNumber = 2;
    }
    
    switch (stepNumber) {
        case 1:
            self.goAheadButton.alpha = 0;
            self.leftArrowButton.alpha = 1;
            self.rightArrowButton.alpha = 1;
            
            [self step2IntroNext];
            break;            
        case 2:
            self.goAheadButton.alpha = 1;
            self.leftArrowButton.alpha = 1;            
            self.rightArrowButton.alpha = 0;
            
            [self step3IntroNext];
            break;
    }
}

- (void)onGoAheadClick:(id)sender{
    [self showCamera];
}

-(void)showCamera{
    [self dismissViewControllerAnimated:NO completion:^{
        [self.clapmeraViewController resumeClapmeraEngine];
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.clapmeraViewController showSettings:nil];
        });
    }];
}

- (void)step2IntroNext{
    [self animateExitNextView:self.step1BaseView completion:^(BOOL finished) {
        self.step2BaseView.transform = CGAffineTransformMakeScale(2.0, 2.0);
        self.step2BaseView.alpha = 1;
        self.step1BaseView.alpha = 0;        
        [self animateWithBounceIntroNextView:self.step2BaseView completion:nil];
    }];
}

- (void)step3IntroNext{
    [self animateExitNextView:self.step2BaseView completion:^(BOOL finished) {
        self.step3BaseView.transform = CGAffineTransformMakeScale(2.0, 2.0);
        self.step3BaseView.alpha = 1;
        self.step2BaseView.alpha = 0;
        [self animateWithBounceIntroNextView:self.step3BaseView completion:nil];
    }];
}

- (void)step2IntroBack{
    [self animateExitBackView:self.step2BaseView completion:^(BOOL finished) {
        self.step1BaseView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        self.step1BaseView.alpha = 1;
        self.step2BaseView.alpha = 0;
        [self animateWithBounceIntroBackView:self.step1BaseView completion:nil];
    }];
}

- (void)step3IntroBack{
    [self animateExitBackView:self.step3BaseView completion:^(BOOL finished) {
        self.step2BaseView.transform = CGAffineTransformMakeScale(0.3, 0.3);
        self.step2BaseView.alpha = 1;
        self.step3BaseView.alpha = 0;
        [self animateWithBounceIntroBackView:self.step2BaseView completion:nil];
    }];
}

- (void)animateWithBounceIntroNextView: (UIView *)view completion:(void (^)(BOOL finished))completion{
    view.transform = CGAffineTransformMakeScale(2.0, 2.0);
    view.alpha=0;
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut 
                     animations:^{
                         view.transform = CGAffineTransformMakeScale(0.9, 0.9);
                         view.alpha=1;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.3
                                               delay:0 
                                             options:UIViewAnimationOptionCurveEaseInOut 
                                          animations:^{
                                              view.transform = CGAffineTransformMakeScale(1.05, 1.05);
                                          } completion:^(BOOL finished) {
                                              [UIView animateWithDuration:0.3
                                                                    delay:0 
                                                                  options:UIViewAnimationOptionCurveEaseInOut 
                                                               animations:^{
                                                                   view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                                               } completion:completion];
                                          }];
                     }];
}

- (void)animateExitNextView: (UIView *)view completion:(void (^)(BOOL finished))completion{
    view.transform = CGAffineTransformMakeScale(1.0, 1.0);    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut 
                     animations:^{
                         view.transform = CGAffineTransformMakeScale(1.1, 1.1);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                               delay:0 
                                             options:UIViewAnimationOptionCurveEaseInOut 
                                          animations:^{
                                              view.alpha=0.0;
                                              view.transform = CGAffineTransformMakeScale(0.3, 0.3);
                                          } completion: completion];
                     }];
}

- (void)animateWithBounceIntroBackView: (UIView *)view completion:(void (^)(BOOL finished))completion{
    view.transform = CGAffineTransformMakeScale(0.3, 0.3);
    view.alpha=0.0;
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut 
                     animations:^{
                         view.transform = CGAffineTransformMakeScale(1.1, 1.1);
                             view.alpha=1.0;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.3
                                               delay:0 
                                             options:UIViewAnimationOptionCurveEaseInOut 
                                          animations:^{
                                              view.transform = CGAffineTransformMakeScale(0.95, 0.95);
                                          } completion:^(BOOL finished) {
                                              [UIView animateWithDuration:0.3
                                                                    delay:0 
                                                                  options:UIViewAnimationOptionCurveEaseInOut 
                                                               animations:^{
                                                                   view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                                               } completion:completion];
                                          }];
                     }];
}

- (void)animateExitBackView: (UIView *)view completion:(void (^)(BOOL finished))completion{
    view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    view.alpha=1.0;
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut 
                     animations:^{
                         view.transform = CGAffineTransformMakeScale(0.9, 0.9);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.3
                                               delay:0 
                                             options:UIViewAnimationOptionCurveEaseInOut 
                                          animations:^{
                                              view.alpha=0.0;
                                              view.transform = CGAffineTransformMakeScale(2.0, 2.0);
                                          } completion:completion];
                     }];
}

- (void)viewDidUnload{
    [self setTitleStep1Label:nil];
    [self setImageStep1ImageView:nil];
    [self setDescriptionStep1Label:nil];
    [self setLeftArrowButton:nil];
    [self setRightArrowButton:nil];
    [self setStep1BaseView:nil];
    [self setTitleStep2Label:nil];
    [self setDescription2Step2Label:nil];
    [self setStep2BaseView:nil];
    [self setTitleStep3Label:nil];
    [self setDescriptionStep3Label:nil];
    [self setStep3BaseView:nil];
    [self setGoAheadButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

@end
