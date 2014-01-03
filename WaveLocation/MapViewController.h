//
//  MapViewController.h
//  WaveLocation
//
//  Created by Littlebox222 on 13-12-30.
//  Copyright (c) 2013年 Littlebox222. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAMapView.h"
#import <AVFoundation/AVFoundation.h>
#import "WaveListener.h"
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController <ListenedActionDelegate, AVAudioPlayerDelegate>

@property (nonatomic, retain) AVAudioPlayer *successPlayer;
@property (nonatomic, retain) NAMapView *mapView;

- (void)playSuccessSound;

@end
