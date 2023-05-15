#import "TodoViewController.h"
#import "Task.h"
#import "AddViewController.h"
#import "EditViewController.h"

@interface TodoViewController () {
    BOOL isFiltered;
}

@end

@implementation TodoViewController

static NSMutableArray *firstTask;
static NSMutableArray *tasks;
static NSMutableArray *filteredTasks;
static NSUserDefaults *userDefaults;

+ (void)initialize{
    firstTask = [NSMutableArray new];
    tasks = [NSMutableArray new];
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([userDefaults objectForKey:@"Task"] == nil){
        NSDate *data = [NSKeyedArchiver archivedDataWithRootObject:firstTask];
        [userDefaults setObject:data forKey:@"Task"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _todoTable.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [self.todoTable reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    
    NSDate *data = [userDefaults objectForKey:@"Task"];
    tasks = [NSKeyedUnarchiver unarchiveObjectWithData: data];
    [_todoTable reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isFiltered) {
        return filteredTasks.count;
    } else {
        return tasks.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Task *task;
    if (isFiltered) {
        task = [filteredTasks objectAtIndex:indexPath.row];
    } else {
        task = [tasks objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = task.taskName;
    cell.imageView.image = [UIImage imageNamed:task.taskImage];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EditViewController *edit = [self.storyboard instantiateViewControllerWithIdentifier:@"EditViewController"];
    
    edit.task = [tasks objectAtIndex:indexPath.row];
    edit.index = indexPath.row;
    [self.navigationController pushViewController:edit animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Delete Task?" preferredStyle: UIAlertControllerStyleActionSheet];
    
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [tasks removeObjectAtIndex:indexPath.row];
            
            NSDate *date = [NSKeyedArchiver archivedDataWithRootObject:tasks];
            [userDefaults setObject:date forKey:@"Task"];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        }
        [self.todoTable reloadData];
    }];
    
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:yes];
    [alert addAction:no];
    
    [self presentViewController:alert animated:YES completion:^{
        printf("Alert done\n");
    }];
    [_todoTable reloadData];
}

- (IBAction)addTask:(id)sender {
    AddViewController *add = [self.storyboard instantiateViewControllerWithIdentifier:@"AddViewController"];
    
    [self presentViewController:add animated:YES completion:nil];
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    if (searchText.length == 0) {
//        filteredTasks = [tasks mutableCopy];
//    } else {
//        filteredTasks = [[NSMutableArray alloc] init];
//        for (Task *task in tasks) {
//            NSRange range = [task.taskName rangeOfString:searchText options:NSCaseInsensitiveSearch];
//            if (range.location != NSNotFound) {
//                [filteredTasks addObject:task];
//            }
//        }
//    }
//    [_todoTable reloadData];
//}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length == 0){
        isFiltered = false;
        filteredTasks = nil;
    } else{
        isFiltered = true;
        filteredTasks = [[NSMutableArray alloc] init];
        for(Task *loopedTask in tasks){
            NSRange nameRange = [loopedTask.taskName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(nameRange.location != NSNotFound){
                [filteredTasks addObject:loopedTask];
            }
        }
    }
    [_todoTable reloadData];
}

@end
