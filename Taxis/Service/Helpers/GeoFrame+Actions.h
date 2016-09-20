//
//  GeoFrame+Actions.h
//  Taxis
//
//  Created by Ricardo Hurla on 8/17/16.
//  Copyright © 2016 rihurla. All rights reserved.
//

#import "GeoFrame.h"
#import <MapKit/MapKit.h>

@interface GeoFrame (Actions)

//Creates a geoFrame based on the rect provided by the mapView
- (GeoFrame *)getGeoFrameFromMapRect:(MKMapRect)mRect;

@end
