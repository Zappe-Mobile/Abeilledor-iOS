//
//  ValidataionConstant.m
//  AbeilleDor
//
//  Created by rkhan-mbook on 28/05/14.
//  Copyright (c) 2014 Roman Khan. All rights reserved.
//

#import "ValidataionConstant.h"

@implementation ValidataionConstant

+(BOOL) validateEmail:(NSString *)email errorMessage:(NSError**)error{
    
    BOOL isValid = YES;
    
    if ([[email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0){
        if(*error == nil)
            *error = [NSError errorWithDomain:@"validateError" code:111 userInfo:@{@"msg":@"empty"}];
    }
    else
    {
        
        NSString *emailRegex =
        @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
        @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
        @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
        @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
        @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
        @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
        @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
        
        BOOL isValid = [predicate evaluateWithObject:email];
        
        if (!isValid) {
            if(*error == nil)
                *error = [NSError errorWithDomain:@"validateError" code:111 userInfo:@{@"msg":@"invalid"}];
        }
        else
        {
            if(*error == nil)
                *error = [NSError errorWithDomain:@"validateError" code:111 userInfo:@{@"msg":@""}];
        }
        
    }
    
    return isValid;
}

@end
