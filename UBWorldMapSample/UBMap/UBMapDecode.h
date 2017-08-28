//
//  UBMapDecode.h
//  mapSample
//
//  Created by MNC on 28/08/17.
//  Copyright © 2017 rutherford.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "UBPath.h"
@interface UBMapDecode : NSObject <NSXMLParserDelegate>
@property (nonatomic, strong) NSMutableArray* paths;
@property (nonatomic) CGRect bounds;

+ (instancetype)withFile:(NSString*)filePath;

+ (NSArray*)parsePoints:(const char *)str;
+ (CGAffineTransform)parseTransform:(NSString*)str;

@end
