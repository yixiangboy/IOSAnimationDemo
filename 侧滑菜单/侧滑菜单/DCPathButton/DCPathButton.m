//
//  DCPathButton.m
//  DCPathButton
//
//  Created by tang dixi on 30/7/14.
//  Copyright (c) 2014 Tangdxi. All rights reserved.
//

#import "DCPathButton.h"
#import "DCPathCenterButton.h"

@interface DCPathButton ()<DCPathCenterButtonDelegate, DCPathItemButtonDelegate>

#pragma mark - Private Property

@property (strong, nonatomic) UIImage *centerImage;
@property (strong, nonatomic) UIImage *centerHighlightedImage;

@property (assign, nonatomic, getter = isBloom) BOOL bloom;

@property (assign, nonatomic) CGSize foldedSize;
@property (assign, nonatomic) CGSize bloomSize;

@property (assign, nonatomic) CGPoint foldCenter;
@property (assign, nonatomic) CGPoint bloomCenter;

@property (assign, nonatomic) CGPoint pathCenterButtonBloomCenter;

@property (assign, nonatomic) CGPoint expandCenter;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) DCPathCenterButton *pathCenterButton;
@property (strong, nonatomic) NSMutableArray *itemButtons;

@property (assign, nonatomic) SystemSoundID bloomSound;
@property (assign, nonatomic) SystemSoundID foldSound;
@property (assign, nonatomic) SystemSoundID selectedSound;


@end

@implementation DCPathButton

#pragma mark - Initialization

- (id)initWithCenterImage:(UIImage *)centerImage hilightedImage:(UIImage *)centerHighlightedImage
{
    if (self = [super init]) {
        
        // Configure center and high light center image
        //
        self.centerImage = centerImage;
        self.centerHighlightedImage = centerHighlightedImage;
        
        // Init button and image array
        //
        self.itemButtonImages = [[NSMutableArray alloc]init];
        self.itemButtonHighlightedImages = [[NSMutableArray alloc]init];
        self.itemButtons = [[NSMutableArray alloc]init];
        
        // Configure views
        //
        [self configureViewsLayout];
        
        // Configure sounds
        //
        [self configureSounds];
    }
    return self;
}

- (void)configureViewsLayout
{
    // Init some property only once
    //
    self.foldedSize = self.centerImage.size;
    self.bloomSize = [UIScreen mainScreen].bounds.size;
    
    self.bloom = NO;
    self.bloomRadius = 105.0f;
    
    // Configure the view's center, it will change after the frame folded or bloomed
    //景铭修改过了，原来self.foldCenter = CGPointMake(self.bloomSize.width / 2, self.bloomSize.height - 25.5f);
    self.foldCenter = CGPointMake(self.bloomSize.width / 2, self.bloomSize.height - 225.5f);
    self.bloomCenter = CGPointMake(self.bloomSize.width / 2, self.bloomSize.height / 2);
    
    // Configure the DCPathButton's origin frame
    //
    self.frame = CGRectMake(0, 0, self.foldedSize.width, self.foldedSize.height);
    self.center = self.foldCenter;
    
    // Configure center button
    //
    _pathCenterButton = [[DCPathCenterButton alloc]initWithImage:self.centerImage highlightedImage:self.centerHighlightedImage];
    _pathCenterButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _pathCenterButton.delegate = self;
    [self addSubview:_pathCenterButton];
    
    // Configure bottom view
    //
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bloomSize.width, self.bloomSize.height)];
    _bottomView.backgroundColor = [UIColor blackColor];
    _bottomView.alpha = 0.0f;
    
}


- (void)configureSounds
{
    // Configure bloom sound
    //
    NSString *bloomSoundPath = [[NSBundle mainBundle]pathForResource:@"bloom" ofType:@"caf"];
    NSURL *bloomSoundURL = [NSURL fileURLWithPath:bloomSoundPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)bloomSoundURL, &_bloomSound);
    
    // Configure fold sound
    //
    NSString *foldSoundPath = [[NSBundle mainBundle]pathForResource:@"fold" ofType:@"caf"];
    NSURL *foldSoundURL = [NSURL fileURLWithPath:foldSoundPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)foldSoundURL, &_foldSound);
    
    // Configure selected sound
    //
    NSString *selectedSoundPath = [[NSBundle mainBundle]pathForResource:@"selected" ofType:@"caf"];
    NSURL *selectedSoundURL = [NSURL fileURLWithPath:selectedSoundPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)selectedSoundURL, &_selectedSound);
    
}

#pragma mark - Configure Center Button Images

- (void)setCenterImage:(UIImage *)centerImage
{
    if (!centerImage) {
        NSLog(@"Load center image failed ... ");
        return ;
    }
    _centerImage = centerImage;
}

- (void)setCenterHighlightedImage:(UIImage *)highlightedImage
{
    if (!highlightedImage) {
        NSLog(@"Load highted image failed ... ");
        return ;
    }
    _centerHighlightedImage = highlightedImage;
}

