//
//  CollectionContainerView.m
//  AbeilleDor
//
//  Created by Roman Khan on 06/03/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import "ZCollectionContainerView.h"
#import "ZCollectionViewCell.h"
#import "ALToastView.h"
#import "DataManager.h"

@interface ZCollectionContainerView () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    IBOutlet UICollectionView *_collectionView;
}
@property (strong, nonatomic) NSMutableArray *arrayTextData;
@property (strong, nonatomic) NSMutableArray *arrayImageData;
@property (strong, nonatomic) NSString * strTitle;

@property (strong, nonatomic) NSMutableArray * arrayProductId;
@property (strong, nonatomic) NSMutableArray * arrayProductName;
@property (strong, nonatomic) NSMutableArray * arrayProductImage;
@property (strong, nonatomic) NSMutableArray * arrayProductRating;
@property (strong, nonatomic) NSMutableArray * arrayProductReviews;
@property (strong, nonatomic) NSMutableArray * arrayProductsCart;
@property (strong, nonatomic) NSMutableArray * arrayProductsWishlist;
@property (strong, nonatomic) NSMutableArray * arrayProductPrice;

@end

@implementation ZCollectionContainerView

- (void)awakeFromNib {
    
    _collectionView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:253.0f/255.0f blue:211.0f/255.0f alpha:1.0];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.itemSize = CGSizeMake(145.0, 240.0);
    [_collectionView setCollectionViewLayout:flowLayout];
    
    
    
}


#pragma mark - Getter/Setter overrides
- (void)setCollectionDataWithText:(NSMutableArray *)arrayText WithImages:(NSMutableArray *)arrayImages WithTag:(NSInteger)tag WithTitle:(NSString *)lblTitle {
    
    _arrayTextData = arrayText;
    _arrayImageData = arrayImages;
    
    _strTitle = lblTitle;
    
    _collectionView.tag = tag;
    
    [_collectionView setContentOffset:CGPointZero animated:NO];
    [_collectionView reloadData];
}


- (void)setCollectionDataWithProductId:(NSMutableArray *)arrayProductId WithProductName:(NSMutableArray *)arrayProductName WithProductImage:(NSMutableArray *)arrayProductImage WithProductRating:(NSMutableArray *)arrayProductRating WithProductReviews:(NSMutableArray *)arrayProductReviews WithCart:(NSMutableArray *)arrayProductCart WithWishlist:(NSMutableArray *)arrayProductWishlist WithProductPrice:(NSMutableArray *)arrayProductPrice WithTitle:(NSString *)strTitle
{
    
    _arrayProductId = arrayProductId;
    _arrayProductName = arrayProductName;
    _arrayProductImage = arrayProductImage;
    _arrayProductRating = arrayProductRating;
    _arrayProductReviews = arrayProductReviews;
    _arrayProductsCart = arrayProductCart;
    _arrayProductsWishlist = arrayProductWishlist;
    _arrayProductPrice = arrayProductPrice;
    
    _strTitle = strTitle;
    
    [_collectionView setContentOffset:CGPointZero animated:NO];
    [_collectionView reloadData];

    
}

