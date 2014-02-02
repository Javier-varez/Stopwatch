//
//  TIMEMasterViewController.h
//  Timer
//
//  Created by Francisco Javier Álvarez García on 03/01/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TIMEMasterViewController : UITableViewController <UIAlertViewDelegate, UIDocumentInteractionControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic) BOOL selectionMode;
@property (nonatomic) BOOL includeHeaders;

@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *documentExportButton;

-(void) handleOpenURL:(NSURL *)url;
-(void) configureView;
@end
