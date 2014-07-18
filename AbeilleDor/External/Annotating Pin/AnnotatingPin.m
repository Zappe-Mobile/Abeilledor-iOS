//
//  AnnotatingPin.m
//  Diplomat
//
//  Created by Computer on 21/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnnotatingPin.h"

@implementation AnnotatingPin
@synthesize coordinate,title,subtitle,tag,carInformation,ImageURL;

- (id)initWithTitle:(NSString *)ttl subttitle:(NSString *)subttl andCoordinate:(CLLocationCoordinate2D)c2d tag:(NSString *)tagValue
{
    self = [super init];
    title = ttl;
    subtitle = subttl;
    coordinate = c2d;
    tag = tagValue;
    return self;
}

@end