#pragma mark - Configure Expand Center Point

- (void)setPathCenterButtonBloomCenter:(CGPoint)centerButtonBloomCenter
{
    // Just set the bloom center once
    //
    if (_pathCenterButtonBloomCenter.x == 0) {
        _pathCenterButtonBloomCenter = centerButtonBloomCenter;
    }
    return ;
}

#pragma mark - Expand Status

- (BOOL)isBloom
{
    return _bloom;
}

#pragma mark - Center Button Delegate

- (void)centerButtonTapped
{
    self.isBloom? [self pathCenterButtonFold] : [self pathCenterButtonBloom];
}

#pragma mark - Caculate The Item's End Point

- (CGPoint)createEndPointWithRadius:(CGFloat)itemExpandRadius andAngel:(CGFloat)angel
{
    return CGPointMake(self.pathCenterButtonBloomCenter.x - cosf(angel * M_PI) * itemExpandRadius,
                       self.pathCenterButtonBloomCenter.y - sinf(angel * M_PI) * itemExpandRadius);
}

#pragma mark - Center Button Fold

- (void)pathCenterButtonFold
{
    // Play fold sound
    //
    AudioServicesPlaySystemSound(self.foldSound);
    
    // Load item buttons from array
    //
    for (int i = 1; i <= self.itemButtons.count; i++) {
        
        DCPathItemButton *itemButton = self.itemButtons[i - 1];
        
        CGFloat currentAngel = i / ((CGFloat)self.itemButtons.count + 1);
        CGPoint farPoint = [self createEndPointWithRadius:self.bloomRadius + 5.0f andAngel:currentAngel];
        
        CAAnimationGroup *foldAnimation = [self foldAnimationFromPoint:itemButton.center withFarPoint:farPoint];
        
        [itemButton.layer addAnimation:foldAnimation forKey:@"foldAnimation"];
        itemButton.center = self.pathCenterButtonBloomCenter;
        
    }
    
    [self bringSubviewToFront:self.pathCenterButton];
    
    // Resize the DCPathButton's frame to the foled frame and remove the item buttons
    //
    [self resizeToFoldedFrame];
    
}

- (void)resizeToFoldedFrame
{
    [UIView animateWithDuration:0.0618f * 3
                          delay:0.0618f * 2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _pathCenterButton.transform = CGAffineTransformMakeRotation(0);
                     }
                     completion:nil];
    
    [UIView animateWithDuration:0.1f
                          delay:0.35f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _bottomView.alpha = 0.0f;
                     }
                     completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (DCPathItemButton *itemButton in self.itemButtons) {
            [itemButton performSelector:@selector(removeFromSuperview)];
        }
        
        self.frame = CGRectMake(0, 0, self.foldedSize.width, self.foldedSize.height);
        self.center = self.foldCenter;
        self.pathCenterButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        
        [self.bottomView removeFromSuperview];
    });
    
    _bloom = NO;
}

- (CAAnimationGroup *)foldAnimationFromPoint:(CGPoint)endPoint withFarPoint:(CGPoint)farPoint
{
    // 1.Configure rotation animation
    //
    CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.values = @[@(0), @(M_PI), @(M_PI * 2)];
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.duration = 0.35f;
    
    // 2.Configure moving animation
    //
    CAKeyframeAnimation *movingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // Create moving path
    //
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, endPoint.x, endPoint.y);
    CGPathAddLineToPoint(path, NULL, farPoint.x, farPoint.y);
    CGPathAddLineToPoint(path, NULL, self.pathCenterButtonBloomCenter.x, self.pathCenterButtonBloomCenter.y);
    
    movingAnimation.keyTimes = @[@(0.0f), @(0.75), @(1.0)];
    
    movingAnimation.path = path;
    movingAnimation.duration = 0.35f;
    CGPathRelease(path);
    
    // 3.Merge animation together
    //
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    animations.animations = @[rotationAnimation, movingAnimation];
    animations.duration = 0.35f;
    
    return animations;
}

#pragma mark - Center Button Bloom

