//
//  ZonesTVController.m
//  DGF_Spectacles
//
//  Created by Daniel Roach on 11/14/14.
//  Copyright (c) 2014 Daniel Roach. All rights reserved.
//

#import "ZonesTVController.h"
#import "ZoneMapViewController.h"
#import "Spectacles.h"

@interface ZonesTVController ()
@property (strong, nonatomic) NSDictionary *zoneMaps;
@property (strong, nonatomic) NSString *zoneName;
@end

@implementation ZonesTVController

- (void)viewDidLoad {
    [super viewDidLoad];
//    UIView *loadView = [Spectacles activitySpinnerView];
//    loadView.center = self.view.center;
//    [self.view addSubview:loadView];
    [self __loadZoneMaps];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)__loadZoneMaps {
    NSString *plistFilePath = [[NSBundle mainBundle] pathForResource:@"DeerZoneList" ofType:@"plist"];
    _zoneMaps = [NSDictionary dictionaryWithContentsOfFile:plistFilePath];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger sectionCount;
    
    if (section == 0) {
        sectionCount = [[self.zoneMaps objectForKey:@"A-Zone"] allKeys].count;
    }
    else if (section == 1) {
        sectionCount = [[self.zoneMaps objectForKey:@"B-Zone"] allKeys].count;
    }
    else if (section == 2) {
        sectionCount = [[self.zoneMaps objectForKey:@"C-Zone"] allKeys].count;
    }
    else if (section == 3) {
        sectionCount = [[self.zoneMaps objectForKey:@"X-Zone"] allKeys].count;
    }
    else sectionCount = 0;
    
    return sectionCount;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"A-Zone";
            break;
        case 1:
            return @"B-Zone";
            break;
        case 2:
            return @"C-Zone";
            break;
        case 3:
            return @"X-Zone";
            break;
            
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Zone";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        NSArray *zoneTitles = [self.zoneMaps[@"A-Zone"] allKeys];
        NSArray *sortedArray = [zoneTitles sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
        NSString *title = sortedArray[indexPath.row];
        cell.textLabel.text = title;
    }
    else if (indexPath.section == 1) {
        NSArray *zoneTitles = [self.zoneMaps[@"B-Zone"] allKeys];
        NSArray *sortedArray = [zoneTitles sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
        NSString *title = sortedArray[indexPath.row];
        cell.textLabel.text = title;
    }
    else if (indexPath.section == 2) {
        NSArray *zoneTitles = [self.zoneMaps[@"C-Zone"] allKeys];
        NSArray *sortedArray = [zoneTitles sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
        NSString *title = sortedArray[indexPath.row];
        cell.textLabel.text = title;
    }
    else {
        NSArray *zoneTitles = [self.zoneMaps[@"X-Zone"] allKeys];
        NSArray *sortedArray = [zoneTitles sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
        NSString *title = sortedArray[indexPath.row];
        cell.textLabel.text = title;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *zoneKey;
    if (indexPath.section == 0) {
        zoneKey = @"A-Zone";
    }
    
    else if (indexPath.section == 1) {
        zoneKey = @"B-Zone";
    }
    
    else if (indexPath.section == 2) {
        zoneKey = @"C-Zone";
    }
    else {
        zoneKey = @"X-Zone";
    }
    self.zoneName = self.zoneMaps[zoneKey][selectedCell.textLabel.text];
    ZoneMapViewController *mapView = [[ZoneMapViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:mapView animated:YES];
    [mapView initializeMapPDF:self.zoneName];
//    //[self.navigationController pushViewController:mapView animated:YES];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"MapViewer"]) {
        ZoneMapViewController *mapView = [segue destinationViewController];
        [mapView initializeMapPDF:self.zoneName];
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
