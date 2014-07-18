//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>


@class NIDropDown;




@protocol NIDropDownDelegate
- (void) niDropDownDelegateMethod: (NIDropDown *) sender withindex:(int)index;
@end

@interface NIDropDown : UIView <UITableViewDelegate, UITableViewDataSource>
{
    NSString *animationDirection;
    UIImageView *imgView;
    int indexStation;
     //  id<getStationid>delegategetstation;
}
@property (nonatomic, retain) id <NIDropDownDelegate> delegate;
//@property (nonatomic, retain) id <getStationid> delegategetstation;
@property (nonatomic, retain) NSString *animationDirection;
-(void)hideDropDown:(UIButton *)b;
-(id)showDropDownFromButton:(UIButton *)button WithHeight:(CGFloat *)height WithContentArray:(NSArray *)arrayContent WithImageArray:(NSArray *)arrayImages WithDirection:(NSString *)direction;
//- (id)showDropDown:(UIButton *)b:(CGFloat *)height:(NSArray *)arr:(NSArray *)imgArr:(NSString *)direction;
@end
