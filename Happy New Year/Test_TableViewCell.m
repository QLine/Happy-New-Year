//
//  Test_TableViewCell.m
//  Happy New Year
//
//  Created by 钟柳 on 16/2/17.
//  Copyright © 2016年 钟柳. All rights reserved.
//

#import "Test_TableViewCell.h"

@interface Test_TableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end

@implementation Test_TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setDataTitleLable:(NSString *)title{
    self.titleLable.text = title;
}
@end
