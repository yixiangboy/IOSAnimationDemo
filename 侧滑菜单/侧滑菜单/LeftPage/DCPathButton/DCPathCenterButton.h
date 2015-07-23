//
//  DCPathCenterButton.h
//  DCPathButton
//
//  Created by tang dixi on 30/7/14.
//  Copyright (c) 2014 Tangdxi. All rights reserved.
//

@import UIKit;

@protocol DCPathCenterButtonDelegate <NSObject>

- (void)centerButtonTapped;

@end

@interface DCPathCenterButton : UIImageView

@property (weak, nonatomic) id<DCPathCenterButtonDelegate> delegate;

@end
