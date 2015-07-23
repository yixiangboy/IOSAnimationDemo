//
//  MCFireworksView.m
//  MCFireworksButton
//
//  Created by Matthew Cheok on 17/3/14.
//  Copyright (c) 2014 Matthew Cheok. All rights reserved.
//

#import "MCFireworksView.h"

@interface MCFireworksView ()

@property (strong, nonatomic) NSArray *emitterCells;
@property (strong, nonatomic) CAEmitterLayer *chargeLayer;
@property (strong, nonatomic) CAEmitterLayer *explosionLayer;

@end

@implementation MCFireworksView

- (void)setup {
    self.clipsToBounds = NO;
    self.userInteractionEnabled = NO;

	CAEmitterCell *explosionCell = [CAEmitterCell emitterCell];
	explosionCell.name = @"explosion";
	explosionCell.alphaRange = 0.20;
	explosionCell.alphaSpeed = -1.0;

	explosionCell.lifetime = 0.7;
	explosionCell.lifetimeRange = 0.3;
	explosionCell.birthRate = 0;
	explosionCell.velocity = 40.00;
	explosionCell.velocityRange = 10.00;

	_explosionLayer = [CAEmitterLayer layer];
	_explosionLayer.name = @"emitterLayer";
	_explosionLayer.emitterShape = kCAEmitterLayerCircle;
	_explosionLayer.emitterMode = kCAEmitterLayerOutline;
	_explosionLayer.emitterSize = CGSizeMake(25, 0);
	_explosionLayer.emitterCells = @[explosionCell];
	_explosionLayer.renderMode = kCAEmitterLayerOldestFirst;
    _explosionLayer.masksToBounds = NO;
	_explosionLayer.seed = 1366128504;
	[self.layer addSublayer:_explosionLayer];
    
    CAEmitterCell *chargeCell = [CAEmitterCell emitterCell];
	chargeCell.name = @"charge";
	chargeCell.alphaRange = 0.20;
	chargeCell.alphaSpeed = -1.0;
    
	chargeCell.lifetime = 0.3;
	chargeCell.lifetimeRange = 0.1;
	chargeCell.birthRate = 0;
	chargeCell.velocity = -40.0;
	chargeCell.velocityRange = 0.00;
    
	_chargeLayer = [CAEmitterLayer layer];
	_chargeLayer.name = @"emitterLayer";
	_chargeLayer.emitterShape = kCAEmitterLayerCircle;
	_chargeLayer.emitterMode = kCAEmitterLayerOutline;
	_chargeLayer.emitterSize = CGSizeMake(25, 0);
	_chargeLayer.emitterCells = @[chargeCell];
	_chargeLayer.renderMode = kCAEmitterLayerOldestFirst;
    _chargeLayer.masksToBounds = NO;
	_chargeLayer.seed = 1366128504;
	[self.layer addSublayer:_chargeLayer];
    
    self.emitterCells = @[chargeCell, explosionCell];
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self setup];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.chargeLayer.emitterPosition = center;
    self.explosionLayer.emitterPosition = center;
}

#pragma mark - Methods

- (void)animate {
    self.chargeLayer.beginTime = CACurrentMediaTime();
    [self.chargeLayer setValue:@80 forKeyPath:@"emitterCells.charge.birthRate"];
    [self performSelector:@selector(explode) withObject:nil afterDelay:0.2];
}

- (void)explode {
	[self.chargeLayer setValue:@0 forKeyPath:@"emitterCells.charge.birthRate"];
    self.explosionLayer.beginTime = CACurrentMediaTime();
	[self.explosionLayer setValue:@500 forKeyPath:@"emitterCells.explosion.birthRate"];
    [self performSelector:@selector(stop) withObject:nil afterDelay:0.1];
}

- (void)stop {
	[self.chargeLayer setValue:@0 forKeyPath:@"emitterCells.charge.birthRate"];
	[self.explosionLayer setValue:@0 forKeyPath:@"emitterCells.explosion.birthRate"];
}

#pragma mark - Properties

- (void)setParticleImage:(UIImage *)particleImage {
    _particleImage = particleImage;
    for (CAEmitterCell *cell in self.emitterCells) {
    	cell.contents = (id)[particleImage CGImage];
    }
}

- (void)setParticleScale:(CGFloat)particleScale {
    _particleScale = particleScale;
    for (CAEmitterCell *cell in self.emitterCells) {
    	cell.scale = particleScale;
    }
}

- (void)setParticleScaleRange:(CGFloat)particleScaleRange {
    _particleScaleRange = particleScaleRange;
    for (CAEmitterCell *cell in self.emitterCells) {
    	cell.scaleRange = particleScaleRange;
    }
}

@end
