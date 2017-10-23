//
//  UIView+Borders.m
//
//  Created by Aaron Ng on 12/28/13.
//  Copyright (c) 2013 Delve. All rights reserved.
//

#import "UIView+Borders.h"


@implementation UIView(Borders)

//////////
// Top
//////////

-(CALayer*)createTopBorderWithHeight: (CGFloat)height andColor:(UIColor*)color{
    return [self getOneSidedBorderWithFrame:CGRectMake(0, 0, self.frame.size.width, height) andColor:color];
}

-(UIView*)createViewBackedTopBorderWithHeight: (CGFloat)height andColor:(UIColor*)color{
    return [self getViewBackedOneSidedBorderWithFrame:CGRectMake(0, 0, self.frame.size.width, height) andColor:color];
}

-(void)addTopBorderWithHeight: (CGFloat)height andColor:(UIColor*)color{
    [self addOneSidedBorderWithFrame:CGRectMake(0, 0, self.frame.size.width, height) andColor:color];
}

-(void)addViewBackedTopBorderWithHeight: (CGFloat)height andColor:(UIColor*)color{
    [self addViewBackedOneSidedBorderWithFrame:CGRectMake(0, 0, self.frame.size.width, height) andColor:color];
}


//////////
// Top + Offset
//////////

-(CALayer*)createTopBorderWithHeight: (CGFloat)height color:(UIColor*)color leftOffset:(CGFloat)leftOffset rightOffset:(CGFloat)rightOffset andTopOffset:(CGFloat)topOffset {
    // Subtract the bottomOffset from the height and the thickness to get our final y position.
    // Add a left offset to our x to get our x position.
    // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
    return [self getOneSidedBorderWithFrame:CGRectMake(0 + leftOffset, 0 + topOffset, self.frame.size.width - leftOffset - rightOffset, height) andColor:color];
}

-(UIView*)createViewBackedTopBorderWithHeight: (CGFloat)height color:(UIColor*)color leftOffset:(CGFloat)leftOffset rightOffset:(CGFloat)rightOffset andTopOffset:(CGFloat)topOffset {
    return [self getViewBackedOneSidedBorderWithFrame:CGRectMake(0 + leftOffset, 0 + topOffset, self.frame.size.width - leftOffset - rightOffset, height) andColor:color];
}

-(void)addTopBorderWithHeight: (CGFloat)height color:(UIColor*)color leftOffset:(CGFloat)leftOffset rightOffset:(CGFloat)rightOffset andTopOffset:(CGFloat)topOffset {
    // Add leftOffset to our X to get start X position.
    // Add topOffset to Y to get start Y position
    // Subtract left offset from width to negate shifting from leftOffset.
    // Subtract rightoffset from width to set end X and Width.
    [self addOneSidedBorderWithFrame:CGRectMake(0 + leftOffset, 0 + topOffset, self.frame.size.width - leftOffset - rightOffset, height) andColor:color];
}

-(void)addViewBackedTopBorderWithHeight: (CGFloat)height color:(UIColor*)color leftOffset:(CGFloat)leftOffset rightOffset:(CGFloat)rightOffset andTopOffset:(CGFloat)topOffset {
    [self addViewBackedOneSidedBorderWithFrame:CGRectMake(0 + leftOffset, 0 + topOffset, self.frame.size.width - leftOffset - rightOffset, height) andColor:color];
}


//////////
// Right
//////////

-(CALayer*)createRightBorderWithWidth: (CGFloat)width andColor:(UIColor*)color{
    return [self getOneSidedBorderWithFrame:CGRectMake(self.frame.size.width-width, 0, width, self.frame.size.height) andColor:color];
}

-(UIView*)createViewBackedRightBorderWithWidth: (CGFloat)width andColor:(UIColor*)color{
    return [self getViewBackedOneSidedBorderWithFrame:CGRectMake(self.frame.size.width-width, 0, width, self.frame.size.height) andColor:color];
}

-(void)addRightBorderWithWidth: (CGFloat)width andColor:(UIColor*)color{
    [self addOneSidedBorderWithFrame:CGRectMake(self.frame.size.width-width, 0, width, self.frame.size.height) andColor:color];
}

-(void)addViewBackedRightBorderWithWidth: (CGFloat)width andColor:(UIColor*)color{
    [self addViewBackedOneSidedBorderWithFrame:CGRectMake(self.frame.size.width-width, 0, width, self.frame.size.height) andColor:color];
}



//////////
// Right + Offset
//////////

