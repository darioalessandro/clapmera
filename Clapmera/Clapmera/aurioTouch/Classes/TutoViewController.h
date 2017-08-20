//
//  TutoViewController.h
//  Clapmera
//
//  Created by Dario on 19/05/12.
//  Copyright (c) 2012 BlackFireApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClapmeraViewController.h"

@interface TutoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleStep1Label;
@property (weak, nonatomic) IBOutlet UILabel *titleStep2Label;
@property (weak, nonatomic) IBOutlet UILabel *titleStep3Label;
@property (weak, nonatomic) IBOutlet UIImageView *imageStep1ImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionStep1Label;
@property (weak, nonatomic) IBOutlet UILabel *description2Step2Label;
@property (weak, nonatomic) IBOutlet UILabel *descriptionStep3Label;
@property (weak, nonatomic) IBOutlet UIButton *leftArrowButton;
@property (weak, nonatomic) IBOutlet UIButton *rightArrowButton;
@property (weak, nonatomic) IBOutlet UIView *step1BaseView;
@property (weak, nonatomic) IBOutlet UIView *step2BaseView;
@property (weak, nonatomic) IBOutlet UIView *step3BaseView;
@property (weak, nonatomic) IBOutlet UIButton *goAheadButton;
@property (weak, nonatomic) ClapmeraViewController * clapmeraViewController;


- (IBAction)onLeftArrowClick:(id)sender;

- (IBAction)onRightArrowClick:(id)sender;

- (IBAction)onGoAheadClick:(id)sender;

@end
