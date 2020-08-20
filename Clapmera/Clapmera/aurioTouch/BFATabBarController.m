//
//  RMTabBarControllerViewController.m
//  Graphic tweets
//
//  Created by Dario Lencina on 9/9/12.
//  Copyright (c) 2012 Dario Lencina. All rights reserved.
//

#import "BFATabBarController.h"

@interface BFATabBarController ()

@end

@implementation BFATabBarController


-(void)touchListener:(NSNotification *)notif
{
    UIEvent * event= [notif object];
    if(event.type==UIEventTypeTouches){
        for(id touch in [event allTouches]){
            CGPoint pt=[touch locationInView:self.view.superview];
            if(!CGRectContainsPoint(self.menuButton.frame, pt) && !CGRectContainsPoint(self.menuOptions.frame, pt)&& [touch phase]==UITouchPhaseEnded && self.menuOptions.alpha==1){
                    [self toggleMenuOptions];
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)setupCustomTabBar
{
    NSArray * arregloDeObjetosDelNib= [[NSBundle mainBundle] loadNibNamed:RMMenuView owner:nil options:nil];
    self.menuBackground= (UIView *)[arregloDeObjetosDelNib objectAtIndex:0];
    UITableView * menuOptions= (UITableView *)[self.menuBackground viewWithTag:1];
    [menuOptions setDataSource:self];
    [menuOptions setDelegate:self];
    self.menuButton= (UIButton *)[self.menuBackground viewWithTag:2];
    [self.menuButton addTarget:self action:@selector(selectedMenuButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view.window addSubview:self.menuBackground];
    self.menuBackground.alpha=0;
    [self.view.window addSubview:self.menuButton];
    [self.view.window addSubview:menuOptions];
    self.menuOptions=menuOptions;
    self.menuOptions.alpha=0;
    [UIView transitionWithView:self.menuButton duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut animations:^{

    }completion:NULL];
    [self setDelegate:self];

}

-(void)selectedMenuButton:(UIButton *)button
{
    [self toggleMenuOptions];
}

-(void)toggleMenuOptions
{
    [self setMenuVisible:(self.menuBackground.alpha==1)?NO:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setMenuVisible:(BOOL)visible{
    [UIView transitionWithView:self.menuOptions duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom|UIViewAnimationOptionCurveEaseInOut animations:^{
        self.menuOptions.alpha=(visible)?1:0;
        if(self.menuOptions.alpha==1){
            self.menuBackground.alpha=1;
        }else{
            self.menuBackground.alpha=0;
        }
    }completion:^(BOOL finished){
        
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewControllers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId= @"menuPrototype";
    UITableViewCell * cell= [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell= [[[NSBundle mainBundle] loadNibNamed:RMMenuView owner:nil options:nil]objectAtIndex:1];
    }
    [[cell textLabel] setText:[[[self viewControllers] objectAtIndex:indexPath.row] title]];
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    [self setSelectedIndex:indexPath.row];
    [self toggleMenuOptions];
}

#pragma mark -
#pragma mark UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    [UIView transitionWithView:viewController.view duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut animations:^{

    }completion:^(BOOL finished){
        
    }];
    return TRUE;
}

@end
