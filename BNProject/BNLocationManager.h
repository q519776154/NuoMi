//
//  BNLocationManager.h
//  BNProject
//
//  Created by qianfeng on 16/9/20.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
/**
 *  定位成功回调
 */
typedef void(^LocationSuccessCallback)(CLPlacemark *placemark);

@interface BNLocationManager : NSObject

+ (instancetype)sharedLocationManager;

- (BOOL)locationServicesnabled;

- (void)startLocationService:(LocationSuccessCallback)callback;

@end
