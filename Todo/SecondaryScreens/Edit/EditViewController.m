#import "EditViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController

static NSMutableArray *todoTasks;
static NSMutableArray *inProgressTasks;
static NSMutableArray *doneTasks;
static NSUserDefaults *userDefaults;

+ (void)initialize{
    todoTasks = [NSMutableArray new];
    inProgressTasks = [NSMutableArray new];
    doneTasks = [NSMutableArray new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _nameTextField.text = _task.taskName;
    _descriptionTextView.text = _task.taskDescription;
    _dateLabel.text = _task.taskDate;
    
    if([_task.taskPriority isEqualToString: @"Low"]) {
        self.prioritySegmentedControl.selectedSegmentIndex = 0;
    }else if([_task.taskPriority isEqual: @"Medium"]){
        self.prioritySegmentedControl.selectedSegmentIndex = 1;
    }else if([_task.taskPriority isEqual: @"High"]){
        self.prioritySegmentedControl.selectedSegmentIndex = 2;
    }
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDate *date = [userDefaults objectForKey:@"Task"];
    todoTasks = [NSKeyedUnarchiver unarchiveObjectWithData: date];
}

- (IBAction)editTask:(id)sender {
    
    if((_nameTextField.text.length > 0) && !([_descriptionTextView.text isEqualToString:@""])){
        Task *tast = [Task new];
        tast.taskName = _nameTextField.text;
        tast.taskDescription = _descriptionTextView.text;
        tast.taskDate =_dateLabel.text;
        
        if(self.prioritySegmentedControl.selectedSegmentIndex == 0){
            tast.taskImage = @"low";
            tast.taskPriority = @"Low";
        }else if (self.prioritySegmentedControl.selectedSegmentIndex == 1){
            tast.taskImage = @"medium";
            tast.taskPriority = @"Medium";
        }else if(self.prioritySegmentedControl.selectedSegmentIndex == 2){
            tast.taskImage = @"high";
            tast.taskPriority = @"High";
        }
        
        if(self.stateSegmentedControl.selectedSegmentIndex == 0){
            tast.taskState = @"Todo";
        }else if (self.stateSegmentedControl.selectedSegmentIndex == 1){
            tast.taskState = @"InProgress";
        }else if(self.stateSegmentedControl.selectedSegmentIndex == 2){
            tast.taskState = @"Done";
        }
        
        if([tast.taskState isEqualToString:@"Todo"]){
            [todoTasks replaceObjectAtIndex:_index withObject:tast];
            NSDate *date = [NSKeyedArchiver archivedDataWithRootObject:todoTasks];
            [userDefaults setObject:date forKey:@"Task"];
            
        }
        else if([tast.taskState isEqualToString:@"InProgress"]){
            [todoTasks removeObjectAtIndex:_index];
            NSDate *date = [NSKeyedArchiver archivedDataWithRootObject:todoTasks];
            [userDefaults setObject:date forKey:@"Task"];
            
            NSUserDefaults *userDefaultsProgress = [NSUserDefaults standardUserDefaults];
            
            if([userDefaults objectForKey:@"InProgress"] == nil){
                [inProgressTasks addObject:tast];
                NSDate *date = [NSKeyedArchiver archivedDataWithRootObject:inProgressTasks];
                [userDefaultsProgress setObject:date forKey:@"InProgress"];
            }
            else if ([userDefaults objectForKey:@"InProgress"] != nil){
                NSData *data = [userDefaultsProgress objectForKey:@"InProgress"];
                inProgressTasks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                
                [inProgressTasks addObject:tast];
                NSDate *date = [NSKeyedArchiver archivedDataWithRootObject:inProgressTasks];
                [userDefaultsProgress setObject:date forKey:@"InProgress"];
            }
            
        }
        else if([tast.taskState isEqualToString:@"Done"]){
            [todoTasks removeObjectAtIndex:_index];
            NSDate *date = [NSKeyedArchiver archivedDataWithRootObject:todoTasks];
            [userDefaults setObject:date forKey:@"Task"];
            
            NSUserDefaults *userDefaultsDone = [NSUserDefaults standardUserDefaults];
            
            if([userDefaults objectForKey:@"Done"] == nil){
                [doneTasks addObject:tast];
                NSDate *data = [NSKeyedArchiver archivedDataWithRootObject:doneTasks];
                [userDefaultsDone setObject:data forKey:@"Done"];
            }else if([userDefaults objectForKey:@"Done"] != nil){
                NSData *data = [userDefaultsDone objectForKey:@"Done"];
                doneTasks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                
                [doneTasks addObject:tast];
                NSDate *date = [NSKeyedArchiver archivedDataWithRootObject:doneTasks];
                [userDefaultsDone setObject:date forKey:@"Done"];
            }
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        UIAlertController *empty_alert = [UIAlertController alertControllerWithTitle:@"Empty Task" message:@"Please Add the Title And Description" preferredStyle: UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [empty_alert addAction: ok];
        [self presentViewController:empty_alert animated:YES completion:nil];
    }
    
}

@end
