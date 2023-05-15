#import "ProgressViewController.h"
#import "EditProgressViewController.h"

@interface ProgressViewController ()

@end

@implementation ProgressViewController {
    Task *task;
    NSMutableArray *lowProgress;
    NSMutableArray *mediumProgress;
    NSMutableArray *highProgress;
}

static NSMutableArray *progressTasks;
static NSUserDefaults *userDefaults;

+ (void)initialize{
    progressTasks = [NSMutableArray new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    [self.progressTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    self.stateSegmentedControl.selectedSegmentIndex = UISegmentedControlNoSegment;
    
    NSDate *date = [userDefaults objectForKey:@"InProgress"];
    progressTasks = [NSKeyedUnarchiver unarchiveObjectWithData: date];
    
    [self.progressTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    
    lowProgress = [NSMutableArray new];
    mediumProgress = [NSMutableArray new];
    highProgress = [NSMutableArray new];
    
    task = [Task new];
    
    for (int i = 0; i < progressTasks.count; i++) {
        
        task = [progressTasks objectAtIndex:i];
        
        if([[[progressTasks objectAtIndex:i] taskPriority] isEqualToString:@"Low"]){
            [lowProgress addObject:task];
        }
        else if ([[[progressTasks objectAtIndex:i] taskPriority] isEqualToString:@"Medium"]){
            [mediumProgress addObject:task];
        }
        else if ([[[progressTasks objectAtIndex:i] taskPriority] isEqualToString:@"High"]){
            [highProgress addObject:task];
        }
    }
    [self.progressTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
    
    switch (self.stateSegmentedControl.selectedSegmentIndex) {
        case 0:
            numberOfRows = lowProgress.count;
            break;
        case 1:
            numberOfRows = mediumProgress.count;
            break;
        case 2:
            numberOfRows = highProgress.count;
            break;
        default:
            break;
    }
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Task *task = nil;
    
    switch (self.stateSegmentedControl.selectedSegmentIndex) {
        case 0:
            task = lowProgress[indexPath.row];
            break;
        case 1:
            task = mediumProgress[indexPath.row];
            break;
        case 2:
            task = highProgress[indexPath.row];
            break;
        default:
            break;
    }
    
    cell.textLabel.text = task.taskName;
    
    // Set the image based on task priority
    NSString *imageName = @"";
    if ([task.taskPriority isEqualToString:@"Low"]) {
        imageName = @"low";
    } else if ([task.taskPriority isEqualToString:@"Medium"]) {
        imageName = @"medium";
    } else if ([task.taskPriority isEqualToString:@"High"]) {
        imageName = @"high";
    }
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *priority = @"";
    
    switch (self.stateSegmentedControl.selectedSegmentIndex) {
        case 0:
            priority = @"Low";
            break;
        case 1:
            priority = @"Medium";
            break;
        case 2:
            priority = @"High";
            break;
        default:
            break;
    }
    
    return priority;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Delete Task?" preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableArray *progress = [NSMutableArray new];
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            switch(indexPath.section){
                case 0:
                    [self->lowProgress removeObjectAtIndex:indexPath.row];
                    break;
                case 1 :
                    [self->mediumProgress removeObjectAtIndex:indexPath.row];
                    break;
                case 2:
                    [self->highProgress removeObjectAtIndex:indexPath.row];
                    break;
            }
            progressTasks = progress;
            
            [progressTasks addObjectsFromArray:self->lowProgress];
            [progressTasks addObjectsFromArray:self->mediumProgress];
            [progressTasks addObjectsFromArray:self->highProgress];
            
            NSDate *date = [NSKeyedArchiver archivedDataWithRootObject:progressTasks];
            
            [userDefaults setObject:date forKey:@"InProgress"];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.progressTableView reloadData];
            
            
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
            
        }
        
        [self.progressTableView reloadData];
    }];
    
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:yes];
    [alert addAction:no];
    
    [self presentViewController:alert animated:YES completion:^{
        printf("Alert done\n");
    }];
    [self.progressTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EditProgressViewController *editProgress = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProgressViewController"];
    
    editProgress.task = [progressTasks objectAtIndex:indexPath.row];
    editProgress.index = indexPath.row;
    [self.navigationController pushViewController:editProgress animated:YES];
}

- (IBAction)stateActionProgress:(id)sender {
    [self.progressTableView reloadData];
}

@end
