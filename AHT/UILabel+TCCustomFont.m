//
//  UILabel+TCCustomFont.m
//  Advice
//
//  Created by Troy DeMar on 6/18/14.
//  Copyright (c) 2014 Advice App LLC. All rights reserved.
//

#import "UILabel+TCCustomFont.h"

@implementation UILabel (TCCustomFont)

- (NSString *)fontName {
    return self.font.fontName;
}

- (void)setFontName:(NSString *)fontName {
    self.font = [UIFont fontWithName:fontName size:self.font.pointSize];
}

@end
