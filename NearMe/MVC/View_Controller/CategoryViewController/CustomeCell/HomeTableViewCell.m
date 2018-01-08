//
//  HomeTableViewCell.m
//  NearMe
//
//  Created by Talentelgia on 6/18/15.
//  Copyright (c) 2015 Talentelgia. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell
@synthesize imageView, cellLabel;

- (void)awakeFromNib {
    
    // Initialization code
    imageView.layer.cornerRadius = 8;
    
    imageView.layer.borderWidth = 2.0;
    
    imageView.layer.masksToBounds = YES;
    
    imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    imageView.clipsToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Configure the view for the selected state
    [super setSelected:selected animated:animated];
}

@end
