//
//  TIMEDetailTableViewController.m
//  Timer
//
//  Created by Francisco Javier Álvarez García on 03/01/14.
//  Copyright (c) 2014 Francisco Javier Álvarez García. All rights reserved.
//

#import "TIMEDetailTableViewController.h"

#import "identifierCell.h"
#import "dateCell.h"
#import "timeCell.h"

#import "Observation.h"
#import "Time.h"

@interface TIMEDetailTableViewController ()

@property (nonatomic, strong) NSMutableArray *times;
@property (nonatomic, strong) NSDate *previousDate;
@property (nonatomic, strong) NSNumber *selectionIndex;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TIMEDetailTableViewController

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.times = [NSMutableArray arrayWithArray:[[self.detailItem.timesForObservation allObjects] sortedArrayUsingSelector:@selector(compare:)]];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
    
    self.navigationItem.title = self.detailItem.identifier;
    
    self.selectionIndex = @(-1);

}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    identifierCell *idCell = (identifierCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    NSString *str = idCell.identifierField.text;
    self.detailItem.identifier = str;
    
    for (Time *time in self.detailItem.timesForObservation) {
        indexPath = [NSIndexPath indexPathForRow:[self.times indexOfObject:time] inSection:1];
        timeCell *tCell = (timeCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        time.name = tCell.timeNameField.text;
    }
    
    self.navigationItem.title = self.detailItem.identifier;
    
    [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
}


-(IBAction)insertNewTime:(id)sender {
    Time *createdTime = [Time createEntity];
    
    createdTime.time = @(0.0);
    createdTime.name = [NSString stringWithFormat:@"Time %lu",(unsigned long)self.detailItem.timesForObservation.count+1];
    createdTime.date = [NSDate date];
    
    [self.detailItem addTimesForObservationObject:createdTime];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.detailItem.timesForObservation.count-1 inSection:1];
    
    [self.times addObject:createdTime];
    
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];    
}

- (IBAction)pressedButton:(UIButton *)sender {
    if (!self.previousDate) {
        self.previousDate = [NSDate date];
        
        self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(setValueForCurrentProcess) userInfo:nil repeats:YES];
        
        NSRunLoop *runner = [NSRunLoop currentRunLoop];
        [runner addTimer:self.timer forMode: NSDefaultRunLoopMode];
        [self.button setTitle:@"Stop" forState:UIControlStateNormal];
        
    }
    else {
        [self setValueForCurrentProcess];
        self.previousDate = nil;
        [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
        if (self.timer) {
            [self.timer invalidate];
        }
        [self.button setTitle:@"Start" forState:UIControlStateNormal];
    }
}

-(void)setTotalTimeCell {
    NSIndexPath *indexPathForTotalTimeCell = [NSIndexPath indexPathForRow:0 inSection:2];
    timeCell *totalTimeCell = (timeCell*)[self.tableView cellForRowAtIndexPath:indexPathForTotalTimeCell];
    
    NSNumber *totalTime = @(0.0);
    for (Time *time in _times) {
        totalTime = @([totalTime doubleValue] + [time.time doubleValue]);
    }
    
    totalTimeCell.time = totalTime;
}

