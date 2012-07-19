//
//  GraphView.m
//  Calculator
//
//  Created by Ravi Alla on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@interface GraphView()

@end

@implementation GraphView
@synthesize scale = _scale;
@synthesize origin = _origin;
@synthesize dataSource = _dataSource;
@synthesize dotOrLine = _dotOrLine;
#define DEFAULT_SCALE 1.0;

- (CGFloat) scale
{
    if (!_scale){
        return DEFAULT_SCALE;
    }
    else return _scale;
}

- (void) setScale:(CGFloat)scale
{
    if (scale != _scale){
        _scale = scale;
        [self setNeedsDisplay];

    }
    
}

- (CGPoint) origin
{
    if((_origin.x == 0.0) && (_origin.y == 0.0)) {
      _origin = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);  
        return _origin;
    }
    return _origin;
}

- (void) setOrigin:(CGPoint)origin
{
    if (CGPointEqualToPoint(origin, _origin) == NO) {
        _origin = origin;
        [self setNeedsDisplay];
    }
}

- (void) pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged)||(gesture.state == UIGestureRecognizerStateEnded)){
        self.scale *= gesture.scale;
        gesture.scale = 1;
    }
}

- (void) pan:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged)||(gesture.state == UIGestureRecognizerStateEnded)){
        CGPoint translation = [gesture translationInView:self];
        self.origin =CGPointMake(self.origin.x+translation.x, self.origin.y+translation.y);
        [gesture setTranslation:CGPointZero inView:self];

    }
}

- (void) tripleTap:(UITapGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateEnded) && (gesture.numberOfTapsRequired == 3)) {
        CGPoint translation = [gesture locationInView:self];
        //self.origin = CGPointMake(10, 10);
        self.origin = CGPointMake(translation.x,translation.y);
    
    }
}

- (void) setup
{
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    //Make a context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Make a CGRect to pass to make axes
    CGContextSetLineWidth(context, 2.0);
    [[UIColor blueColor] set];
    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:self.scale];
    CGFloat pixelNumber = [self contentScaleFactor]*self.bounds.size.width;
    
    if(![self.dotOrLine dotOrLine:self])
    {
        if (self.bounds.size.width < self.bounds.size.height) {
            CGContextMoveToPoint(context, 0, -self.origin.y);
        }
        else {
            CGContextMoveToPoint(context, -self.origin.x, 0);
        }
        
        for (float xValue = 0; xValue <= pixelNumber; xValue++) {
        UIGraphicsPushContext(context);
        CGPoint point = CGPointZero;
        point.x = xValue;
        double yValue = [self.dataSource graphPoints:self :(xValue-self.origin.x)/self.scale];
            point.y = self.origin.y - yValue*self.scale;
            CGContextAddLineToPoint(context, point.x, point.y);
        }
    CGContextStrokePath(context);
    }
        else if ([self.dotOrLine dotOrLine:self]) 
        {
            for (float xValue = 0; xValue <= pixelNumber; xValue++) {
                [[UIColor blueColor]set];
                UIGraphicsPushContext(context);
                CGPoint point;
                point.x = xValue;
                double yValue = [self.dataSource graphPoints:self :(xValue-self.origin.x)/self.scale];
                point.y = self.origin.y - yValue*self.scale;
                CGContextFillRect(context, CGRectMake(point.x,point.y,2,2));
                CGContextStrokePath(context);
            }
        
        }
        UIGraphicsPopContext();

    

}

@end
