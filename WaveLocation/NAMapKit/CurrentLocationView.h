//
//  CurrentLocationView.h
//  WaveLocation
//
//  Created by hanchao on 14-1-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAAnnotation.h"
#import "NAMapView.h"
@interface CurrentLocationView : UIButton

- (id)initWithAnnotation:(NAAnnotation *)annotation onMapView:(NAMapView *)mapView;

@property (nonatomic, retain) NAAnnotation *annotation;
@property (nonatomic, assign) BOOL          animating;

@end
