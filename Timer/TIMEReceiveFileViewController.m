//
//  TIMEReceiveFileViewController.m
//  Timing
//
//  Created by Francisco Javier Álvarez García on 31/12/13.
//  Copyright (c) 2013 Francisco Javier Álvarez García. All rights reserved.
//

#import "TIMEReceiveFileViewController.h"
#import "TIMEMasterViewController.h"

#import "Observation.h"
#import "Time.h"

@interface TIMEReceiveFileViewController ()

@end

@implementation TIMEReceiveFileViewController{
    NSMutableArray *_dataToImport;
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
        
    _dataToImport = [[NSMutableArray alloc] init];
    
    [self obtainData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_dataToImport count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(indexPath.row == [_dataToImport count]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"customCell"];
        /*if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"customCell"];
        }*/
        // Configure the cell...
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"normalCell"];
        /*if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"normalCell"];
        }*/
        // Configure the cell...
        
        NSDictionary *object = [_dataToImport objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [object valueForKey:@"identifier"];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM / dd / yyyy - HH:mm:ss"];
        NSString *dateString = [formatter stringFromDate:[object valueForKey:@"date"]];
        cell.detailTextLabel.text = dateString;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        
        return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [_dataToImport count]) {
        return 80;
    }
    else {
        return 44;
    }
}

-(void)obtainData {
    NSError *outError;
    NSString *fileString = [NSString stringWithContentsOfURL:self.url
                                                    encoding:NSUTF8StringEncoding error:&outError];
    
    if ( nil == fileString ) return;
    NSScanner *scanner = [NSScanner scannerWithString:fileString];
    NSString *identifier, *dateStr, *ignoreStr;
    
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@";\n"]];
    
    while (![scanner isAtEnd])
    {
        
        
        //ignore headers
        [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"] intoString:&ignoreStr];
        
        NSString *find = @";";
        NSString *text = ignoreStr;
        
        int strCount = (int)[text length] - (int)[[text stringByReplacingOccurrencesOfString:find withString:@""] length];
        strCount /= [find length];
        
        if (strCount == 1) {
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@";"] intoString:&identifier];
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"] intoString:&dateStr];
        }
        else {
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@";"] intoString:&identifier];
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@";"] intoString:&dateStr];
            
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"] intoString:&ignoreStr];
        }
        
        
        
        NSMutableDictionary *object = [[NSMutableDictionary alloc] init];
        
        
        // If appropriate, configure the new managed object.
        // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
        [object setValue:identifier forKey:@"identifier"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-LL-d H:m:s vvvv"];
        NSDate *date = [dateFormat dateFromString:dateStr];
        
        [object setValue:date forKey:@"date"];
        
        [_dataToImport addObject:object];
    }
}


- (IBAction)yesButtonPressed:(id)sender {
     NSError *outError;
     NSString *fileString = [NSString stringWithContentsOfURL:self.url
     encoding:NSUTF8StringEncoding error:&outError];
     
    if ( nil == fileString ) return;
    NSScanner *scanner = [NSScanner scannerWithString:fileString];
    NSScanner *secondScanner = [NSScanner scannerWithString:fileString];
    NSString *identifier, *dateStr, *auxString;
    
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@";\n"]];
    [secondScanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@";\n"]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    while (![scanner isAtEnd])
    {
        
        //obtain Length of the measurement
        [secondScanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"] intoString:&auxString];
        
        NSString *find = @";";
        NSString *text = auxString;
        
        int strCount = (int)[text length] - (int)[[text stringByReplacingOccurrencesOfString:find withString:@""] length];
        strCount /= [find length];
        
        [secondScanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"] intoString:&auxString];
        
        //Scan Names (headers)
        
        if (strCount == 1) {
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@";"] intoString:&identifier];
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"] intoString:&dateStr];
        }
        else {
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@";"] intoString:&identifier];
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@";"] intoString:&dateStr];
            
            //Obtain times
            int i;
            NSMutableArray *times = [[NSMutableArray alloc] init];
            
            for (i=1;i<=strCount-1;i++){
                if (i==strCount-1) {
                    [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"] intoString:&auxString];
                }
                else {
                    [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@";"] intoString:&auxString];
                }
                [times addObject:auxString];
            }
            
            [dictionary setObject:times forKey:@"timesNames"];
            
        }
        
        //Scan Actual Data
        
        if (strCount == 1) {
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@";"] intoString:&identifier];
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"] intoString:&dateStr];
            
            [dictionary setObject:identifier forKey:@"identifier"];
            [dictionary setObject:dateStr forKey:@"dateStr"];
        }
        else {
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@";"] intoString:&identifier];
            [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@";"] intoString:&dateStr];
            
            [dictionary setObject:identifier forKey:@"identifier"];
            [dictionary setObject:dateStr forKey:@"dateStr"];
            
            //Obtain times
            int i;
            NSMutableArray *times = [[NSMutableArray alloc] init];
            
            for (i=1;i<=strCount-1;i++){
                if (i==strCount-1) {
                    [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"] intoString:&auxString];
                }
                else {
                    [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@";"] intoString:&auxString];
                }
                [times addObject:@([[auxString stringByReplacingOccurrencesOfString:@"," withString:@"."] doubleValue])];
            }
            
            [dictionary setObject:times forKey:@"times"];
            
        }
        
        //Create Entities and Store them!
        
        Observation *observationToStore = [Observation createEntity];
        
        observationToStore.identifier = [dictionary objectForKey:@"identifier"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-LL-d H:m:s vvvv"];
        NSDate *date = [dateFormat dateFromString:[dictionary objectForKey:@"dateStr"]];
        
        observationToStore.date = date;
        
        int i;
        NSArray *times = [dictionary objectForKey:@"times"];
        NSArray *timesNames = [dictionary objectForKey:@"timesNames"];
        
        for (i=1;i<=[times count];i++) {
            
            Time *timeToStore = [Time createEntity];
            
            timeToStore.time = times[i-1];
            timeToStore.name = timesNames[i-1];
            timeToStore.date = [NSDate dateWithTimeIntervalSince1970:(float)i-1];
            
            [observationToStore addTimesForObservationObject:timeToStore];
            
        }
        
        [[NSManagedObjectContext contextForCurrentThread] saveToPersistentStoreAndWait];
        dictionary = [[NSMutableDictionary alloc] init];
        
     }
    [(TIMEMasterViewController*)((UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController).topViewController configureView];
    [((TIMEMasterViewController*)((UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController).topViewController).tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)noButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
