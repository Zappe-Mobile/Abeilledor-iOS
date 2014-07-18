//
//  ValidataionConstant.h
//  AbeilleDor
//
//  Created by rkhan-mbook on 28/05/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidataionConstant : NSObject

+(BOOL) validateEmail:(NSString *)email errorMessage:(NSError**)error;
@end