#pragma mark - UICollectionViewDataSource Methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.arrayProductName count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ZCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ZCollectionViewCell"];
            
    ZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZCollectionViewCell" forIndexPath:indexPath];
    
    if ([self.strTitle isEqualToString:@"Abeille d'Or"]) {
        cell.layer.borderWidth = 1.0;
        cell.layer.borderColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0].CGColor;
        cell.viewbackground.backgroundColor = [UIColor colorWithRed:85.0f/255.0f green:45.0f/255.0f blue:0.0f/255.0f alpha:1.0];

    }
    else {
        cell.layer.borderWidth = 1.0;
        cell.layer.borderColor = [UIColor colorWithRed:170.0f/255.0f green:0.0f/255.0f blue:27.0f/255.0f alpha:1.0].CGColor;
        cell.viewbackground.backgroundColor = [UIColor colorWithRed:170.0f/255.0f green:0.0f/255.0f blue:27.0f/255.0f alpha:1.0];

    }
    
    
    cell.lblBrand.text = self.strTitle;
    cell.lblName.text = [self.arrayProductName objectAtIndex:indexPath.row];
    cell.lblReview.text = [NSString stringWithFormat:@"Reviews (%@)",[self.arrayProductReviews objectAtIndex:indexPath.row]];
    
    NSLog(@"%@",[self.arrayProductRating objectAtIndex:indexPath.row]);
    if ([[self.arrayProductRating objectAtIndex:indexPath.row]isEqualToString:@"0"]) {
        
    }
    else if ([[self.arrayProductRating objectAtIndex:indexPath.row]isEqualToString:@"1"]) {
        
        cell.imgRatingOne.image = [UIImage imageNamed:@"rating.png"];

    }
    else if ([[self.arrayProductRating objectAtIndex:indexPath.row]isEqualToString:@"2"]) {
        
        cell.imgRatingOne.image = [UIImage imageNamed:@"rating.png"];
        cell.imgRatingTwo.image = [UIImage imageNamed:@"rating.png"];

    }
    else if ([[self.arrayProductRating objectAtIndex:indexPath.row]isEqualToString:@"3"]) {
        
        cell.imgRatingOne.image = [UIImage imageNamed:@"rating.png"];
        cell.imgRatingTwo.image = [UIImage imageNamed:@"rating.png"];
        cell.imgRatingThree.image = [UIImage imageNamed:@"rating.png"];

    }
    else if ([[self.arrayProductRating objectAtIndex:indexPath.row]isEqualToString:@"4"]) {
        
        cell.imgRatingOne.image = [UIImage imageNamed:@"rating.png"];
        cell.imgRatingTwo.image = [UIImage imageNamed:@"rating.png"];
        cell.imgRatingThree.image = [UIImage imageNamed:@"rating.png"];
        cell.imgRatingFour.image = [UIImage imageNamed:@"rating.png"];

    }
    else if ([[self.arrayProductRating objectAtIndex:indexPath.row]isEqualToString:@"5"]) {
        
        cell.imgRatingOne.image = [UIImage imageNamed:@"rating.png"];
        cell.imgRatingTwo.image = [UIImage imageNamed:@"rating.png"];
        cell.imgRatingThree.image = [UIImage imageNamed:@"rating.png"];
        cell.imgRatingFour.image = [UIImage imageNamed:@"rating.png"];
        cell.imgRatingFive.image = [UIImage imageNamed:@"rating.png"];
    }

    if ([self.strTitle isEqualToString:@"Abeille d'Or"]) {
        UIButton * btnCart = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCart.frame = CGRectMake(111, 102, 24, 20);
        btnCart.tag = indexPath.row;
        if ([[_arrayProductsCart objectAtIndex:indexPath.row]isEqualToString:@"0"]) {
            [btnCart setBackgroundImage:[UIImage imageNamed:@"Cart_brown.png"] forState:UIControlStateNormal];
        }
        else {
            [btnCart setBackgroundImage:[UIImage imageNamed:@"tickedCart_brown.png"] forState:UIControlStateNormal];
        }
        [btnCart addTarget:self action:@selector(btnCartClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnCart];

    }
    else {

    }
    
    
    UIButton * btnFavorite = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFavorite.frame = CGRectMake(14, 104, 20, 20);
    btnFavorite.tag = indexPath.row;
    if ([self.strTitle isEqualToString:@"Abeille d'Or"]) {
        if ([[_arrayProductsWishlist objectAtIndex:indexPath.row]isEqualToString:@"0"]) {
            [btnFavorite setBackgroundImage:[UIImage imageNamed:@"Empty_Fav_Brown.png"] forState:UIControlStateNormal];
        }
        else {
            [btnFavorite setBackgroundImage:[UIImage imageNamed:@"Filled_Fav_brown.png"] forState:UIControlStateNormal];
        }
        
    }
    else {
        if ([[_arrayProductsWishlist objectAtIndex:indexPath.row]isEqualToString:@"0"]) {
            [btnFavorite setBackgroundImage:[UIImage imageNamed:@"Empty_Fav_Darkred.png"] forState:UIControlStateNormal];
        }
        else {
            [btnFavorite setBackgroundImage:[UIImage imageNamed:@"Filled_Fav_Darkred.png"] forState:UIControlStateNormal];
        }
        
    }

    
    [btnFavorite addTarget:self action:@selector(btnFavoriteClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btnFavorite];
    
    NSURL * url = [NSURL URLWithString:[self.arrayProductImage objectAtIndex:indexPath.row]];
    
    [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            cell.imgProduct.image = image;
        }
        else {
            cell.imgProduct.image = [UIImage imageNamed:@"default_placeholder-image.png"];
        }
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray * array = [[NSArray alloc]initWithObjects:[NSString stringWithFormat:@"%ld",(long)_collectionView.tag],[NSString stringWithFormat:@"%ld",(long)indexPath.row],nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CollectionViewSelection" object:array];
}

-(void)btnCartClicked:(UIButton *)sender
{
    if ([[_arrayProductsCart objectAtIndex:sender.tag]isEqualToString:@"0"]) {
        
    NSLog(@"%ld",(long)sender.tag);
    NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
    [dict setObject:[_arrayProductId objectAtIndex:sender.tag] forKey:@"productId"];
    [dict setObject:[_arrayProductName objectAtIndex:sender.tag] forKey:@"productName"];
    [dict setObject:[_arrayProductImage objectAtIndex:sender.tag] forKey:@"productImage"];
    [dict setObject:[_arrayProductRating objectAtIndex:sender.tag] forKey:@"productRating"];
    [dict setObject:[_arrayProductReviews objectAtIndex:sender.tag] forKey:@"productReviews"];
    [dict setObject:[_arrayProductPrice objectAtIndex:sender.tag] forKey:@"productPrice"];
    [dict setObject:@"1" forKey:@"productQuantity"];
    
    NSLog(@"%@",dict);
    
    [sender setBackgroundImage:[UIImage imageNamed:@"tickedCart_brown"] forState:UIControlStateNormal];
    
    [ALToastView toastInView:self withText:@"Item Added to Cart"];
        
        NSString * str = [[NSUserDefaults standardUserDefaults]objectForKey:@"CART"];
        int x = [str intValue];
        x = x+1;
        str = [NSString stringWithFormat:@"%d",x];
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:str forKey:@"CART"];
        [defaults synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BADGECOUNT" object:str];
    
    
        [DataManager addProductsToCart:dict WithDataBlock:^(BOOL success, NSError *error) {
        
        //! Items Added to Cart
        if (success) {
            
            [_arrayProductsCart replaceObjectAtIndex:sender.tag withObject:@"1"];
            [DataManager updateAddCartProductWithProductId:[_arrayProductId objectAtIndex:sender.tag] WithDataBlock:^(BOOL success, NSError *error) {
                
                //! Entity Product Updated
                if (success) {
                    
                }
                else {
                    
                }
                
            }];
        }
        //! Storage Failure
        else {
            
        }
    }];
        
    }
    
    else {
        
        [sender setBackgroundImage:[UIImage imageNamed:@"Cart_brown.png"] forState:UIControlStateNormal];
        
        [ALToastView toastInView:self withText:@"Item Deleted From Cart"];
        
        NSString * str = [[NSUserDefaults standardUserDefaults]objectForKey:@"CART"];
        int x = [str intValue];
        x = x-1;
        str = [NSString stringWithFormat:@"%d",x];
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:str forKey:@"CART"];
        [defaults synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BADGECOUNT" object:str];

        
        [DataManager removeItemFromCartWithProductId:[_arrayProductId objectAtIndex:sender.tag] WithDataBlock:^(BOOL success, NSError *error) {
            
            if (success) {
                [_arrayProductsCart replaceObjectAtIndex:sender.tag withObject:@"0"];
                [DataManager updateAndRemoveCartProductWithProductId:[_arrayProductId objectAtIndex:sender.tag] WithDataBlock:^(BOOL success, NSError *error) {
                    
                    if (success) {
                        
                    }
                    else {
                        
                    }
                }];
            }
            else {
                
            }
        }];

    }
}

-(void)btnFavoriteClicked:(UIButton *)sender
{
    if ([[_arrayProductsWishlist objectAtIndex:sender.tag]isEqualToString:@"0"]) {
        
        NSLog(@"%ld",(long)sender.tag);
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict setObject:[_arrayProductId objectAtIndex:sender.tag] forKey:@"productId"];
        [dict setObject:[_arrayProductName objectAtIndex:sender.tag] forKey:@"productName"];
        [dict setObject:[_arrayProductImage objectAtIndex:sender.tag] forKey:@"productImage"];
        [dict setObject:[_arrayProductRating objectAtIndex:sender.tag] forKey:@"productRating"];
        [dict setObject:[_arrayProductReviews objectAtIndex:sender.tag] forKey:@"productReviews"];
        [dict setObject:[_arrayProductPrice objectAtIndex:sender.tag] forKey:@"productPrice"];

        
        if ([self.strTitle isEqualToString:@"Abeille d'Or"]) {
            
            [dict setObject:@"abeilledor" forKey:@"productType"];
            [sender setBackgroundImage:[UIImage imageNamed:@"Filled_Fav_brown.png"] forState:UIControlStateNormal];
        }
        else {
            [dict setObject:@"yakult" forKey:@"productType"];
            [sender setBackgroundImage:[UIImage imageNamed:@"Filled_Fav_Darkred.png"] forState:UIControlStateNormal];
        }
        
        [ALToastView toastInView:self withText:@"Item Added to Wishlist"];
        
        [DataManager addProductsToWishlist:dict WithDataBlock:^(BOOL success, NSError *error) {
            
            //! Items Added to Wishlist
            if (success) {
                [_arrayProductsWishlist replaceObjectAtIndex:sender.tag withObject:@"1"];
                
                if ([self.strTitle isEqualToString:@"Abeille d'Or"]) {
                    
                    //! Abeille d'Or Update
                    [DataManager updateAddWishlistProductWithProductId:[_arrayProductId objectAtIndex:sender.tag] WithDataBlock:^(BOOL success, NSError *error) {
                        
                        if (success) {
                            
                        }
                        else {
                            
                        }
                    }];
                }
                else {
                    //! Yakult Update
                    [DataManager updateAddWishlistYakultWithProductId:[_arrayProductId objectAtIndex:sender.tag] WithDataBlock:^(BOOL success, NSError *error) {
                        
                        if (success) {
                            
                        }
                        else {
                            
                        }
                    }];
                }
                
            }
            //! Storage Failure
            else {
                
            }
        }];

        
    }
    else {
       
        if ([self.strTitle isEqualToString:@"Abeille d'Or"]) {
            
            [sender setBackgroundImage:[UIImage imageNamed:@"Empty_Fav_Brown.png"] forState:UIControlStateNormal];
            
        }
        else {
            
            [sender setBackgroundImage:[UIImage imageNamed:@"Empty_Fav_Darkred.png"] forState:UIControlStateNormal];
        }
        
        [ALToastView toastInView:self withText:@"Item Deleted to Wishlist"];

        [DataManager removeItemFromWishlistWithProductId:[_arrayProductId objectAtIndex:sender.tag] WithDataBlock:^(BOOL success, NSError *error) {
            
            if (success) {
                
                [_arrayProductsWishlist replaceObjectAtIndex:sender.tag withObject:@"0"];
                
                if ([self.strTitle isEqualToString:@"Abeille d'Or"]) {
                    
                    //! Abeille d'Or Update
                    [DataManager updateAndRemoveWishlistProductWithProductId:[_arrayProductId objectAtIndex:sender.tag] WithDataBlock:^(BOOL success, NSError *error) {
                        
                        if (success) {
                            
                        }
                        else {
                            
                        }
                        
                    }];
                }
                else {
                    
                    //! Yakult Update
                    [DataManager updateAndRemoveWishlistYakultWithProductId:[_arrayProductId objectAtIndex:sender.tag] WithDataBlock:^(BOOL success, NSError *error) {
                        
                        if (success) {
                            
                        }
                        else {
                            
                        }
                        
                    }];
                }
                
            }
            else {
                
                
            }
            
        }];
        
    }
    
}

#pragma mark - Asynchronous Image Download
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

@end