-(CALayer*)createRightBorderWithWidth: (CGFloat)width color:(UIColor*)color rightOffset:(CGFloat)rightOffset topOffset:(CGFloat)topOffset andBottomOffset:(CGFloat)bottomOffset{
    
    // Subtract bottomOffset from the height to get our end.
    return [self getOneSidedBorderWithFrame:CGRectMake(self.frame.size.width-width-rightOffset, 0 + topOffset, width, self.frame.size.height - topOffset - bottomOffset) andColor:color];
}

-(UIView*)createViewBackedRightBorderWithWidth: (CGFloat)width color:(UIColor*)color rightOffset:(CGFloat)rightOffset topOffset:(CGFloat)topOffset andBottomOffset:(CGFloat)bottomOffset{
    return [self getViewBackedOneSidedBorderWithFrame:CGRectMake(self.frame.size.width-width-rightOffset, 0 + topOffset, width, self.frame.size.height - topOffset - bottomOffset) andColor:color];
}

-(void)addRightBorderWithWidth: (CGFloat)width color:(UIColor*)color rightOffset:(CGFloat)rightOffset topOffset:(CGFloat)topOffset andBottomOffset:(CGFloat)bottomOffset{
    
    // Subtract the rightOffset from our width + thickness to get our final x position.
    // Add topOffset to our y to get our start y position.
    // Subtract topOffset from our height, so our border doesn't extend past teh view.
    // Subtract bottomOffset from the height to get our end.
    [self addOneSidedBorderWithFrame:CGRectMake(self.frame.size.width-width-rightOffset, 0 + topOffset, width, self.frame.size.height - topOffset - bottomOffset) andColor:color];
}

-(void)addViewBackedRightBorderWithWidth: (CGFloat)width color:(UIColor*)color rightOffset:(CGFloat)rightOffset topOffset:(CGFloat)topOffset andBottomOffset:(CGFloat)bottomOffset{
    [self addViewBackedOneSidedBorderWithFrame:CGRectMake(self.frame.size.width-width-rightOffset, 0 + topOffset, width, self.frame.size.height - topOffset - bottomOffset) andColor:color];
}


//////////
// Bottom
//////////

-(CALayer*)createBottomBorderWithHeight: (CGFloat)height andColor:(UIColor*)color{
    return [self getOneSidedBorderWithFrame:CGRectMake(0, self.frame.size.height-height, self.frame.size.width, height) andColor:color];
}

-(UIView*)createViewBackedBottomBorderWithHeight: (CGFloat)height andColor:(UIColor*)color{
    return [self getViewBackedOneSidedBorderWithFrame:CGRectMake(0, self.frame.size.height-height, self.frame.size.width, height) andColor:color];
}

-(void)addBottomBorderWithHeight: (CGFloat)height andColor:(UIColor*)color{
    [self addOneSidedBorderWithFrame:CGRectMake(0, self.frame.size.height-height, self.frame.size.width, height) andColor:color];
}

-(void)addViewBackedBottomBorderWithHeight: (CGFloat)height andColor:(UIColor*)color{
    [self addViewBackedOneSidedBorderWithFrame:CGRectMake(0, self.frame.size.height-height, self.frame.size.width, height) andColor:color];
}


//////////
// Bottom + Offset
//////////

-(CALayer*)createBottomBorderWithHeight: (CGFloat)height color:(UIColor*)color leftOffset:(CGFloat)leftOffset rightOffset:(CGFloat)rightOffset andBottomOffset:(CGFloat)bottomOffset {
    // Subtract the bottomOffset from the height and the thickness to get our final y position.
    // Add a left offset to our x to get our x position.
    // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
    return [self getOneSidedBorderWithFrame:CGRectMake(0 + leftOffset, self.frame.size.height-height-bottomOffset, self.frame.size.width - leftOffset - rightOffset, height) andColor:color];
}

-(UIView*)createViewBackedBottomBorderWithHeight: (CGFloat)height color:(UIColor*)color leftOffset:(CGFloat)leftOffset rightOffset:(CGFloat)rightOffset andBottomOffset:(CGFloat)bottomOffset{
    return [self getViewBackedOneSidedBorderWithFrame:CGRectMake(0 + leftOffset, self.frame.size.height-height-bottomOffset, self.frame.size.width - leftOffset - rightOffset, height) andColor:color];
}

