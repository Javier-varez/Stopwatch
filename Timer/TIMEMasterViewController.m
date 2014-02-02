//
//  TIMEMasterViewController.m
//  Timer
//
//  Created by Francisco Javier Álvarez García on 03/01/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import "TIMEMasterViewController.h"

#import "TIMEDetailTableViewController.h"

#import "TIMEReceiveFileViewController.h"

#import "TIMEAnimationController.h"

#import "Time.h"

#import "Observation.h"

#define NilSelectionAlertViewTag 150
#define ShowHeadersAlertViewTag 350

@interface TIMEMasterViewController () {
    NSMutableArray *_Observations;
    NSMutableArray *_selectedItemsArray;
    TIMEReceiveFileViewController *_destinationViewController;
}
@end

@implementation TIMEMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(changeSelectionMode)];
    self.navigationItem.leftBarButtonItem = saveButton;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(preferredContentSizeChanged:)
     name:UIContentSizeCategoryDidChangeNotification
     object:nil];
    
    [self configureView];
}

- (void)preferredContentSizeChanged:(NSNotification *)notification {
    
    [self.tableView reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)configureView {
    _Observations = [NSMutableArray arrayWithArray:[Observation findAllSortedBy:@"date" ascending:NO]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_Observations) {
        _Observations = [[NSMutableArray alloc] init];
    }
    
    Observation *newObservation = [Observation createEntity];
    newObservation.date = [NSDate date];
    newObservation.identifier = @"NEW";
    
    Time *timeForCreatedObservation = [Time createEntity];
    timeForCreatedObservation.time = @(0.0);
    timeForCreatedObservation.name = @"Time 1";
    timeForCreatedObservation.date = [NSDate date];
    
    [newObservation addTimesForObservationObject:timeForCreatedObservation];
    
    [self configureView];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_Observations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    Observation *object = _Observations[indexPath.row];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM / dd / yyyy - HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:object.date];
    
    cell.detailTextLabel.text = dateString;
    
    if([_selectedItemsArray containsObject:[_Observations objectAtIndex:indexPath.row]]&&self.selectionMode)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    //Attributes for style
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    UIColor* textColor = [UIColor colorWithRed:0.175f green:0.458f blue:0.831f alpha:1.0f];
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : textColor,
                             NSFontAttributeName : font,
                             NSTextEffectAttributeName : NSTextEffectLetterpressStyle};
    
    NSAttributedString* attrString = [[NSAttributedString alloc]
                                      initWithString:object.identifier
                                      attributes:attrs];
    
    
    
    cell.textLabel.attributedText = attrString;
    cell.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //Delete Entities
        Observation *observationBeingDeleted = _Observations[indexPath.row];
        for (Time *time in (observationBeingDeleted.timesForObservation)) {
            [time deleteEntity];
        }
        [_Observations[indexPath.row] deleteEntity];
        
        //Retrieve Updated Entities
        _Observations = [NSMutableArray arrayWithArray:[Observation findAllSortedBy:@"date" ascending:NO]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectionMode){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            NSManagedObject *object = [_Observations objectAtIndex:indexPath.row];
            [_selectedItemsArray addObject:object];
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [_selectedItemsArray removeObject:[_Observations objectAtIndex:indexPath.row]];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static UILabel* label;
    if (!label) {
        label = [[UILabel alloc]
                 initWithFrame:CGRectMake(0, 0, FLT_MAX, FLT_MAX)];
        label.text = @"test";
    }
    
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    [label sizeToFit];
    return label.frame.size.height * 1.8;
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return !self.selectionMode;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Observation *object = _Observations[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

#pragma mark - Export CSV Methods

-(void)exportCSV {
    if ([_selectedItemsArray count]==0){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Nil Selection"
                                                        message:@"Export all data?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Proceed", nil];
        [alert setTag:NilSelectionAlertViewTag];
        [alert show];
    }
    else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Include Headers?"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
        [alert setTag:ShowHeadersAlertViewTag];
        [alert show];
    }
    
    
    
    
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == NilSelectionAlertViewTag){
        if (buttonIndex != 0) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Include Headers?"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"No"
                                                  otherButtonTitles:@"Yes", nil];
            [alert setTag:ShowHeadersAlertViewTag];
            [alert show];
        }
    }
    else if (alertView.tag == ShowHeadersAlertViewTag) {
        if (buttonIndex != 0) {
            self.includeHeaders = YES;
        }
        else {
            self.includeHeaders = NO;
        }
        [self createCSV];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Export.csv"];
        if (path) {
            
            NSURL *URLMolona = [[NSURL alloc] initFileURLWithPath:path];
            
            self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URLMolona];
            self.documentInteractionController.delegate = self;
            [self.documentInteractionController presentOptionsMenuFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
            self.selectionMode = NO;
            _selectedItemsArray = nil;
            UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
            self.navigationItem.rightBarButtonItem = addButton;
            
            UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(changeSelectionMode)];
            self.navigationItem.leftBarButtonItem = saveButton;
            [self.tableView reloadData];
        }
    }
}

