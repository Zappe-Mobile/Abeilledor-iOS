//
//  CollectionContainerView.h
//  AbeilleDor
//
//  Created by Roman Khan on 06/03/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface ZCollectionContainerView : UIView

- (void)setCollectionDataWithText:(NSMutableArray *)arrayText WithImages:(NSMutableArray *)arrayImages WithTag:(NSInteger)tag WithTitle:(NSString *)lblTitle;

- (void)setCollectionDataWithProductId:(NSMutableArray *)arrayProductId WithProductName:(NSMutableArray *)arrayProductName WithProductImage:(NSMutableArray *)arrayProductImage WithProductRating:(NSMutableArray *)arrayProductRating WithProductReviews:(NSMutableArray *)arrayProductReviews WithCart:(NSMutableArray *)arrayProductCart WithWishlist:(NSMutableArray *)arrayProductWishlist WithProductPrice:(NSMutableArray *)arrayProductPrice WithTitle:(NSString *)strTitle;

@end