-(void)addBottomBorderWithHeight: (CGFloat)height color:(UIColor*)color leftOffset:(CGFloat)leftOffset rightOffset:(CGFloat)rightOffset andBottomOffset:(CGFloat)bottomOffset {
    // Subtract the bottomOffset from the height and the thickness to get our final y position.
    // Add a left offset to our x to get our x position.
    // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
    [self addOneSidedBorderWithFrame:CGRectMake(0 + leftOffset, self.frame.size.height-height-bottomOffset, self.frame.size.width - leftOffset - rightOffset, height) andColor:color];
}

-(void)addViewBackedBottomBorderWithHeight: (CGFloat)height color:(UIColor*)color leftOffset:(CGFloat)leftOffset rightOffset:(CGFloat)rightOffset andBottomOffset:(CGFloat)bottomOffset{
    [self addViewBackedOneSidedBorderWithFrame:CGRectMake(0 + leftOffset, self.frame.size.height-height-bottomOffset, self.frame.size.width - leftOffset - rightOffset, height) andColor:color];
}



//////////
// Left
//////////

-(CALayer*)createLeftBorderWithWidth: (CGFloat)width andColor:(UIColor*)color{
    return [self getOneSidedBorderWithFrame:CGRectMake(0, 0, width, self.frame.size.height) andColor:color];
}



-(UIView*)createViewBackedLeftBorderWithWidth: (CGFloat)width andColor:(UIColor*)color{
    return [self getViewBackedOneSidedBorderWithFrame:CGRectMake(0, 0, width, self.frame.size.height) andColor:color];
}

-(void)addLeftBorderWithWidth: (CGFloat)width andColor:(UIColor*)color{
    [self addOneSidedBorderWithFrame:CGRectMake(0, 0, width, self.frame.size.height) andColor:color];
}



-(void)addViewBackedLeftBorderWithWidth: (CGFloat)width andColor:(UIColor*)color{
    [self addViewBackedOneSidedBorderWithFrame:CGRectMake(0, 0, width, self.frame.size.height) andColor:color];
}


- (CAGradientLayer *)createGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor direction:(int)direction startScale:(CGFloat)startScale endScale:(CGFloat)endScale
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[endColor CGColor], (id)[startColor CGColor], nil];
    
    switch (direction) {
        case 1:
        {
            gradient.startPoint = CGPointMake(0.5, 1);
            gradient.endPoint = CGPointMake(0.5,0);
        }
            break;
        case 2:
        {
            gradient.startPoint = CGPointMake(0.5, 0);
            gradient.endPoint = CGPointMake(0.5,1);
        }
            break;
        case 3:
        {
            gradient.startPoint = CGPointMake(1, 0.5);
            gradient.endPoint = CGPointMake(0,0.5);
        }
            break;
        case 4:
        {
            gradient.startPoint = CGPointMake(0, 0.5);
            gradient.endPoint = CGPointMake(1,0.5);
        }
            break;
        default:
            break;
    }
    gradient.locations = @[@(startScale),@(endScale)];
    
    [self.layer insertSublayer:gradient atIndex:0];
    
    return gradient;
}

- (CAGradientLayer *)createGradientWithColors:(NSArray <UIColor *> *)colors colorStartEndScales:(NSArray <NSNumber *> *)colorStartEndScales direction:(int)direction {
    if (colors.count != colorStartEndScales.count) return NULL;
    
    NSMutableArray *tempColors = [NSMutableArray arrayWithCapacity:colors.count];
    for (UIColor *color in colors) {
        [tempColors addObject:(id)color.CGColor];
    }
    // 马上释放内存
    colors = nil;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = tempColors;
    
    switch (direction) {
        case 1:
        {
            gradient.startPoint = CGPointMake(0.5, 0);
            gradient.endPoint = CGPointMake(0.5,1);
        }
            break;
        case 2:
        {
            gradient.startPoint = CGPointMake(0.5, 1);
            gradient.endPoint = CGPointMake(0.5,0);
        }
            break;
        case 3:
        {
            gradient.startPoint = CGPointMake(0, 0.5);
            gradient.endPoint = CGPointMake(1,0.5);
        }
            break;
        case 4:
        {
            gradient.startPoint = CGPointMake(1, 0.5);
            gradient.endPoint = CGPointMake(0,0.5);
        }
            break;
        default:
            break;
    }
    
    gradient.locations = colorStartEndScales;
    
    [self.layer insertSublayer:gradient atIndex:0];
    
    return gradient;
}



//////////
// Left + Offset
//////////

