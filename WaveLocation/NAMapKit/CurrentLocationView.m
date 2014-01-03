//
//  CurrentLocationView.m
//  WaveLocation
//
//  Created by hanchao on 14-1-2.
//  Copyright (c) 2014年 Littlebox222. All rights reserved.
//

#import "CurrentLocationView.h"

#import <CoreLocation/CoreLocation.h>

#define NA_PIN_WIDTH   40.0f//32.0f
#define NA_PIN_HEIGHT  40.0f//39.0f
#define NA_PIN_POINT_X 8.0f
#define NA_PIN_POINT_Y 8.0f//35.0f


@interface CurrentLocationView()<CLLocationManagerDelegate>

@property (nonatomic, retain) CLLocationManager *locManager;

@property (nonatomic,retain) UIImageView *mapArrowImageView;

- (void)updatePosition;

@property (nonatomic, retain) NAMapView *mapView;

@end

@implementation CurrentLocationView

- (id)initWithAnnotation:(NAAnnotation *)annotation onMapView:(NAMapView *)mapView {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.mapView    = mapView;
        self.annotation = annotation;
        self.animating  = NO;
        
        [self updatePosition];
        
        self.locManager = [[[CLLocationManager alloc] init] autorelease];
        self.locManager.delegate = self;
        if ([CLLocationManager headingAvailable])
            [self.locManager startUpdatingHeading];
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"atention" message:@"compass not Available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        
        self.mapArrowImageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]] autorelease];
        [self.mapArrowImageView setAutoresizingMask:UIViewAutoresizingNone];
        self.mapArrowImageView.frame = CGRectMake((self.frame.size.width-32)/2,
                                                  (self.frame.size.height-32)/2,
                                                  32, 32);
        [self addSubview:self.mapArrowImageView];
        [self sendSubviewToBack:self.mapArrowImageView];
    }
    return self;
}

- (void)setAnimating:(BOOL)animating{
    _animating = animating;
    
    NSString *pinImage = @"ball";
//    switch (self.annotation.color) {
//        case NAPinColorGreen:
//            pinImage = @"pinGreen";
//            break;
//        case NAPinColorPurple:
//            pinImage = @"pinPurple";
//            break;
//        case NAPinColorRed:
//            pinImage = @"pinRed";
//            break;
//    }
    
    NSString * image = _animating ? [NSString stringWithFormat:@"%@Floating", pinImage] : pinImage;
    
    [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(ctx, CGRectMake(rect.size.width/4,
                                              rect.size.height/4,
                                              rect.size.width/2,
                                              rect.size.height/2));
    CGContextSetRGBFillColor(ctx,69.0f/255.0f, 88.0f/255.0f, 255.0f/255.0f, 0.3f);
    CGContextFillPath(ctx);
    CGContextStrokePath(ctx);

    [super drawRect:rect];
    
}

-(void)updatePosition{
    CGPoint point = [self.mapView zoomRelativePoint:self.annotation.point];
    point.x       = point.x - NA_PIN_POINT_X;
    point.y       = point.y - NA_PIN_POINT_Y;
//    self.frame    = CGRectMake(point.x, point.y, NA_PIN_WIDTH*10, NA_PIN_HEIGHT*10);
    self.frame    = CGRectMake(point.x - NA_PIN_WIDTH*10/2 *self.mapView.zoomScale,
                               point.y-NA_PIN_HEIGHT*10/2 *self.mapView.zoomScale ,
                               NA_PIN_WIDTH*10 *self.mapView.zoomScale,
                               NA_PIN_HEIGHT*10 *self.mapView.zoomScale);
    NSLog(@"++++++++++++++++++++   %f",self.mapView.zoomScale);
    self.mapArrowImageView.transform = CGAffineTransformIdentity;
    self.mapArrowImageView.frame = CGRectMake((self.frame.size.width-32.0f)/2.0f ,
                                              (self.frame.size.height-32.0f)/2.0f,
                                              32, 32);
    
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"contentSize"]) {
        [self updatePosition];
        [self setNeedsDisplay];
	}
}

-(void)dealloc
{
    self.annotation = nil;
    self.mapView = nil;
    
    self.locManager = nil;
    self.mapArrowImageView = nil;
    
    [super dealloc];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
	// Convert Degree to Radian and move the needle
	float oldRad =  (manager.heading.trueHeading - 360) * M_PI / 180.0f;
	float newRad =  (newHeading.trueHeading - 360) * M_PI / 180.0f;
	
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    theAnimation.fromValue = [NSNumber numberWithFloat:oldRad];
    theAnimation.toValue=[NSNumber numberWithFloat:newRad];
    theAnimation.duration = 0.5f;
    [self.mapArrowImageView.layer addAnimation:theAnimation forKey:@"animateMyRotation"];
    self.mapArrowImageView.transform = CGAffineTransformMakeRotation(newRad);
//	NSLog(@"%f (%f) => %f (%f)", manager.heading.trueHeading, oldRad, newHeading.trueHeading, newRad);
}

@end

#undef NA_PIN_WIDTH
#undef NA_PIN_HEIGHT
#undef NA_PIN_POINT_X
#undef NA_PIN_POINT_Y

