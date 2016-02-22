//
//  TestTwo_TableViewCell.m
//  Happy New Year
//
//  Created by 钟柳 on 16/2/17.
//  Copyright © 2016年 钟柳. All rights reserved.
//

#import "TestTwo_TableViewCell.h"

@implementation TestTwo_TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)ClickAction:(id)sender {
    NSLog(@"你想抽奖？可惜抽不了！");
}

@end
