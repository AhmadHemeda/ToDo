#import "EditDoneViewController.h"

@interface EditDoneViewController ()

@end

@implementation EditDoneViewController

static NSMutableArray *doneTasks;
static NSUserDefaults *userDefaults;

+ (void)initialize{
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
    
    NSDate *data = [userDefaults objectForKey:@"Done"];
    doneTasks = [NSKeyedUnarchiver unarchiveObjectWithData: data];
}

@end
