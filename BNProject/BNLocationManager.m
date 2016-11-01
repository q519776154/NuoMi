//
//  BNLocationManager.m
//  BNProject
//
//  Created by qianfeng on 16/9/20.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "BNLocationManager.h"
#import "UIDevice+Version.h"

@interface BNLocationManager ()<CLLocationManagerDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation BNLocationManager

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
        
        if ([UIDevice systemVersion] >= 8.0) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    return _locationManager;
}

+ (instancetype)sharedLocationManager
{
    static BNLocationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (BOOL)locationServicesnabled
{
    return [CLLocationManager locationServicesEnabled];
}

- (void)startLocationService:(LocationSuccessCallback)callback
{
    if (![self locationServicesnabled]) {
        return;
    }
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (locations.count == 0) {
        return;
    }
    [manager stopUpdatingLocation];
    
    CLLocation *loation = locations.firstObject;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:loation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0) {
            return;
        }
        CLPlacemark *plcaemark = placemarks.firstObject;
        NSString *city = plcaemark.locality;
        NSLog(@"%@",city);
    }];
}

@end











