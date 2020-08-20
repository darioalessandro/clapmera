//
//  CMConfigurationsViewController.m
//  Clapmera
//
//  Created by Dario on 13/04/12.
//  Copyright (c) 2012 BlackFireApps. All rights reserved.
//

#import "CMConfigurationsViewController.h"
#import "UIViewController + Analytics.h"
#import <QuartzCore/QuartzCore.h>
#import "InAppPurchasesManager.h"
#import "ClapmeraViewController.h"
#import "AcknowledgmentsViewController.h"

#define kiAdsFeatureInstalled NSLocalizedString(@"iAds Removed.",nil);
#import "SharedConstants.h"
#import "CPNotifications.h"
#import "CPTheme.h"
#import "AKSegmentedControl.h"
#import "NewFeaturesController.h"


@interface CMConfigurationsViewController ()

@end

@implementation CMConfigurationsViewController {
    FPPopoverController * controller;
}

#pragma mark -
#pragma mark View Lifecycle

-(void)viewDidLoad{
    [super viewDidLoad];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                     target:self                                                                                      action:@selector(showCamera)];
        leftButtonItem.style = UIBarButtonItemStyleDone;
        self.navigationItem.leftBarButtonItem = leftButtonItem;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSensitivitySlider:)  name:CPConfigurationSensitivityChanged object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData:)  name:AppDidBecomeActive object:nil];
    self.tableViewCells=@[@[self.modeCell],@[self.delayTableViewCell], @[self.likeCell, self.twitterCell, self.youTubeCell, self.rateApp], @[self.aboutCell ,self.acknowledgments, self.version]];
    self.title=NSLocalizedString(@"Settings", nil);
    [self setupModeCell];
}

-(void)viewDidUnload{
    [self setDelaySlider:nil];
    [self setSensibilitySlider:nil];
    [self setDelayLabel:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self GATrackPage];
    [self setupValuesForSliders];
    [self updateDelayLabel];
    [[self tableView] reloadData];
    
    if([CPConfiguration shouldShowNewFeaturesScreen]==YES){
         [CPConfiguration didShowNewFeaturesScreen];
        double delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NewFeaturesController * newFeatures=[[NewFeaturesController alloc] initWithNibName:nil bundle:nil];
            controller= [[FPPopoverController alloc] initWithViewController: newFeatures delegate:self];
            [controller setContentSize:CGSizeMake(300, 180)];
            [controller presentPopoverOnTopOfViewController:self fromView:self.modeCell];
           
    });
    }
}

