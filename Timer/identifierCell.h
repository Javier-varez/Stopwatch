//
//  identifierCell.h
//  Timer
//
//  Created by Francisco Javier Álvarez García on 03/01/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface identifierCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UITextField *identifierField;
@property (nonatomic, strong) NSAttributedString *identifier;

@end
