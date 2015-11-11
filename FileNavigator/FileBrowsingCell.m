//
//  FileBrowsingCell.m
//  FileNavigator
//
//  Created by Bipin Gohel on 15/10/15.
//  Copyright (c) 2015 Bipin Gohel. All rights reserved.
//

#import "FileBrowsingCell.h"

@implementation FileBrowsingCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // configure control(s)
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(60,10, 300, 30)];
        self.name.textColor = [UIColor blackColor];
        //self.n.font = [UIFont fontWithName:@"Arial" size:12.0f];
        
        self.img = [[UIImageView alloc] initWithFrame:CGRectMake(5,10,40,40)];
        
        [self addSubview:self.img];
        [self addSubview:self.name];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
