#import "EditProgressViewController.h"

@interface EditProgressViewController ()

@end

@implementation EditProgressViewController

static NSMutableArray *inProgressTasks;
static NSMutableArray *doneTasks;
static NSUserDefaults *userDefaults;

+ (void)initialize{
    inProgressTasks = [NSMutableArray new];
    doneTasks = [NSMutableArray new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nameTextField.text = _task.taskName;
    _descriptionTextView.text = _task.taskDescription;
    _dateLabel.text = _task.taskDate;
    
    if([_task.taskPriority isEqualToString: @"Low"]){
        self.prioritySegmentedControl.selectedSegmentIndex = 0;
    }else if([_task.taskPriority isEqual: @"Medium"]){
        self.prioritySegmentedControl.selectedSegmentIndex = 1;
    }else if([_task.taskPriority isEqual: @"High"]){
        self.prioritySegmentedControl.selectedSegmentIndex = 2;
    }
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *date = [userDefaults objectForKey:@"InProgress"];
    inProgressTasks = [NSKeyedUnarchiver unarchiveObjectWithData: date];
}

- (IBAction)editTask:(id)sender {
    if((_nameTextField.text.length > 0) && !([_descriptionTextView.text isEqualToString:@""])){
        Task *task = [Task new];
        task.taskName = _nameTextField.text;
        task.taskDescription = _descriptionTextView.text;
        task.taskDate = _dateLabel.text;
        
        if(self.prioritySegmentedControl.selectedSegmentIndex == 0){
            task.taskImage = @"low";
            task.taskPriority = @"Low";
        }else if(self.prioritySegmentedControl.selectedSegmentIndex == 1){
            task.taskImage = @"medium";
            task.taskPriority = @"Medium";
        }else if(self.prioritySegmentedControl.selectedSegmentIndex == 2){
            task.taskImage = @"high";
            task.taskPriority = @"High";
        }
        
        if(self.stateSegmentedControl.selectedSegmentIndex == 0){
            task.taskState = @"InProgress";
        }else if (self.stateSegmentedControl.selectedSegmentIndex == 1){
            task.taskState = @"Done";
        }
        
        if([task.taskState isEqualToString:@"InProgress"]){
            [inProgressTasks replaceObjectAtIndex:_index withObject:task];
            NSDate *data = [NSKeyedArchiver archivedDataWithRootObject:inProgressTasks];
            [userDefaults setObject:data forKey:@"InProgress"];
            
        }else if ([task.taskState isEqualToString:@"Done"]){
            [inProgressTasks removeObjectAtIndex:_index];
            NSDate *data = [NSKeyedArchiver archivedDataWithRootObject:inProgressTasks];
            [userDefaults setObject:data forKey:@"InProgress"];
            
            if([userDefaults objectForKey:@"Done"] == nil){
                [doneTasks addObject:task];
                NSDate *data = [NSKeyedArchiver archivedDataWithRootObject:doneTasks];
                [userDefaults setObject:data forKey:@"Done"];
            }else if ([userDefaults objectForKey:@"Done"] != nil){
                NSDate *data = [userDefaults objectForKey:@"Done"];
                doneTasks = [NSKeyedUnarchiver unarchiveObjectWithData: data];
                
                [doneTasks addObject:task];
                
                NSDate *date = [NSKeyedArchiver archivedDataWithRootObject:doneTasks];
                [userDefaults setObject:date forKey:@"Done"];
            }
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertController *empty_alert = [UIAlertController alertControllerWithTitle:@"Empty Task" message:@"Please Add the Title And Description" preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [empty_alert addAction: ok];
        [self presentViewController:empty_alert animated:YES completion:nil];
    }
}


@end
