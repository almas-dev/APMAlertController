//
//  ObjectiveCViewController.m
//  APMAlertController
//
//  Created by Alexey Korolev on 15.05.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

#import "ObjectiveCViewController.h"
#import "APMAlertController-Swift.h"

@interface ObjectiveCViewController ()

@end

@implementation ObjectiveCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Objective-C Example";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Alert Text Title";
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0: {
            APMAlertController *alertController = [[APMAlertController alloc] initWithTitle:@"Alert Text Title" message:@"Message message message message message message message message message." preferredStyle:APMAlertControllerStyleAlert];
            APMAlertAction *cancelAction = [[APMAlertAction alloc] initWithTitle:@"Cancel" style:APMAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            APMAlertAction *anotherAction = [[APMAlertAction alloc] initWithTitle:@"Default" style:APMAlertActionStyleDefault handler:nil];
            [alertController addAction:anotherAction];
            [self presentViewController:alertController animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}


@end
