//
//  GeoFrame+Actions.m
//  Taxis
//
//  Created by Ricardo Hurla on 8/17/16.
//  Copyright © 2016 rihurla. All rights reserved.
//

#import "GeoFrame+Actions.h"

@implementation GeoFrame (Actions)

- (GeoFrame *)getGeoFrameFromMapRect:(MKMapRect)mRect {
    
    CLLocationCoordinate2D bottomLeft = [self getSWCoordinate:mRect];
    CLLocationCoordinate2D topRight = [self getNECoordinate:mRect];
    
    self.SWlatitude = [NSNumber numberWithDouble:bottomLeft.latitude];
    self.SWlongitude = [NSNumber numberWithDouble:bottomLeft.longitude];
    self.NElatitude = [NSNumber numberWithDouble:topRight.latitude];
    self.NElongitude = [NSNumber numberWithDouble:topRight.longitude];
    
    return self;
}


-(CLLocationCoordinate2D)getNECoordinate:(MKMapRect)mRect{
    return [self getCoordinateFromMapRectanglePoint:MKMapRectGetMaxX(mRect) y:mRect.origin.y];
}
-(CLLocationCoordinate2D)getNWCoordinate:(MKMapRect)mRect{
    return [self getCoordinateFromMapRectanglePoint:MKMapRectGetMinX(mRect) y:mRect.origin.y];
}
-(CLLocationCoordinate2D)getSECoordinate:(MKMapRect)mRect{
    return [self getCoordinateFromMapRectanglePoint:MKMapRectGetMaxX(mRect) y:MKMapRectGetMaxY(mRect)];
}
-(CLLocationCoordinate2D)getSWCoordinate:(MKMapRect)mRect{
    return [self getCoordinateFromMapRectanglePoint:mRect.origin.x y:MKMapRectGetMaxY(mRect)];
}

-(CLLocationCoordinate2D)getCoordinateFromMapRectanglePoint:(double)x y:(double)y{
    MKMapPoint swMapPoint = MKMapPointMake(x, y);
    return MKCoordinateForMapPoint(swMapPoint);
}

@end