-(CALayer*)createLeftBorderWithWidth: (CGFloat)width color:(UIColor*)color leftOffset:(CGFloat)leftOffset topOffset:(CGFloat)topOffset andBottomOffset:(CGFloat)bottomOffset {
    return [self getOneSidedBorderWithFrame:CGRectMake(0 + leftOffset, 0 + topOffset, width, self.frame.size.height - topOffset - bottomOffset) andColor:color];
}



-(UIView*)createViewBackedLeftBorderWithWidth: (CGFloat)width color:(UIColor*)color leftOffset:(CGFloat)leftOffset topOffset:(CGFloat)topOffset andBottomOffset:(CGFloat)bottomOffset{
    return [self getViewBackedOneSidedBorderWithFrame:CGRectMake(0 + leftOffset, 0 + topOffset, width, self.frame.size.height - topOffset - bottomOffset) andColor:color];
}


-(void)addLeftBorderWithWidth: (CGFloat)width color:(UIColor*)color leftOffset:(CGFloat)leftOffset topOffset:(CGFloat)topOffset andBottomOffset:(CGFloat)bottomOffset {
    [self addOneSidedBorderWithFrame:CGRectMake(0 + leftOffset, 0 + topOffset, width, self.frame.size.height - topOffset - bottomOffset) andColor:color];
}



-(void)addViewBackedLeftBorderWithWidth: (CGFloat)width color:(UIColor*)color leftOffset:(CGFloat)leftOffset topOffset:(CGFloat)topOffset andBottomOffset:(CGFloat)bottomOffset{
    [self addViewBackedOneSidedBorderWithFrame:CGRectMake(0 + leftOffset, 0 + topOffset, width, self.frame.size.height - topOffset - bottomOffset) andColor:color];
}



//////////
// Private: Our methods call these to add their borders.
//////////

-(void)addOneSidedBorderWithFrame:(CGRect)frame andColor:(UIColor*)color
{
    CALayer *border = [CALayer layer];
    border.frame = frame;
    [border setBackgroundColor:color.CGColor];
    [self.layer addSublayer:border];
}

-(CALayer*)getOneSidedBorderWithFrame:(CGRect)frame andColor:(UIColor*)color
{
    CALayer *border = [CALayer layer];
    border.frame = frame;
    [border setBackgroundColor:color.CGColor];
    return border;
}


-(void)addViewBackedOneSidedBorderWithFrame:(CGRect)frame andColor:(UIColor*)color
{
    UIView *border = [[UIView alloc]initWithFrame:frame];
    [border setBackgroundColor:color];
    [self addSubview:border];
}

-(UIView*)getViewBackedOneSidedBorderWithFrame:(CGRect)frame andColor:(UIColor*)color
{
    UIView *border = [[UIView alloc]initWithFrame:frame];
    [border setBackgroundColor:color];
    return border;
}

///-------------
/// Dash Border
///-------------
-(void)createDashBordersWithWidth:(CGFloat)width color:(UIColor*)color horizontalTotal:(int)horizontalTotal verticalTotal:(int)verticalTotal {
    CAShapeLayer *border = [CAShapeLayer layer];
    border.lineWidth = width;
    border.strokeColor = color.CGColor;
    border.fillColor = nil;
    border.lineCap = kCALineCapSquare;
    int dashLineWidth1 = CGRectGetWidth(self.bounds)/horizontalTotal;
    int dashLineWidth2 = CGRectGetHeight(self.bounds)/verticalTotal;
    int edgeDashLineWidth1 = (CGRectGetWidth(self.bounds)-(horizontalTotal-2)*dashLineWidth1)/2;
    int edgeDashLineWidth2 = (CGRectGetHeight(self.bounds)-(verticalTotal-2)*dashLineWidth2)/2;
    
    NSMutableArray *lineDashPattern = [NSMutableArray array];
    for (int i=0; i<2; i++) {
        [lineDashPattern addObject:[NSNumber numberWithInt:edgeDashLineWidth1]];
        for (int j=0; j<horizontalTotal-2; j++) {
            [lineDashPattern addObject:[NSNumber numberWithInt:dashLineWidth1]];
        }
        [lineDashPattern addObject:[NSNumber numberWithInt:edgeDashLineWidth1]];
        [lineDashPattern addObject:@(0)];
        [lineDashPattern addObject:[NSNumber numberWithInt:edgeDashLineWidth2]];
        for (int j=0; j<verticalTotal-2; j++) {
            [lineDashPattern addObject:[NSNumber numberWithInt:dashLineWidth2]];
        }
        [lineDashPattern addObject:[NSNumber numberWithInt:edgeDashLineWidth2]];
        [lineDashPattern addObject:@(0)];
    }
    border.lineDashPattern = lineDashPattern;
    border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    border.frame = self.bounds;
    [self.layer addSublayer:border];
}

