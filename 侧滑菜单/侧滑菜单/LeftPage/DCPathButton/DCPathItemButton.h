//
//  DCPathItemButton.h
//  DCPathButton
//
//  Created by tang dixi on 31/7/14.
//  Copyright (c) 2014 Tangdxi. All rights reserved.
//

@import UIKit;

@class DCPathItemButton;

@protocol DCPathItemButtonDelegate <NSObject>

- (void)itemButtonTapped:(DCPathItemButton *)itemButton;

@end

@interface DCPathItemButton : UIImageView

@property (assign, nonatomic) NSUInteger index;
@property (weak, nonatomic) id<DCPathItemButtonDelegate> delegate;

- (id)initWithImage:(UIImage *)image
   highlightedImage:(UIImage *)highlightedImage
    backgroundImage:(UIImage *)backgroundImage
backgroundHighlightedImage:(UIImage *)backgroundHighlightedImage;

@end