-(void)setupModeCell{
    AKSegmentedControl * segmentedControl = [[AKSegmentedControl alloc] initWithFrame:self.modeCell.bounds];
    [segmentedControl addTarget:self action:@selector(onModeChanged:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setSegmentedControlMode:AKSegmentedControlModeSticky];
    [segmentedControl setSelectedIndex:[CPConfiguration operationMode]];
    UIImage * img= [UIImage imageNamed:@"modeBg.png"];
    [segmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    
    // Button 1
    UIButton *buttonSocial = [[UIButton alloc] init];
    [buttonSocial setBackgroundImage:img forState:(UIControlStateHighlighted|UIControlStateSelected)];
    UIImage *buttonSocialImageNormal = [UIImage imageNamed:@"single.png"];    
    [buttonSocial setBackgroundImage:img forState:UIControlStateSelected];
    [buttonSocial setImage:buttonSocialImageNormal forState:UIControlStateNormal];
    [buttonSocial setImage:buttonSocialImageNormal forState:UIControlStateSelected];
    [buttonSocial setImage:buttonSocialImageNormal forState:UIControlStateHighlighted];
    [buttonSocial setImage:buttonSocialImageNormal forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    // Button 2
    UIButton *buttonStar = [[UIButton alloc] init];
    UIImage *buttonStarImageNormal = [UIImage imageNamed:@"multiple.png"];
    [buttonStar setBackgroundImage:img forState:UIControlStateSelected];
    [buttonStar setImage:buttonStarImageNormal forState:UIControlStateNormal];
    [buttonStar setImage:buttonStarImageNormal forState:UIControlStateSelected];
    [buttonStar setImage:buttonStarImageNormal forState:UIControlStateHighlighted];
    [buttonStar setImage:buttonStarImageNormal forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    // Button 3
    UIButton *buttonSettings = [[UIButton alloc] init];
    UIImage *buttonSettingsImageNormal = [UIImage imageNamed:@"video.png"];
    [buttonSettings setBackgroundImage:img forState:UIControlStateSelected];
    [buttonSettings setImage:buttonSettingsImageNormal forState:UIControlStateNormal];
    [buttonSettings setImage:buttonSettingsImageNormal forState:UIControlStateSelected];
    [buttonSettings setImage:buttonSettingsImageNormal forState:UIControlStateHighlighted];
    [buttonSettings setImage:buttonSettingsImageNormal forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [segmentedControl setButtonsArray:@[buttonSocial, buttonStar, buttonSettings]];
    [self.modeCell addSubview:segmentedControl];
}

-(void)reloadData:(NSNotification *)notif{
    [self.tableView reloadData];
}

-(void)showCamera{
    [self.clapmeraViewController viewDidAppear:TRUE];
        [self dismissViewControllerAnimated:TRUE completion:^{
            [self.clapmeraViewController resumeClapmeraEngine];
        }];
}

-(void)onDelayChanged:(id)sender{
    self.delaySlider.value = roundf(self.delaySlider.value);
    [self updateDelayLabel];
    [CPConfiguration setDelay:self.delaySlider.value];
}

-(void)onDelayIsChanging:(id)sender{
    [self updateDelayLabel];
}

-(void)updateDelayLabel{
    BOOL shouldUseS=[self shouldUseSForSecondPlural];
    int delayValue = roundf(self.delaySlider.value);
    self.delayLabel.text = [NSString stringWithFormat:@"%d %@", delayValue, NSLocalizedString(@"timeunit", nil)];
    if(shouldUseS){
        self.delayLabel.text=[NSString stringWithFormat:@"%@%@", self.delayLabel.text, (delayValue == 1) ?@"": @"s"];
    }
}

-(BOOL)shouldUseSForSecondPlural{
    NSString * timeUnit= NSLocalizedString(@"timeunit", nil);
    BOOL shouldUseS=NO;
    NSRange range=[timeUnit rangeOfString:@"se"];
    NSRange notFound={NSNotFound, 0};
    if(!NSEqualRanges(range, notFound)){
        shouldUseS=YES;
    }
    return shouldUseS;
}

-(void)setupValuesForSliders{
    self.delaySlider.value = [CPConfiguration delay];
}

#pragma mark -
#pragma UITableViewDelegate & UITableViewDataSources

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.tableViewCells[indexPath.section][indexPath.row];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString * title=nil;
    if(section==0){
        title= NSLocalizedString(@"MODE", nil);
    }else if (section == 1){
        title= NSLocalizedString(@"Timer to take photos", nil);
    }else if(section == 2){
        title= NSLocalizedString(@"About", nil);
    }else if(section == 3){
        title= NSLocalizedString(@"Community", nil);
    }
    return title;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.tableViewCells count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tableViewCells[section] count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.tableViewCells[indexPath.section][indexPath.row] frame].size.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    UITableViewCell * cell=[tableView cellForRowAtIndexPath:indexPath];

    NSString * pathToTrack=[self GAControllerName];
    if([cell isEqual:self.acknowledgments]){
        pathToTrack=[NSString stringWithFormat:@"%@/Acknowledgments", pathToTrack];
        [self showAcknowledgments];
    }else if([cell isEqual:[self likeCell]]){
        pathToTrack=[NSString stringWithFormat:@"%@/facebook", pathToTrack];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/429421140406717"]];
    }else if([cell isEqual:[self twitterCell]]){
        pathToTrack=[NSString stringWithFormat:@"%@/twitter", pathToTrack];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com/clapmera"]];
    }else if([cell isEqual:[self youTubeCell]]){
        pathToTrack=[NSString stringWithFormat:@"%@/Tutorials", pathToTrack];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.youtube.com/channel/UC3leHHYdYb28BZSS_OfuFtg"]];
    }else if([cell isEqual:self.rateApp]){
        pathToTrack=[NSString stringWithFormat:@"%@/rateApp", pathToTrack];        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/addUserReview?id=519363613&type=Purple+Software"]];
    }else if([cell isEqual:self.aboutCell]){
        pathToTrack=[NSString stringWithFormat:@"%@/BlackFireApps.com", pathToTrack];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.blackfireapps.com"]];
    }
//    [[[GAI sharedInstance] defaultTracker] sendView:pathToTrack];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * header=[CPTheme labelForTableViewSectionHeaderWithFrame:self.sensibilityTableViewCell.frame];
    [header setText:[NSString stringWithFormat:@"   %@", [[self tableView:tableView titleForHeaderInSection:section] uppercaseString]]];
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [[cell textLabel] setText:NSLocalizedString([[cell textLabel] text], nil)];
    if([cell isEqual:self.version]){
        NSDictionary * infoDictionary= [[NSBundle mainBundle] infoDictionary];
        NSString * bundle=[infoDictionary objectForKey:@"CFBundleVersion"];
        NSString * shortVersion=[infoDictionary objectForKey:@"CFBundleShortVersionString"];
        self.version.detailTextLabel.text=[NSString stringWithFormat:@"%@ (%@) ", shortVersion,  bundle];
    }
}

-(void)showAcknowledgments{
    AcknowledgmentsViewController * acknowledgments= [AcknowledgmentsViewController new];
    [acknowledgments setURL:[[NSBundle mainBundle] URLForResource:@"Acknowledgments.html" withExtension:nil]];
    [acknowledgments setTitle:NSLocalizedString(@"Acknowledgments", nil)];
    [self.navigationController pushViewController:acknowledgments animated:TRUE];
}

-(void)showLikeButton {
    NSString *likeButtonIframe = @"<iframe src=\"http://www.facebook.com/plugins/likebox.php?id=clapmera&amp;width=292&amp;connections=0&amp;stream=false&amp;header=false&amp;height=60\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; width:320px; height:60px;\" allowTransparency=\"true\"></iframe>";
    NSString *likeButtonHtml = [NSString stringWithFormat:@"<HTML><BODY>%@</BODY></HTML>", likeButtonIframe];
    [self.likeWebView loadHTMLString:likeButtonHtml baseURL:[NSURL URLWithString:@""]];
    [self.likeWebView.scrollView setScrollEnabled:NO];
}

#pragma mark -
#pragma mark modeSegmentedControl

-(void)onModeChanged:(id)mode{
    AKSegmentedControl * ctrl= (AKSegmentedControl *)mode;
    NSInteger index= [[ctrl selectedIndexes] firstIndex];
    [CPConfiguration setOperationMode:index];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

@end
