//
//  timeCell.h
//  Timer
//
//  Created by Francisco Javier Álvarez García on 03/01/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timeCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UILabel *timeLabel;
@property (nonatomic,weak) IBOutlet UITextField *timeNameField;

@property (nonatomic, strong) NSNumber *time;
@property (nonatomic, strong) NSString *timeName;

@end
