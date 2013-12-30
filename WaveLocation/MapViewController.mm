//
//  MapViewController.m
//  WaveLocation
//
//  Created by Littlebox222 on 13-12-30.
//  Copyright (c) 2013年 Littlebox222. All rights reserved.
//

#import "MapViewController.h"
#import "NAMapView.h"
#import "NAAnnotation.h"

@interface MapViewController ()

@end

@implementation MapViewController

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
	
    
    NAMapView *mapView = [[NAMapView alloc] initWithFrame:self.view.bounds];
    
    mapView.backgroundColor  = [UIColor colorWithRed:0.000f green:0.475f blue:0.761f alpha:1.000f];
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    mapView.minimumZoomScale = 0.1f;
    mapView.maximumZoomScale = 2.5f;
    
    [mapView displayMap:[UIImage imageNamed:@"11"]];
    
    [self.view addSubview:mapView];
    
    
    NAAnnotation *annotation_1 = [NAAnnotation annotationWithPoint:CGPointMake(600.0f, 830.0f)];
    annotation_1.title = @"工位-1";
    annotation_1.color = NAPinColorGreen;
    
    [mapView addAnnotation:annotation_1 animated:NO];
    
    NAAnnotation * annotation_2 = [NAAnnotation annotationWithPoint:CGPointMake(540.0f, 830.0f)];
	annotation_2.title = @"工位-2";
    annotation_2.color = NAPinColorGreen;
    
	[mapView addAnnotation:annotation_2 animated:YES];
    
	NAAnnotation * annotation_3 = [NAAnnotation annotationWithPoint:CGPointMake(680.0f, 830.0f)];
	annotation_3.title = @"工位-3";
    annotation_3.color = NAPinColorGreen;
    
	[mapView addAnnotation:annotation_3 animated:NO];
    
    NAAnnotation *annotation_4 = [NAAnnotation annotationWithPoint:CGPointMake(440.0f, 690.0f)];
    annotation_4.title = @"吸烟室";
    annotation_4.color = NAPinColorPurple;
    
    [mapView addAnnotation:annotation_4 animated:NO];
    
    NAAnnotation * annotation_5 = [NAAnnotation annotationWithPoint:CGPointMake(1000.0f, 940.0f)];
	annotation_5.title = @"3号会议室";
    annotation_5.color = NAPinColorRed;
    
	[mapView addAnnotation:annotation_5 animated:YES];
    
    
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
    
    [self playSuccessSound];
    
    [[WaveListener sharedWaveListener] setListening:YES];
}

@end
