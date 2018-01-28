//
//  LocationRequest.h
//  MSCDemo
//
//  Created by 侯效林 on 2017/5/31.
//
//

#ifndef LocationRequest_h
#define LocationRequest_h

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define IOS8_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending )

@interface LocationRequest : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *iFlyLocManager;
}

//request location info
- (void)locationAsynRequest;

//get location info
-(CLLocation *) getLocation;

@end


#endif /* LocationRequest_h */
