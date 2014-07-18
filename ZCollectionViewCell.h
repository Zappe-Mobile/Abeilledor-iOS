//
//  CollectionViewCell.h
//  AbeilleDor
//
//  Created by Roman Khan on 06/03/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ZCollectionViewCell : UICollectionViewCell

@property (strong) IBOutlet UIImageView * imgProduct;
@property (strong) IBOutlet UILabel * lblBrand;
@property (strong) IBOutlet UILabel * lblName;
@property (strong) IBOutlet UILabel * lblRating;
@property (strong) IBOutlet UIImageView * imgRatingOne;
@property (strong) IBOutlet UIImageView * imgRatingTwo;
@property (strong) IBOutlet UIImageView * imgRatingThree;
@property (strong) IBOutlet UIImageView * imgRatingFour;
@property (strong) IBOutlet UIImageView * imgRatingFive;
@property (strong) IBOutlet UILabel * lblReview;
@property (strong) IBOutlet UIView * viewbackground;
@property (strong) IBOutlet UIButton * btnFavorite;
@property (strong) IBOutlet UIButton * btnCart;

@end
