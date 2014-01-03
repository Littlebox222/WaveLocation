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
#define NA_PIN_POINT_Y 35.0f


@interface UIImage (CS_Extensions)
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end;


//
//  UIImage-Extensions.m
//
//  Created by Hardy Macia on 7/1/09.
//  Copyright 2009 Catamount Software. All rights reserved.
//

CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

@implementation UIImage (CS_Extensions)

-(UIImage *)imageAtRect:(CGRect)rect
{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
    
}

- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}


- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}


- (UIImage *)imageByScalingToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    //   CGSize imageSize = sourceImage.size;
    //   CGFloat width = imageSize.width;
    //   CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    //   CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}


- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    return [self imageRotatedByDegrees:RadiansToDegrees(radians)];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    [rotatedViewBox release];
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

@end;


@interface CurrentLocationView()<CLLocationManagerDelegate> {
//    IBOutlet UIImageView *arrow;
//    IBOutlet UILabel *angel;
//    CLLocationManager *locManager;
}

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

static inline double radians (double degrees) {return degrees * M_PI/180;}

UIImage* rotate(UIImage* src,double degrees)
{
    UIGraphicsBeginImageContext(src.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    if (orientation == UIImageOrientationRight) {
//        CGContextRotateCTM (context, radians(90));
//    } else if (orientation == UIImageOrientationLeft) {
//        CGContextRotateCTM (context, radians(-90));
//    } else if (orientation == UIImageOrientationDown) {
//        // NOTHING
//    } else if (orientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, radians(degrees));
//    }
    
    [src drawAtPoint:CGPointMake(0, 0)];
    
    return UIGraphicsGetImageFromCurrentImageContext();
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextAddEllipseInRect(ctx, CGRectMake(rect.size.width/4, rect.size.height/4, rect.size.width/2, rect.size.height/2));
    CGContextSetRGBFillColor(ctx,69.0f/255.0f, 88.0f/255.0f, 255.0f/255.0f, 0.3f);
    CGContextFillPath(ctx);
    CGContextStrokePath(ctx);
    
    
//    UIImage *arrow = [[UIImage imageNamed:@"arrow"] retain];
//    UIImage *arrowWithDegree = [[arrow imageRotatedByDegrees:30] retain];
//    [arrow release];
//    CGContextDrawImage(ctx, CGRectMake((rect.size.width-32)/2, (rect.size.height-32)/2, 32, 32),
//                       arrowWithDegree.CGImage);
//    [arrowWithDegree release];
//    
//    [super drawRect:rect];
    
}

-(void)updatePosition{
    CGPoint point = [self.mapView zoomRelativePoint:self.annotation.point];
    point.x       = point.x - NA_PIN_POINT_X;
    point.y       = point.y - NA_PIN_POINT_Y;
//    self.frame    = CGRectMake(point.x, point.y, NA_PIN_WIDTH*10, NA_PIN_HEIGHT*10);
    self.frame    = CGRectMake(point.x - NA_PIN_WIDTH*10/2,
                               point.y-NA_PIN_HEIGHT*10/2,
                               NA_PIN_WIDTH*10,
                               NA_PIN_HEIGHT*10);
//    self.backgroundColor = [UIColor blackColor];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString:@"contentSize"]) {
        [self updatePosition];
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
	NSLog(@"%f (%f) => %f (%f)", manager.heading.trueHeading, oldRad, newHeading.trueHeading, newRad);
}

@end

#undef NA_PIN_WIDTH
#undef NA_PIN_HEIGHT
#undef NA_PIN_POINT_X
#undef NA_PIN_POINT_Y

