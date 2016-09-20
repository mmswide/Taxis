//
//  AppManager.h
//  Taxis
//
//  Created by Ricardo Hurla on 20/08/2016.
//  Copyright © 2016 rihurla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "User.h"

@protocol AppManagerDelegate;

typedef void(^CompletionHandler)(id result, NSError * error);

@interface AppManager : NSObject

@property(nonatomic, assign) id<AppManagerDelegate> delegate;

+ (instancetype)sharedManager;

//Start the app connection check with the internet
- (void)startConnectionMonitoring;
//Stop the app connection check with the internet
- (void)stopConnectionMonitoring;
//Saves the user on the Defauts
- (void)persistUser:(User *)user completionHandler:(CompletionHandler)completionHandler;
//Retreive the user saved on the Defaults
- (void)getRegisteredUserWithcompletionHandler:(CompletionHandler)completionHandler;


@end

@protocol AppManagerDelegate <NSObject>

@optional

//Provides the updates on the connection status
- (void)didUpdateConnectionStatus:(NSNumber*)status;

@end