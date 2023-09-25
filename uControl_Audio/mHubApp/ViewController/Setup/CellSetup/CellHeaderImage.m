//
//  CellHeaderImage.m
//  mHubApp
//
//  Created by Yashica Agrawal on 07/12/16.
//  Copyright © 2016 Rave Infosys. All rights reserved.
//

#import "CellHeaderImage.h"

@implementation CellHeaderImage

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = colorClear;
    [self.imgCell setTintColor:[AppDelegate appDelegate].themeColours.colorNormalText];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