-(void)createDashBordersWithWidth:(CGFloat)width color:(UIColor*)color {
    [self createDashBordersWithWidth:width color:color horizontalTotal:11 verticalTotal:11];
}

-(void)createLeftDashBorderWithWidth:(CGFloat)width color:(UIColor*)color lineWidth:(CGFloat)lineWidth spaceWidth:(CGFloat)spaceWidth topOffset:(CGFloat)topOffset bottomOffset:(CGFloat)bottomOffset {

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:(CGPoint){ 0, topOffset }];
    [path addLineToPoint:(CGPoint){ 0, CGRectGetHeight(self.bounds) - bottomOffset}];

    for (CALayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            if (!CGPathEqualToPath(path.CGPath, [(CAShapeLayer *)layer path])){
                CAShapeLayer *shapeLayer = (CAShapeLayer *)layer;
                shapeLayer.path = path.CGPath;
            }
            return;
       }
    }
    CAShapeLayer *border = [CAShapeLayer layer];
    border.lineWidth = width;
    border.strokeColor = color.CGColor;
    border.fillColor = nil;
    border.strokeStart = 0.f; //-CGRectGetHeight(self.bounds);
    border.lineJoin = kCALineJoinRound;
    border.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:lineWidth],[NSNumber numberWithInt:spaceWidth ], nil];
    border.path = path.CGPath;
    
    [self.layer addSublayer:border];
}

-(void)createBottomDashBorderWithWidth:(CGFloat)width color:(UIColor*)color lineWidth:(CGFloat)lineWidth spaceWidth:(CGFloat)spaceWidth leftOffset:(CGFloat)leftOffset rightOffset:(CGFloat)rightOffset {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:(CGPoint){ leftOffset, CGRectGetHeight(self.bounds) }];
    [path addLineToPoint:(CGPoint){ CGRectGetWidth(self.bounds) - rightOffset, CGRectGetHeight(self.bounds) }];
    
    for (CALayer *layer in self.layer.sublayers) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            if (!CGPathEqualToPath(path.CGPath, [(CAShapeLayer *)layer path])){
                CAShapeLayer *shapeLayer = (CAShapeLayer *)layer;
                shapeLayer.path = path.CGPath;
            }
            return;
        }
    }
    
    CAShapeLayer *border = [CAShapeLayer layer];
    border.lineWidth = width;
    border.strokeColor = color.CGColor;
    border.fillColor = nil;
    border.strokeStart = 0.f;
    border.lineJoin = kCALineJoinRound;
    border.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:lineWidth],[NSNumber numberWithInt:spaceWidth ], nil];
    border.path = path.CGPath;
    
    [self.layer addSublayer:border];
}

///-------------
/// Shadow
///-------------
- (void)addBottomShadow {
    [self addShadowOffset:CGSizeMake(0, 1.f) shadowRadius:1.f shadowOpacity:0.15f];
}

- (void)removeBottomShadow {
    self.layer.shadowColor = nil;
    self.layer.shadowOpacity = 0;
    self.layer.shadowOffset = CGSizeMake(0, -3);
    self.layer.shadowRadius = 0;
    self.layer.masksToBounds = YES;
}

- (void)addTopShadow {
    [self addShadowOffset:CGSizeMake(0, -1.f) shadowRadius:1.f shadowOpacity:0.15f];
}

-(void)addBarBottomShadow {
    [self addShadowOffset:CGSizeMake(0, 2.f) shadowRadius:3.f shadowOpacity:0.3f];
}

-(void)addBarTopShadow {
    [self addShadowOffset:CGSizeMake(0, -2.f) shadowRadius:3.f shadowOpacity:0.3f];
}

-(void)addShadowOffset:(CGSize)size shadowRadius:(CGFloat)radius shadowOpacity:(CGFloat)opacity {
    [self addShadowOffset:size shadowColor:[UIColor blackColor] shadowRadius:radius shadowOpacity:opacity];
}

-(void)addShadowOffset:(CGSize)size shadowColor:(UIColor *)color shadowRadius:(CGFloat)radius shadowOpacity:(CGFloat)opacity {
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowOffset = size;
    self.layer.shadowRadius = radius;
    self.layer.masksToBounds = NO;
}

@end
