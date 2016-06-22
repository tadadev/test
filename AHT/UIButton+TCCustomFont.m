//
//  UIButton+TCCustomFont.m
//  Advice
//
//  Created by Troy DeMar on 6/18/14.
//  Copyright (c) 2014 Advice App LLC. All rights reserved.
//

#import "UIButton+TCCustomFont.h"

@implementation UIButton (TCCustomFont)

- (NSString *)fontName {
    return self.titleLabel.font.fontName;
}

- (void)setFontName:(NSString *)fontName {
    self.titleLabel.font = [UIFont fontWithName:fontName size:self.titleLabel.font.pointSize];
}


@end
