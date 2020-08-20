//
//  ClapmeraViewController+iAds.m
//  Clapmera
//
//  Created by Dario Lencina on 12/1/12.
//
//

#import "ClapmeraViewController+iAds.h"

static NSArray * constants=nil;

@implementation ClapmeraViewController (iAds)

-(void)setupiAdNetwork{
    _iAdsBanner = [[ADBannerView alloc] init];
    _iAdsBanner.delegate = self;
    [_iAdsBanner setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.bannerView addSubview:_iAdsBanner];
    [self.bannerView addConstraints:[self iAdsLayoutConstrains]];
    [self layoutBanners];
}

-(NSArray *)iAdsLayoutConstrains{
    if(constants)
        return constants;
    
    NSLayoutConstraint * leading=[NSLayoutConstraint constraintWithItem:_iAdsBanner attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.bannerView attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    
    NSLayoutConstraint * top=[NSLayoutConstraint constraintWithItem:_iAdsBanner attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.bannerView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    NSLayoutConstraint * width=[NSLayoutConstraint constraintWithItem:_iAdsBanner attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.bannerView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    
    NSLayoutConstraint * height=[NSLayoutConstraint constraintWithItem:_iAdsBanner attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.bannerView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    
    constants=@[top, width, height, leading];
    return constants;
}

#pragma mark iADs delegate

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [self layoutBanners];
    BFLog(@"didFailToReceiveAdWithError");
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner{
    BFLog(@"bannerViewActionDidFinish");
    [self layoutBanners];
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    BFLog(@"didLoad");
    [self layoutBanners];
}

- (void)shouldShowBanner:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        [self.bannerHeight setConstant:(_iAdsBanner.bannerLoaded)?_iAdsBanner.frame.size.height:40];
        [self.verticalSpacingOfBanner setConstant:0];
        [self.view layoutSubviews];
    }];
}

-(void)turnOffiAds{
    @try {
        if (_iAdsBanner) {
            [self shouldHideBanner:nil];
            [_iAdsBanner removeFromSuperview];
            [_iAdsBanner cancelBannerViewAction];
            [self.bannerView removeConstraints:[self iAdsLayoutConstrains]];
            _iAdsBanner.delegate=nil;
            _iAdsBanner=nil;
        }
    }
    @catch (NSException *exception) {
        BFLog(@"exception %@", exception);
    }

}

- (void)shouldHideBanner:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        [self.bannerHeight setConstant:(_iAdsBanner.bannerLoaded)?_iAdsBanner.frame.size.height:40];
        [self.verticalSpacingOfBanner setConstant:(_iAdsBanner.bannerLoaded)?_iAdsBanner.frame.size.height:40];
        [self.view layoutSubviews];
    }];
}

@end
