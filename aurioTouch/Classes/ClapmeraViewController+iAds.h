//
//  ClapmeraViewController+iAds.h
//  Clapmera
//
//  Created by Dario Lencina on 12/1/12.
//
//

#import "ClapmeraViewController.h"

@interface ClapmeraViewController (iAds)
    -(void)setupiAdNetwork;
    -(void)shouldShowBanner:(UIButton *)sender;
    -(void)shouldHideBanner:(UIButton *)sender;
    -(void)turnOffiAds;
@end
