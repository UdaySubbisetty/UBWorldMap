//
//  UBMapView.m
//  mapSample
//
//  Created by MNC on 28/08/17.
//  Copyright © 2017 rutherford.com. All rights reserved.
//

#import "UBMapView.h"
#import "UBMapDecode.h"
#import "UBPath.h"
@interface UBMapView ()

@property (nonatomic, strong) UBMapDecode* svg;
@property (nonatomic, strong) NSMutableArray* scaledPaths;

@end

@implementation UBMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self) {
        _scaledPaths = [NSMutableArray array];
        [self setDefaultParameters];
    }
    
    return self;
}

- (void)setDefaultParameters
{
    self.fillColor = [UIColor colorWithWhite:0.85 alpha:1];
    self.strokeColor = [UIColor colorWithWhite:0.6 alpha:1];
}

#pragma mark - SVG map loading

- (void)loadMap:(NSString*)mapName withData:(NSArray *)countryArray withColorsArray:(NSArray *)colorsArray withDefaultColor:(UIColor*)color
{
    _svg = [UBMapDecode withFile:mapName];
    
    for (UBPath * path in _svg.paths)
    {
        // Make the map fits inside the frame
        float scaleHorizontal = self.frame.size.width / _svg.bounds.size.width;
        float scaleVertical = self.frame.size.height / _svg.bounds.size.height;
        float scale = MIN(scaleHorizontal, scaleVertical);
        
        CGAffineTransform scaleTransform = CGAffineTransformIdentity;
        scaleTransform = CGAffineTransformMakeScale(scale, scale);
        scaleTransform = CGAffineTransformTranslate(scaleTransform,-_svg.bounds.origin.x, -_svg.bounds.origin.y);
        
        UIBezierPath* scaled = [path.path copy];
        [scaled applyTransform:scaleTransform];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = scaled.CGPath;
        
        // Setting CAShapeLayer properties
        shapeLayer.strokeColor = self.strokeColor.CGColor;
        shapeLayer.lineWidth = 0.5;
        
        if(path.fill)
        {
            if ([countryArray containsObject:path.identifier])
            {
                
                NSUInteger indexOfTheObject = [countryArray indexOfObject:path.identifier];
                UIColor * clr;
                if (colorsArray.count > indexOfTheObject)
                {
                clr = (UIColor *)[colorsArray objectAtIndex:indexOfTheObject];
                }
                
                if (![clr isEqual:@""] && [clr isKindOfClass:[UIColor class]])
                {
                    shapeLayer.fillColor = clr.CGColor;
                }
                else
                {
                    shapeLayer.fillColor = color.CGColor;
                }
                //shapeLayer.fillColor = [UIColor redColor].CGColor;
            }
            else
            {
                shapeLayer.fillColor = self.fillColor.CGColor;
            }
            
        } else {
            shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        }
        [self.layer addSublayer:shapeLayer];
        
        [_scaledPaths addObject:scaled];
    }
}


@end
