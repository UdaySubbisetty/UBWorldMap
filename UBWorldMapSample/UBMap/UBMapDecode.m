//
//  UBMapDecode.m
//  mapSample
//
//  Created by MNC on 28/08/17.
//  Copyright © 2017 rutherford.com. All rights reserved.
//

#import "UBMapDecode.h"


@interface UBMapDecode()

@property (nonatomic, strong) NSMutableArray* transforms;
@property (nonatomic) CGAffineTransform currentTransform;
@end

@implementation UBMapDecode

+ (instancetype)withFile:(NSString*)filePath
{
    return [[UBMapDecode alloc]initWithFile:filePath];
}

- (id)initWithFile:(NSString*)filename
{
    self = [super init];
    
    if(self)
    {
        _paths = [NSMutableArray array];
        _transforms = [NSMutableArray array];
        _currentTransform = CGAffineTransformIdentity;
        
        NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@"svg"]];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
        parser.delegate = self;
        [parser parse];
        [self computeBounds];
    }
    
    return self;
}

#pragma mark - Xml Parsing

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    if([elementName isEqualToString:@"path"])
    {
        UBPath* element = [[UBPath alloc] initWithAttributes:attributeDict];
        if(element.path) {
            [_paths addObject:element];
        }
        
        CGAffineTransform t = _currentTransform;
        
        if([attributeDict objectForKey:@"transform"])
        {
            CGAffineTransform pathTransform = [[self class] parseTransform:[attributeDict objectForKey:@"transform"]];
            t = CGAffineTransformConcat(pathTransform, _currentTransform);
        }
        
        [element.path applyTransform:t];
    }
    else if([elementName isEqualToString:@"g"])
    {
        CGAffineTransform t = CGAffineTransformIdentity;
        if([attributeDict objectForKey:@"transform"])
        {
            t = [[self class] parseTransform:[attributeDict objectForKey:@"transform"]];
        }
        
        _currentTransform = CGAffineTransformConcat(t, _currentTransform);
        [_transforms addObject:NSStringFromCGAffineTransform(_currentTransform)];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
{
    if([elementName isEqualToString:@"g"])
    {
        [_transforms removeLastObject];
        
        if([_transforms count] > 0 ) {
            _currentTransform = CGAffineTransformFromString([_transforms lastObject]);
        } else {
            _currentTransform = CGAffineTransformIdentity;
        }
    }
}

#pragma mark - Bounds

- (void)computeBounds
{
    _bounds.origin.x = MAXFLOAT;
    _bounds.origin.y = MAXFLOAT;
    float maxx = -MAXFLOAT;
    float maxy = -MAXFLOAT;
    
    for (UBPath* path in _paths) {
        CGRect b =  CGPathGetPathBoundingBox(path.path.CGPath);
        
        if(b.origin.x < _bounds.origin.x)
            _bounds.origin.x = b.origin.x;
        
        if(b.origin.y < _bounds.origin.y)
            _bounds.origin.y = b.origin.y;
        
        if(b.origin.x + b.size.width > maxx)
            maxx = b.origin.x + b.size.width;
        
        if(b.origin.y + b.size.height > maxy)
            maxy = b.origin.y + b.size.height;
    }
    
    _bounds.size.width = maxx - _bounds.origin.x;
    _bounds.size.height = maxy - _bounds.origin.y;
}

+ (NSArray*)parsePoints:(const char *)str
{
    NSScanner *scanner = [NSScanner scannerWithString:[NSString stringWithUTF8String:str]];
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"\n, "]];
    
    NSMutableArray* array = [NSMutableArray array];
    
    float value = 0;
    while([scanner scanFloat:&value]) {
        NSNumber* number = [NSNumber numberWithFloat:value];
        [array addObject:number];
    }
    
    return array;
}

+ (CGAffineTransform)parseTransform:(NSString*)str
{
    CGAffineTransform tranform = CGAffineTransformIdentity;
    
    if([str length] > 0) {
        // Only supporting translate and matrix so far...
        NSRange range = NSMakeRange(0, [str length]);
        NSString* patternTranslate = @"translate\\((.*)\\)";
        NSString* patternMatrix = @"matrix\\((.*)\\)";
        NSError* regexError = nil;
        
        NSRegularExpression* regexTranslate = [NSRegularExpression regularExpressionWithPattern:patternTranslate options:NSRegularExpressionCaseInsensitive error:&regexError];
        
        if(!regexError) {
            NSArray* matches = [regexTranslate matchesInString:str options:NSMatchingWithoutAnchoringBounds range:range];
            if([matches count] > 0)
            {
                NSTextCheckingResult *entry = matches[0];
                NSString *parameters = [str substringWithRange:[entry rangeAtIndex:1]];
                NSArray* coordinates = [self parsePoints:[parameters UTF8String]];
                
                if([coordinates count] == 2) {
                    tranform = CGAffineTransformMakeTranslation([coordinates[0] floatValue], [coordinates[1] floatValue]);
                    return tranform;
                }
            }
        }
        
        NSRegularExpression* regexMatrix = [NSRegularExpression regularExpressionWithPattern:patternMatrix options:NSRegularExpressionCaseInsensitive error:&regexError];
        
        if(!regexError)
        {
            NSArray* matches = [regexMatrix matchesInString:str options:NSMatchingWithoutAnchoringBounds  range:range];
            if([matches count] > 0) {
                NSTextCheckingResult *entry = matches[0];
                NSString *parameters = [str substringWithRange:[entry rangeAtIndex:1]];
                NSArray* coordinates = [self parsePoints:[parameters UTF8String]];
                
                if([coordinates count] == 6)
                {
                    tranform = CGAffineTransformMake([coordinates[0] floatValue], [coordinates[1] floatValue], [coordinates[2] floatValue], [coordinates[3] floatValue], [coordinates[4] floatValue], [coordinates[5] floatValue]);
                    return tranform;
                }
            }
        }
    }
    
    
    return CGAffineTransformIdentity;
}

@end
