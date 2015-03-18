//
//  CategoryTableViewController.m
//  emptyProject
//
//  Created by Katushka Mazalova on 02.03.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "CategoryTableViewController.h"
#import "GLang.h"
#import "Note.h"
#import "AppDelegate.h"
#import "URLNetworkHelper.h"
#import "EditCreateViewController.h"

@interface CategoryTableViewController () <UITableViewDataSource,UITableViewDelegate>



@end

@implementation CategoryTableViewController

#pragma mark - UITableViewDelegate
//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    NSMutableDictionary* firstSection= [extds objectAtIndex: [indexPath section] ];
//    NSMutableDictionary* d=[[firstSection objectForKey:@"cells"] objectAtIndex:[indexPath row]];
//    [d setObject:([[d objectForKey:@"type"] isEqualToString:@"default"])?@"checkbox":@"default" forKey:@"type"];
//    [self updateFooterText];
//    [uitableview setExtendedDataSource:extds];
//    return nil;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary* sectionDictionary=[_arrayWithJsonCategory objectAtIndex:[indexPath row]];
    
    NSMutableArray *arraySubcategories = [sectionDictionary objectForKey:@"subcategories"];
    if (arraySubcategories.count) {
        
        //пуш этот же контроллер только в проперти arrayWithJsonCategory передать эту субкатегорию (arraySubcategories)
        CategoryTableViewController *categoryController = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryTableViewControllerID"];
        
        categoryController.note = self.note;
        categoryController.arrayWithJsonCategory = [NSMutableArray arrayWithArray:arraySubcategories];
        
        [self.navigationController pushViewController:categoryController animated:YES];
        
    } else {
    
        for (UIViewController *nextController in self.navigationController.viewControllers)
        {
            if ([nextController isKindOfClass:[EditCreateViewController class]])
            {
                self.note.category = [sectionDictionary objectForKey:@"uniq_id"];
                [self.navigationController popToViewController:nextController animated:YES];
            }
        }
    }
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary* sectionDictionary=[_arrayWithJsonCategory objectAtIndex:[indexPath row]];
    
    NSMutableArray *arraySubcategories = [sectionDictionary objectForKey:@"subcategories"];
    if (!arraySubcategories.count) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return indexPath;
}



- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
   
    
   
    
    
    /*----------------------------------JSON-----------------------------*/
    
    //{"name":"Parent category","uniq_id":"catxx","subcategories":[{"name":"subcategory1","uniq_id":"daebaa"},{"name":"subcategory2","uniq_id":"daebaa2"}]}
    

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_arrayWithJsonCategory) {
        return;
    }
    
    _arrayWithJsonCategory = [NSMutableArray array];
    NSString *command = @"http://grope.io/api/categories.php";
    
    __weak UITableView *selfTableView = self.tableView;
    [URLNetworkHelper command:command completionBlock:^(id responce, NSError *error){
        _arrayWithJsonCategory = [responce objectForKey:@"subcategories"];
        [selfTableView reloadData];
        
    }];
    
//    if (!_arrayWithJsonCategory) {
//    
//    NSMutableArray *arrayJson = [NSMutableArray array];
//    
//    [arrayJson addObject:@{@"name":@"Parent category1",@"uniq_id":@"catxx1",@"subcategories": [NSArray arrayWithObjects:@{@"name":@"subcategory1",@"uniq_id":@"subcat1"},@{@"name":@"subcategory2",@"uniq_id":@"subcat2"}, nil]}];
//    [arrayJson addObject:@{@"name":@"Parent category2",@"uniq_id":@"catxx2",@"subcategories": [NSArray arrayWithObjects:@{@"name":@"subcategory1",@"uniq_id":@"subcat1"},@{@"name":@"subcategory2",@"uniq_id":@"subcat2"}, nil]}];
//    
//    _arrayWithJsonCategory = [NSMutableArray arrayWithArray:arrayJson];
//
//    }
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return [_arrayWithJsonCategory count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSDictionary* sectionDictionary=[_arrayWithJsonCategory objectAtIndex:[indexPath row]];
    // NSDictionary *rowDictionary = [[sectionDictionary objectForKey:@"name"] objectAtIndex:rid];
    
    static NSString *cellIdentificator = @"cellIdentificator";
    
    
    NSMutableArray *arraySubcategories = [sectionDictionary objectForKey:@"subcategories"];
    
    
        //пуш этот же контроллер только в проперти arrayWithJsonCategory передать эту субкатегорию (arraySubcategories)
        CategoryTableViewController *categoryController = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryTableViewControllerID"];
        
        categoryController.note = self.note;
        categoryController.arrayWithJsonCategory = [NSMutableArray arrayWithArray:arraySubcategories];
    
    UITableViewCell *c = [tableView dequeueReusableCellWithIdentifier:cellIdentificator];
    if (arraySubcategories.count) {
        c.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        
        if (!self.note.category) {
             c.accessoryType = UITableViewCellAccessoryNone;
        } else
            if ([[sectionDictionary objectForKey:@"uniq_id"]isEqualToString:self.note.category]) {
                c.accessoryType = UITableViewCellAccessoryCheckmark;
            }
               
        
        
    }
    
        
        if(c){
            NSString *title = [NSString stringWithFormat:@"%@",[sectionDictionary objectForKey:@"name"]];
 
            [[c textLabel]setText:title];
            
        }
        return c;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    
    return @"Categories";
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
