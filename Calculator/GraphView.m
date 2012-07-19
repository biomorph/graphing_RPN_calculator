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
#define UserDefaultsScaleKey   @"SCALE"
#define UserDefaultsOriginXKey @"ORIGIN_X"
#define UserDefaultsOriginYKey @"ORIGIN_Y"


//getting default scale for first run
- (CGFloat) scale
{
    if (!_scale){
        return DEFAULT_SCALE;
         
    }
    else return _scale;
}

//setting a scale and updating my NSUSerDefaults and redrawing everytime called(pinch gesture)
- (void) setScale:(CGFloat)scale
{
    if (scale != _scale){
        _scale = scale;
        [[NSUserDefaults standardUserDefaults] setFloat:_scale forKey:UserDefaultsScaleKey];
        [self setNeedsDisplay];

    }
    
}

//getting default scale for first run
- (CGPoint) origin
{
    if((_origin.x == 0.0) && (_origin.y == 0.0)) {
      _origin = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);  
        return _origin;
    }
    return _origin;
}

//setting a scale and updating my NSUSerDefaults and redrawing everytime called (pan and triple tap)
- (void) setOrigin:(CGPoint)origin
{
    if (CGPointEqualToPoint(origin, _origin) == NO) {
        _origin = origin;
        [[NSUserDefaults standardUserDefaults] setFloat:_origin.x forKey:UserDefaultsOriginXKey];
        [[NSUserDefaults standardUserDefaults] setFloat:_origin.y forKey:UserDefaultsOriginYKey];
        [self setNeedsDisplay];
    }
}

//method performing pinch gesture
- (void) pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged)||(gesture.state == UIGestureRecognizerStateEnded)){
        self.scale *= gesture.scale;
        gesture.scale = 1;

    }
}

//method performing pan gesture
- (void) pan:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged)||(gesture.state == UIGestureRecognizerStateEnded)){
        CGPoint translation = [gesture translationInView:self];
        self.origin =CGPointMake(self.origin.x+translation.x, self.origin.y+translation.y);
        [gesture setTranslation:CGPointZero inView:self];

    }
}

//method performing triple tap gesture
- (void) tripleTap:(UITapGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateEnded) && (gesture.numberOfTapsRequired == 3)) {
        CGPoint translation = [gesture locationInView:self];
        self.origin = CGPointMake(translation.x,translation.y);
    }
}


//I'm setting up my userdefaults in here and scale and origin for first time run
- (void) setup
{
    self.contentMode = UIViewContentModeRedraw;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    CGPoint midPoint; // center of our bounds in our coordinate system
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    NSDictionary* defaultUserDefaults =  [NSDictionary dictionaryWithObjectsAndKeys:
                                         [NSNumber numberWithFloat:1.0], UserDefaultsScaleKey,
                                         [NSNumber numberWithFloat:midPoint.x], UserDefaultsOriginXKey,
                                         [NSNumber numberWithFloat:midPoint.y], UserDefaultsOriginYKey,
                                         nil];
    
    [userDefaults registerDefaults:defaultUserDefaults];
    
    
    self.scale = [userDefaults floatForKey:UserDefaultsScaleKey];
    
    CGPoint origin = CGPointMake([userDefaults floatForKey:UserDefaultsOriginXKey],
                                 [userDefaults floatForKey:UserDefaultsOriginYKey]);
    self.origin = origin;
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


//custom draw rect method where I am going to plot line or dot graphs 
- (void)drawRect:(CGRect)rect
{
    //Make a context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Make a CGRect to pass to make axes
    CGContextSetLineWidth(context, 2.0);
    [[UIColor blueColor] set]; 
    [AxesDrawer drawAxesInRect:rect originAtPoint:self.origin scale:self.scale];
    CGFloat pixelNumber = [self contentScaleFactor]*self.bounds.size.width;
    
    if([[self.dotOrLine dotOrLine:self]isEqualToString:@"DotGraph"])
    {
        
        CGContextMoveToPoint(context,0, self.origin.y);
        
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
        else if ([[self.dotOrLine dotOrLine:self] isEqualToString:@"LineGraph"]) 
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
