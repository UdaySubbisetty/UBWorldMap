//
//  UBPath.h
//  mapSample
//
//  Created by MNC on 28/08/17.
//  Copyright © 2017 rutherford.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UBPath : NSObject
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* identifier;
@property (nonatomic, strong) NSString* className;
@property (nonatomic, strong) NSString* tranform;
@property (nonatomic, strong) UIBezierPath* path;
@property (nonatomic) BOOL fill;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
@end
