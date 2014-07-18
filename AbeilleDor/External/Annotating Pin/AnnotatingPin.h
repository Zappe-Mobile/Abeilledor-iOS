//
//  AnnotatingPin.h
//  SL
//
//  Created by Computer on 21/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AnnotatingPin : NSObject<MKAnnotation>
{
    
}
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * subtitle;
@property (nonatomic,copy) NSString * tag;
@property (nonatomic,copy) NSString * carInformation;
@property (nonatomic,copy) NSString * ImageURL;
- (id)initWithTitle:(NSString *)ttl subttitle:(NSString *)subttl andCoordinate:(CLLocationCoordinate2D)c2d tag:(NSString *)tagValue;

@end
