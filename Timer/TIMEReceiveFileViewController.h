//
//  TIMEReceiveFileViewController.h
//  Timing
//
//  Created by Francisco Javier Álvarez García on 31/12/13.
//  Copyright (c) 2013 Francisco Javier Álvarez García. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TIMEReceiveFileViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

- (IBAction)yesButtonPressed:(id)sender;
- (IBAction)noButtonPressed:(id)sender;

@property (strong, nonatomic) NSURL *url;

@end
