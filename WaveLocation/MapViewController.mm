//
//  MapViewController.m
//  WaveLocation
//
//  Created by Littlebox222 on 13-12-30.
//  Copyright (c) 2013年 Littlebox222. All rights reserved.
//

#import "MapViewController.h"
#import "NAAnnotation.h"
#import "GeoHash.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize successPlayer = _successPlayer;

- (void)dealloc {
    
    [_successPlayer release];
    [_mapView release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    self.mapView = [[[NAMapView alloc] initWithFrame:self.view.bounds] autorelease];
    
    self.mapView.backgroundColor  = [UIColor colorWithRed:0.000f green:0.475f blue:0.761f alpha:1.000f];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.mapView.minimumZoomScale = 0.1f;
    self.mapView.maximumZoomScale = 2.5f;
    
    [self.mapView displayMap:[UIImage imageNamed:@"11"]];
    
    [self.view addSubview:self.mapView];
    
    /*
    NAAnnotation *annotation_1 = [NAAnnotation annotationWithPoint:CGPointMake(600.0f, 830.0f)];
    annotation_1.title = @"工位-1";
    annotation_1.color = NAPinColorGreen;
    
    [self.mapView addAnnotation:annotation_1 animated:NO];
    
    NAAnnotation * annotation_2 = [NAAnnotation annotationWithPoint:CGPointMake(540.0f, 830.0f)];
	annotation_2.title = @"工位-2";
    annotation_2.color = NAPinColorGreen;
    
	[self.mapView addAnnotation:annotation_2 animated:YES];
    
	NAAnnotation * annotation_3 = [NAAnnotation annotationWithPoint:CGPointMake(680.0f, 830.0f)];
	annotation_3.title = @"工位-3";
    annotation_3.color = NAPinColorGreen;
    
	[self.mapView addAnnotation:annotation_3 animated:NO];
    
    NAAnnotation *annotation_4 = [NAAnnotation annotationWithPoint:CGPointMake(440.0f, 690.0f)];
    annotation_4.title = @"吸烟室";
    annotation_4.color = NAPinColorPurple;
    
    [self.mapView addAnnotation:annotation_4 animated:NO];
    
    NAAnnotation * annotation_5 = [NAAnnotation annotationWithPoint:CGPointMake(1000.0f, 940.0f)];
	annotation_5.title = @"3号会议室";
    annotation_5.color = NAPinColorRed;
    
	[self.mapView addAnnotation:annotation_5 animated:YES];
     */
    
    
    // Listener
    [WaveListener sharedWaveListener].listenedActionDelegate = self;
    [[WaveListener sharedWaveListener] startListening];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)playSuccessSound {
    
    if (self.successPlayer == nil) {
        
        NSError *error = nil;
        self.successPlayer = [[[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"success_1" withExtension:@"wav"] error:&error] autorelease];
        
        [self.successPlayer setVolume:1.0];
        
        if (error) {
            
            NSLog(@"successPlayer init error....%@",[error localizedDescription]);
            
        } else {
            
            self.successPlayer.delegate = self;
            
            
            if ([self isAirPlayActive]) {
                
                UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_None;
                AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute,sizeof(audioRouteOverride), &audioRouteOverride);
                
            } else {
                
                UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
                AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute,sizeof(audioRouteOverride), &audioRouteOverride);
            }
            
            [self.successPlayer prepareToPlay];
        }
    }
    
    [self.successPlayer play];
}

- (BOOL)isAirPlayActive{
    CFDictionaryRef currentRouteDescriptionDictionary = nil;
    UInt32 dataSize = sizeof(currentRouteDescriptionDictionary);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRouteDescription, &dataSize, &currentRouteDescriptionDictionary);
    if (currentRouteDescriptionDictionary) {
        CFArrayRef outputs = (CFArrayRef)CFDictionaryGetValue(currentRouteDescriptionDictionary, kAudioSession_AudioRouteKey_Outputs);
        if(CFArrayGetCount(outputs) > 0) {
            CFDictionaryRef currentOutput = (CFDictionaryRef)CFArrayGetValueAtIndex(outputs, 0);
            CFStringRef outputType = (CFStringRef)CFDictionaryGetValue(currentOutput, kAudioSession_AudioRouteKey_Type);
            return (CFStringCompare(outputType, kAudioSessionOutputRoute_AirPlay, 0) == kCFCompareEqualTo);
        }
    }
    
    return NO;
}

#pragma mark - ListenedActionDelegate

- (void)listenedAction:(NSString *)resultCode {
    
    NSString *geoHashString = @"69lmd24npf";
    
    if (![GeoHash verifyHash:geoHashString]) {
        
        [[WaveListener sharedWaveListener] setListening:YES];
        
    }else {
        
        [self playSuccessSound];
        [[WaveListener sharedWaveListener] setListening:YES];
        
        GHArea *point = [GeoHash areaForHash:geoHashString];
        
        GHArea *area = [GeoHash areaForHash:[geoHashString substringWithRange:NSMakeRange(0, 1)]];
        
        NSLog(@"\nlatitude.max : %f", [area.latitude.max floatValue]);
        NSLog(@"latitude.min : %f", [area.latitude.min floatValue]);
        NSLog(@"longitude.max : %f", [area.longitude.max floatValue]);
        NSLog(@"longitude.min : %f", [area.longitude.min floatValue]);
        
        int pixel_x_max = ([area.latitude.max floatValue] + 180.0) * [_mapView getMapImage].size.width / 360.0;
        int pixel_x_min = ([area.latitude.min floatValue] + 180.0) * [_mapView getMapImage].size.width / 360.0;
        int pixel_y_max = (90.0 - [area.longitude.max floatValue]) * [_mapView getMapImage].size.height / 180.0;
        int pixel_y_min = (90.0 - [area.longitude.min floatValue]) * [_mapView getMapImage].size.height / 180.0;
        
        NSLog(@"pixel_x_max : %d", pixel_x_max);
        NSLog(@"pixel_x_min : %d", pixel_x_min);
        NSLog(@"pixel_y_max : %d", pixel_y_max);
        NSLog(@"pixel_y_min : %d", pixel_y_min);
        
        int p_x = (([point.latitude.max floatValue]+[point.latitude.min floatValue])/2.0 + 180.0) * [_mapView getMapImage].size.width / 360.0 + 1;
        int p_y = (90.0 - ([point.longitude.max floatValue]+[point.longitude.min floatValue])/2.0) * [_mapView getMapImage].size.height / 180.0 +1;
        
        NAAnnotation * annotation = [NAAnnotation annotationWithPoint:CGPointMake(p_x, p_y)];
        annotation.title = @"3号会议室";
        annotation.color = NAPinColorRed;
        
        [self.mapView addAnnotation:annotation animated:YES];
    }
}

@end
