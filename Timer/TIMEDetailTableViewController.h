//
//  TIMEDetailTableViewController.h
//  Timer
//
//  Created by Francisco Javier Álvarez García on 03/01/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Observation;

@interface TIMEDetailTableViewController : UITableViewController

@property (strong, nonatomic) Observation *detailItem;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UIButton *button;

-(IBAction)insertNewTime:(id)sender;

- (IBAction)pressedButton:(UIButton *)sender;
@end
