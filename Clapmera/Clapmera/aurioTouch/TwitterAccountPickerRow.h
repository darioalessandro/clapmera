//
//  TwitterAccountPickerRow.h
//  GraphicTweets
//
//  Created by Dario Lencina on 2/23/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFTwitterImageView.h"

@interface TwitterAccountPickerRow : UITableViewCell
@property(nonatomic, weak) IBOutlet BFTwitterImageView * twitterPic;
@property(nonatomic,weak)  IBOutlet UILabel * username;
@property (weak, nonatomic) IBOutlet UILabel *userID;
@end