- (void)pathCenterButtonBloom
{
    // Play bloom sound
    //
    AudioServicesPlaySystemSound(self.bloomSound);
    
    // Configure center button bloom
    //
    // 1. Store the current center point to 'centerButtonBloomCenter
    //
    self.pathCenterButtonBloomCenter = self.center;
    
    // 2. Resize the DCPathButton's frame
    //
    self.frame = CGRectMake(0, 0, self.bloomSize.width, self.bloomSize.height);
    self.center = CGPointMake(self.bloomSize.width / 2, self.bloomSize.height / 2);
    
    [self insertSubview:self.bottomView belowSubview:self.pathCenterButton];
    
    // 3. Excute the bottom view alpha animation
    //
    [UIView animateWithDuration:0.0618f * 3
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _bottomView.alpha = 0.618f;
                     }
                     completion:nil];
    
    // 4. Excute the center button rotation animation
    //
    [UIView animateWithDuration:0.1575f
                     animations:^{
                         _pathCenterButton.transform = CGAffineTransformMakeRotation(-0.75f * M_PI);
                     }];
    
    self.pathCenterButton.center = self.pathCenterButtonBloomCenter;
    
    // 5. Excute the bloom animation
    //
    CGFloat basicAngel = 180 / (self.itemButtons.count + 1) ;
    
    for (int i = 1; i <= self.itemButtons.count; i++) {
        
        DCPathItemButton *pathItemButton = self.itemButtons[i - 1];
        
        pathItemButton.delegate = self;
        pathItemButton.tag = i - 1;
        pathItemButton.transform = CGAffineTransformMakeTranslation(1, 1);
        pathItemButton.alpha = 1.0f;
        
        // 1. Add pathItem button to the view
        //
        CGFloat currentAngel = (basicAngel * i)/180;
        
        pathItemButton.center = self.pathCenterButtonBloomCenter;
        
        [self insertSubview:pathItemButton belowSubview:self.pathCenterButton];
        
        // 2.Excute expand animation
        //
        CGPoint endPoint = [self createEndPointWithRadius:self.bloomRadius andAngel:currentAngel];
        CGPoint farPoint = [self createEndPointWithRadius:self.bloomRadius + 10.0f andAngel:currentAngel];
        CGPoint nearPoint = [self createEndPointWithRadius:self.bloomRadius - 5.0f andAngel:currentAngel];
        
        CAAnimationGroup *bloomAnimation = [self bloomAnimationWithEndPoint:endPoint
                                                                  andFarPoint:farPoint
                                                                andNearPoint:nearPoint];
        
        [pathItemButton.layer addAnimation:bloomAnimation forKey:@"bloomAnimation"];
        pathItemButton.center = endPoint;
        
    }
    
    _bloom = YES;

}

- (CAAnimationGroup *)bloomAnimationWithEndPoint:(CGPoint)endPoint andFarPoint:(CGPoint)farPoint andNearPoint:(CGPoint)nearPoint
{
    // 1.Configure rotation animation
    //
    CAKeyframeAnimation *rotationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.values = @[@(0.0), @(- M_PI), @(- M_PI * 1.5), @(- M_PI * 2)];
    rotationAnimation.duration = 0.3f;
    rotationAnimation.keyTimes = @[@(0.0), @(0.3), @(0.6), @(1.0)];
    
    // 2.Configure moving animation
    //
    CAKeyframeAnimation *movingAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    // Create moving path
    //
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.pathCenterButtonBloomCenter.x, self.pathCenterButtonBloomCenter.y);
    CGPathAddLineToPoint(path, NULL, farPoint.x, farPoint.y);
    CGPathAddLineToPoint(path, NULL, nearPoint.x, nearPoint.y);
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
    
    movingAnimation.path = path;
    movingAnimation.keyTimes = @[@(0.0), @(0.5), @(0.7), @(1.0)];
    movingAnimation.duration = 0.3f;
    CGPathRelease(path);
    
    // 3.Merge two animation together
    //
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    animations.animations = @[movingAnimation, rotationAnimation];
    animations.duration = 0.3f;
    animations.delegate = self;
    
    return animations;
}

#pragma mark - Add PathButton Item

- (void)addPathItems:(NSArray *)pathItemButtons
{
    [self.itemButtons addObjectsFromArray:pathItemButtons];
}

#pragma mark - DCPathButton Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Tap the bottom area, excute the fold animation
    [self pathCenterButtonFold];
}

#pragma mark - DCPathButton Item Delegate

- (void)itemButtonTapped:(DCPathItemButton *)itemButton
{
    if ([_delegate respondsToSelector:@selector(itemButtonTappedAtIndex:)]) {
        
        DCPathItemButton *selectedButton = self.itemButtons[itemButton.tag];
        
        // Play selected sound
        //
        AudioServicesPlaySystemSound(self.selectedSound);
        
        // Excute the explode animation when the item is seleted
        //
        [UIView animateWithDuration:0.0618f * 5
                         animations:^{
                             selectedButton.transform = CGAffineTransformMakeScale(3, 3);
                             selectedButton.alpha = 0.0f;
                         }];
        
        // Excute the dismiss animation when the item is unselected
        //
        for (int i = 0; i < self.itemButtons.count; i++) {
            if (i == selectedButton.tag) {
                continue;
            }
            DCPathItemButton *unselectedButton = self.itemButtons[i];
            [UIView animateWithDuration:0.0618f * 2
                             animations:^{
                                 unselectedButton.transform = CGAffineTransformMakeScale(0, 0);
                             }];
        }
        
        // Excute the delegate method
        //
        [_delegate itemButtonTappedAtIndex:itemButton.tag];
        
        // Resize the DCPathButton's frame
        //
        [self resizeToFoldedFrame];
    }
}

@end
