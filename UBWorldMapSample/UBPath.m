//
//  UBPath.m
//  mapSample
//
//  Created by MNC on 28/08/17.
//  Copyright © 2017 rutherford.com. All rights reserved.
//

#import "UBPath.h"
#import "UBMapDecode.h"

@interface UBPath()
@property (nonatomic) CGPoint lastPoint;
@end
@implementation UBPath

- (instancetype)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    _lastPoint.x = _lastPoint.y = 0;
    self.fill = NO;
    self.title = [attributes objectForKey:@"title"];
    self.identifier = [attributes objectForKey:@"id"];
    self.className = [attributes objectForKey:@"class"];
    self.tranform = [attributes objectForKey:@"transform"];
    self.path = nil;
    [self parseData:[attributes objectForKey:@"d"]];
    
    [UBMapDecode parseTransform:self.tranform];
    
    // Check the fill attribute
    if([attributes objectForKey:@"fill"] && [[attributes objectForKey:@"fill"] isEqualToString:@"none"]) {
        self.fill = NO;
    }
    
    return self;
}

- (void)parseData:(NSString*)pathData
{
    if(!pathData || [pathData length] == 0)
        return;
    
    self.path = [UIBezierPath bezierPath];
    
    // Old-schoold C parsing as it's simpler and has a lower overhead
    unsigned long dataLength = [pathData length];
    const char* p = [[pathData dataUsingEncoding:NSASCIIStringEncoding] bytes];
    
    // The value can't be longer than the path data
    char* value = malloc(dataLength * sizeof(char));
    unsigned int valueIndex = 0;
    
    char currentCommand = 0;
    
    for(int i=0;i<dataLength;i++)
    {
        if(isalpha(p[i]) && p[i] != 'e')
        {
            value[valueIndex] = '\0';
            if(valueIndex > 0)
                [self executeCommand:currentCommand forValue:value];
            valueIndex = 0;
            currentCommand = p[i];
            continue;
        }
        
        value[valueIndex++] = p[i];
    }
    
    value[valueIndex] = '\0';
    [self executeCommand:currentCommand forValue:value];
    
    free(value);
}

- (void)executeCommand:(char)command forValue:(const char*)value
{
    NSArray* coordinates = [UBMapDecode parsePoints:value];
    
    if([coordinates count] == 0 && command != 'z' && command != 'Z')
        return;
    
    switch (command) {
        case 'M':
            [self moveTo:coordinates absolute:YES];
            break;
        case 'm':
            [self moveTo:coordinates absolute:NO];
            break;
            
        case 'L':
            [self lineTo:coordinates absolute:YES];
            break;
            
        case 'l':
            [self lineTo:coordinates absolute:NO];
            break;
            
        case 'H':
            [self horizontalLineTo:coordinates absolute:YES];
            break;
            
        case 'h':
            [self horizontalLineTo:coordinates absolute:NO];
            break;
            
        case 'V':
            [self verticalLineTo:coordinates absolute:YES];
            break;
            
        case 'v':
            [self verticalLineTo:coordinates absolute:NO];
            break;
            
            
        case 'Z':
        case 'z':
            [_path closePath];
            self.fill = YES;
            break;
            
        default:
            NSLog(@"Unknown command %c",command);
            break;
    }
    
}

- (void)moveTo:(NSArray*)coordinates absolute:(BOOL)isAbsolute
{
    for(int i=0;i<[coordinates count] / 2;i++) {
        CGPoint p;
        
        // Bounds checking
        if(i * 2 + 2 > [coordinates count])
            return;
        
        p.x = [coordinates[i * 2] floatValue];
        p.y = [coordinates[i * 2 + 1] floatValue];
        
        if(isAbsolute)
            _lastPoint = p;
        else
            _lastPoint = CGPointMake(p.x + _lastPoint.x, p.y + _lastPoint.y);
        
        [_path moveToPoint:_lastPoint];
    }
}

- (void)lineTo:(NSArray*)coordinates absolute:(BOOL)isAbsolute
{
    for(int i=0;i<[coordinates count] / 2;i++) {
        CGPoint p;
        
        // Bounds checking
        if(i * 2 + 2 > [coordinates count])
            return;
        
        p.x = [coordinates[i * 2] floatValue];
        p.y = [coordinates[i * 2 + 1] floatValue];
        
        if(isAbsolute)
            _lastPoint = p;
        else
            _lastPoint = CGPointMake(p.x + _lastPoint.x, p.y + _lastPoint.y);
        
        [_path addLineToPoint:_lastPoint];
    }
}

- (void)horizontalLineTo:(NSArray*)coordinates absolute:(BOOL)isAbsolute
{
    for(int i=0;i<[coordinates count];i++) {
        
        // Bounds checking
        if(i + 1 > [coordinates count])
            return;
        
        float value = [coordinates[i * 2] floatValue];
        
        if(isAbsolute)
            _lastPoint.x = value;
        else
            _lastPoint = CGPointMake(value + _lastPoint.x, _lastPoint.y);
        
        
        [_path addLineToPoint:_lastPoint];
    }
}

- (void)verticalLineTo:(NSArray*)coordinates absolute:(BOOL)isAbsolute
{
    for(int i=0;i<[coordinates count];i++) {
        
        // Bounds checking
        if(i + 1 > [coordinates count])
            return;
        
        float value = [coordinates[i * 2] floatValue];
        
        if(isAbsolute)
            _lastPoint.y = value;
        else
            _lastPoint = CGPointMake(_lastPoint.x, value + _lastPoint.y);
        
        
        [_path addLineToPoint:_lastPoint];
    }
}




@end
