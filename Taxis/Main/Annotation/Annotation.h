//
//  Annotation.h
//  Taxis
//
//  Created by Ricardo Hurla on 21/08/2016.
//  Copyright © 2016 rihurla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface Annotation : NSObject <MKAnnotation> {
    
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
    BOOL isAddress;
}

@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign)BOOL isAddress;

@end
