//
//  dateCell.m
//  Timer
//
//  Created by Francisco Javier Álvarez García on 03/01/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import "dateCell.h"

@implementation dateCell

@synthesize date;

-(void)setDate:(NSDate *)newDate{
    if (newDate) {
        date = newDate;
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM / dd / yyyy - HH:mm:ss"];
        NSString *dateString = [formatter stringFromDate:date];
        
        self.dateLabel.text = dateString;
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
