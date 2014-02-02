//
//  timeCell.m
//  Timer
//
//  Created by Francisco Javier Álvarez García on 03/01/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import "timeCell.h"

@implementation timeCell

@synthesize time;
@synthesize timeName;

-(void)setTime:(NSNumber *)ti{
    if (ti) {
        time = ti;
        
        int minutes = [time doubleValue]/60;
        int seconds = round([time doubleValue] - minutes*60);
        self.timeLabel.text = [NSString stringWithFormat:@"%.2d:%.2d", minutes, seconds];
    }
}

-(void)setTimeName:(NSString *)timeNa {
    if (timeNa) {
        timeName = timeNa;
        self.timeNameField.text = timeName;
    }
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end