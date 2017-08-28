//
//  UBMapView.h
//  mapSample
//
//  Created by MNC on 28/08/17.
//  Copyright © 2017 rutherford.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UBMapView : UIView
// Graphical properties
@property (nonatomic, strong) UIColor* fillColor;
@property (nonatomic, strong) UIColor* strokeColor;

// Click handler


// Loading functions
- (void)loadMap:(NSString*)mapName withData:(NSArray *)countryArray withColorsArray:(NSArray *)colorsArray withDefaultColor:(UIColor*)color;
@end
