#import "DoneViewController.h"
#import "EditDoneViewController.h"

@interface DoneViewController ()

@end

@implementation DoneViewController {
    Task *task;
    NSMutableArray *lowDone;
    NSMutableArray *mediumDone;
    NSMutableArray *highDone;
}

static NSMutableArray *doneTasks;
static NSUserDefaults *userDefaults;
static NSDate *data;

+ (void)initialize{
    doneTasks = [NSMutableArray new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    [self.doneTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    self.stateSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    
    NSDate *data = [userDefaults objectForKey:@"Done"];
    doneTasks = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    
    [self.doneTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    
    lowDone = [NSMutableArray new];
    mediumDone = [NSMutableArray new];
    highDone = [NSMutableArray new];
    
    task = [Task new];
    
    for (int i = 0; i < doneTasks.count; i++) {
        
        task = [doneTasks objectAtIndex:i];
        
        if([[[doneTasks objectAtIndex:i] taskPriority] isEqualToString:@"Low"]) {
            [lowDone addObject:task];
        }
        else if ([[[doneTasks objectAtIndex:i] taskPriority] isEqualToString:@"Medium"]) {
            [mediumDone addObject:task];
        }
        else if ([[[doneTasks objectAtIndex:i] taskPriority] isEqualToString:@"High"]) {
            [highDone addObject:task];
        }
    }
    
    [self.doneTableView reloadData];
}

- (IBAction)stateActionDone:(id)sender {
    [self.doneTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = 0;
    
    if(self.stateSegmentedControl.selectedSegmentIndex == 0){
        switch(section){
            case 0:
                numberOfRows = lowDone.count;
                break;
            case 1:
                numberOfRows = 0;
                break;
            case 2:
                numberOfRows = 0;
        }
    }else if(self.stateSegmentedControl.selectedSegmentIndex == 1){
        switch(section){
            case 0:
                numberOfRows = 0;
                break;
            case 1:
                numberOfRows = mediumDone.count;
                break;
            case 2:
                numberOfRows = 0;
        }
    }else if(self.stateSegmentedControl.selectedSegmentIndex == 2){
        switch(section){
            case 0:
                numberOfRows = 0;
                break;
            case 1:
                numberOfRows = 0;
                break;
            case 2:
                numberOfRows = highDone.count;
        }
    }else{
        switch(section){
            case 0:
                numberOfRows = lowDone.count;
                break;
            case 1:
                numberOfRows = mediumDone.count;
                break;
            case 2:
                numberOfRows = highDone.count;
        }
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [[lowDone objectAtIndex:indexPath.row] taskName];
            cell.imageView.image = [UIImage imageNamed:[[lowDone objectAtIndex:indexPath.row] taskImage]];
            cell.detailTextLabel.text = @"low";
            break;
        case 1:
            cell.textLabel.text = [[mediumDone objectAtIndex:indexPath.row] taskName];
            cell.imageView.image = [UIImage imageNamed:[[mediumDone objectAtIndex:indexPath.row] taskImage]];
            cell.detailTextLabel.text = @"medium";
            break;
        case 2:
            cell.textLabel.text = [[highDone objectAtIndex:indexPath.row] taskName];
            cell.imageView.image = [UIImage imageNamed:[[highDone objectAtIndex:indexPath.row] taskImage]];
            cell.detailTextLabel.text = @"high";
            break;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *priority = @" ";
    
    switch(section){
        case 0:
            priority = @"Low";
            break;
        case 1:
            priority = @"Medium";
            break;
        case 2:
            priority = @"High";
            break;
    }
    return priority;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Delete Task?" preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableArray *newDone = [NSMutableArray new];
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            switch(indexPath.section){
                case 0:
                    [self->lowDone removeObjectAtIndex:indexPath.row];
                    break;
                case 1 :
                    [self->mediumDone removeObjectAtIndex:indexPath.row];
                    break;
                case 2:
                    [self->highDone removeObjectAtIndex:indexPath.row];
                    break;
            }
            
            doneTasks = newDone;
            
            [doneTasks addObjectsFromArray:self->lowDone];
            [doneTasks addObjectsFromArray:self->mediumDone];
            [doneTasks addObjectsFromArray:self->highDone];
            
            NSDate *data = [NSKeyedArchiver archivedDataWithRootObject:doneTasks];
            
            [userDefaults setObject:data forKey:@"Done"];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.doneTableView reloadData];
            
            
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
            
        }
        
        [self.doneTableView reloadData];
    }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:yes];
    [alert addAction:no];
    
    [self presentViewController:alert animated:YES completion:^{
        printf("Alert done\n");
    }];
    [self.doneTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EditDoneViewController *editDone = [self.storyboard instantiateViewControllerWithIdentifier:@"EditDoneViewController"];
    
    editDone.task = [doneTasks objectAtIndex:indexPath.row];
    editDone.index = indexPath.row;
        [self.navigationController pushViewController:editDone animated:YES];
}

@end
