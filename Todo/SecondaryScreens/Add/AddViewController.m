#import "AddViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController

static NSMutableArray *todo;

+ (void)initialize{
    todo = [NSMutableArray new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _dateLabel.text = [dateFormatter stringFromDate:[NSDate date]];
}

- (IBAction)addTask:(id)sender {
    
    NSString *name = [_nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *description = [_descriptionTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (name.length > 0 && description.length > 0 && self.prioritySegmentedControl.selectedSegmentIndex >= 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add Task"
                                                                       message:@"Are you sure you want to add this task?"
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes"
                                                      style:UIAlertActionStyleDestructive
                                                    handler:^(UIAlertAction * _Nonnull action) {
            NSData *data = [self->_userDefaults objectForKey:@"Task"];
            todo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            Task *task = [Task new];
            
            task.taskName = name;
            task.taskDescription = description;
            task.taskDate = self->_dateLabel.text;
            
            switch (self.prioritySegmentedControl.selectedSegmentIndex) {
                case 0:
                    task.taskImage = @"low";
                    task.taskPriority = @"Low";
                    break;
                case 1:
                    task.taskImage = @"medium";
                    task.taskPriority = @"Medium";
                    break;
                case 2:
                    task.taskImage = @"high";
                    task.taskPriority = @"High";
                    break;
                default:
                    task.taskImage = @"low";
                    task.taskPriority = @"Low";
                    break;
            }
            
            [todo addObject:task];
            
            NSData *newData = [NSKeyedArchiver archivedDataWithRootObject:todo];
            [self->_userDefaults setObject:newData forKey:@"Task"];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"No"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:yes];
        [alert addAction:no];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        NSMutableString *errorMessage = [NSMutableString new];
        
        if (name.length == 0) {
            [errorMessage appendString:@"\n- Please enter a task name"];
        }
        if (description.length == 0) {
            [errorMessage appendString:@"\n- Please enter a task description"];
        }
        if (self.prioritySegmentedControl.selectedSegmentIndex < 0) {
            [errorMessage appendString:@"\n- Please choose a task priority"];
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Invalid Task"
                                                                       message:errorMessage
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

@end