-(void)setValueForCurrentProcess {
    timeCell *cell = (timeCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.selectionIndex intValue] inSection:1]];
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.previousDate];
    
    cell.time = @(timeInterval);
    
    [self saveData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) return 2;
    else if (section == 1) return [self.detailItem.timesForObservation count];
    else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            identifierCell *IDcell = (identifierCell*)[tableView dequeueReusableCellWithIdentifier:@"identifierCell" forIndexPath:indexPath];
            
            //Attributes for style
            UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
            UIColor* textColor = [UIColor colorWithRed:0.175f green:0.458f blue:0.831f alpha:1.0f];
            NSDictionary *attrs = @{ NSForegroundColorAttributeName : textColor,
                                     NSFontAttributeName : font,
                                     NSTextEffectAttributeName : NSTextEffectLetterpressStyle};
            
            NSAttributedString* attrString = [[NSAttributedString alloc]
                                              initWithString:self.detailItem.identifier
                                              attributes:attrs];
            
            IDcell.identifier = attrString;
            
            cell = (UITableViewCell*)IDcell;
        }
        else if (indexPath.row == 1) {
            dateCell *DATEcell = (dateCell*)[tableView dequeueReusableCellWithIdentifier:@"dateCell" forIndexPath:indexPath];
            
            DATEcell.date = self.detailItem.date;
            
            cell = (UITableViewCell*)DATEcell;
        }
    }
    else if (indexPath.section == 1) {
        timeCell *TIMEcell = (timeCell*)[tableView dequeueReusableCellWithIdentifier:@"timeCell" forIndexPath:indexPath];
        
        Time *timeObjectForCurrentCell = [self.times objectAtIndex:indexPath.row];
        
        //Set timeName of current timeCell
        TIMEcell.timeName = timeObjectForCurrentCell.name;
        
        //Set time of current timeCell
        TIMEcell.time = timeObjectForCurrentCell.time;
        
        if ([self.selectionIndex intValue] == indexPath.row) {
            TIMEcell.timeLabel.textColor = [[UINavigationBar appearance] barTintColor];
        }
        else {
            TIMEcell.timeLabel.textColor = [UIColor blackColor];
        }
        
        cell = (UITableViewCell*)TIMEcell;
    }
    else if (indexPath.section == 2) {
        timeCell *TIMEcell = (timeCell*)[tableView dequeueReusableCellWithIdentifier:@"timeCell" forIndexPath:indexPath];
        
        NSNumber *totalTime = @(0.0);
        for (Time *time in _times) {
            totalTime = @([totalTime doubleValue] + [time.time doubleValue]);
        }
        TIMEcell.time = totalTime;
        TIMEcell.timeName = @"Total";
        [TIMEcell setUserInteractionEnabled:NO];
        
        cell = (UITableViewCell*)TIMEcell;
    }
    
    // Configure the cell...
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.section == 0) return NO;
    else return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if (indexPath.section == 1){
            Time *timeBeignDeleted = [self.times objectAtIndex:indexPath.row];
            [self.detailItem removeTimesForObservationObject:timeBeignDeleted];
            [self.times removeObject:timeBeignDeleted];
            [timeBeignDeleted deleteEntity];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            if ([self.selectionIndex intValue] == indexPath.row) {
                self.selectionIndex = @(-1);
                self.previousDate = nil;
                if (self.timer) {
                    [self.timer invalidate];
                }
                self.button.enabled = NO;
                [self.button setTitle:@"Start" forState:UIControlStateNormal];
            }
            else if ([self.selectionIndex intValue] > indexPath.row) {
                self.selectionIndex = @([self.selectionIndex intValue]-1);
                [self.tableView reloadData];
            }
            [self setTotalTimeCell];
        }
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row!=[self.selectionIndex intValue]) {
        self.selectionIndex = @(indexPath.row);
        if (self.previousDate) {
            [self.timer invalidate];
            self.previousDate = nil;
        }
        if (!self.button.enabled) self.button.enabled = YES;
        [self.button setTitle:@"Start" forState:UIControlStateNormal];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
}

-(void)saveData {
    
    for (Time *time in self.detailItem.timesForObservation) {
        timeCell *cell = (timeCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.times indexOfObject:time] inSection:1]];
        time.time = cell.time;
    }
    
    [self setTotalTimeCell];
    
    [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.previousDate) {
        [self setValueForCurrentProcess];
        self.previousDate = nil;
        if (self.timer) {
            [self.timer invalidate];
        }
        [self.button setTitle:@"Start" forState:UIControlStateNormal];
        [self dismissKeyboard];
    }    
}

@end