-(void)createCSV {
    NSString *string = @"";
    if ([_selectedItemsArray count]>=1){
        
        for (Observation *object in _selectedItemsArray) {
            string = [string stringByAppendingString:[self stringForObject:object]];
        }
    }
    else if(_Observations) {
        int i;
        Observation *object;
        
        int numberOfObjectsInMemory = (int)[_Observations count];
        
        for (i=0;i<=numberOfObjectsInMemory-1;i++) {
            object = [_Observations objectAtIndex:i];
            string = [string stringByAppendingString:[self stringForObject:object]];
        }
    }
    
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"Export.csv"];
    
    [string writeToFile:path atomically:NO encoding:NSStringEncodingConversionAllowLossy error:&error];
    
}

-(NSString*)stringForObject:(Observation*)object {
    NSString* timesNames = @"";
    int i;
    NSArray *times = [[object.timesForObservation allObjects] sortedArrayUsingSelector:@selector(compare:)];
    
    if ([times count] > 0) {
        for (i=0;i<=[times count]-1;i++) {
            Time *time = times[i];
            NSString *timeName = time.name;
            if (i == [times count]-1) {
                timesNames = [timesNames stringByAppendingString:[NSString stringWithFormat:@"%@\n", timeName]];
            }
            else {
                timesNames = [timesNames stringByAppendingString:[NSString stringWithFormat:@"%@;", timeName]];
            }
        }
        
        NSString *upperString = [NSString stringWithFormat:@"%@;%@;%@", @"Identifier", @"Date", timesNames];
        
        timesNames = @"";
        for (i=0;i<=[times count]-1;i++) {
            Time *time = times[i];
            NSString *timeStr = [time.time stringValue];
            timeStr = [timeStr stringByReplacingOccurrencesOfString:@"." withString:@","];
            if (i == [times count]-1) {
                timesNames = [timesNames stringByAppendingString:[NSString stringWithFormat:@"%@\n", timeStr]];
            }
            else {
                timesNames = [timesNames stringByAppendingString:[NSString stringWithFormat:@"%@;", timeStr]];
            }
        }
        
        NSString *lowerString = [NSString stringWithFormat:@"%@;%@;%@", object.identifier, [object.date description], timesNames];
        
        if (self.includeHeaders){
            return [upperString stringByAppendingString:lowerString];
        }
        else {
            return lowerString;
        }
    }
    
    else {
        NSString *upperString = [NSString stringWithFormat:@"%@;%@\n", @"Identifier", @"Date"];
        NSString *lowerString = [NSString stringWithFormat:@"%@;%@\n", object.identifier, [object.date description]];
        
        if(self.includeHeaders) {
            return [upperString stringByAppendingString:lowerString];
        }
        else {
            return lowerString;
        }
    }

}

#pragma mark - SelectionMethod

-(void)changeSelectionMode {
    if (self.selectionMode) {
        self.selectionMode = NO;
        //set AddButton
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
        self.navigationItem.rightBarButtonItem = addButton;
        //set SaveButton
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(changeSelectionMode)];
        self.navigationItem.leftBarButtonItem = saveButton;
        _selectedItemsArray = [[NSMutableArray alloc]init];
    }
    else {
        self.selectionMode = YES;
        //set exportButton
        UIBarButtonItem *exportButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(exportCSV)];
        self.navigationItem.rightBarButtonItem = exportButton;
        //set doneButton
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(changeSelectionMode)];
        self.navigationItem.leftBarButtonItem = doneButton;
    }
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    self.selectionMode = NO;
    //set AddButton
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    //set SaveButton
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(changeSelectionMode)];
    self.navigationItem.leftBarButtonItem = saveButton;
    _selectedItemsArray = [[NSMutableArray alloc]init];
}


#pragma mark - Import CSV methods

-(void) handleOpenURL:(NSURL *)url {
    
    [self viewDidLoad];
    _destinationViewController = [[TIMEReceiveFileViewController alloc] init];
        
    UIStoryboard *storyboard = self.storyboard;
        
    _destinationViewController = [storyboard instantiateViewControllerWithIdentifier:@"Custom"];
        
    _destinationViewController.transitioningDelegate = self;
    _destinationViewController.modalPresentationStyle = UIModalPresentationCustom;
        
        
    _destinationViewController.url = url;
        
    [self presentViewController:_destinationViewController animated:YES completion:nil];
}

#pragma mark - Animation Methods

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                 presentingController:(UIViewController *)presenting
                                                                     sourceController:(UIViewController *)source {
    TIMEAnimationController *animationController = [TIMEAnimationController new];
    animationController.presenting = YES;
    return animationController;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    TIMEAnimationController *animationController = [TIMEAnimationController new];
    return animationController;
}

@end
