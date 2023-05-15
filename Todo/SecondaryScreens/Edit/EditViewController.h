#import <UIKit/UIKit.h>
#import "Task.h"

@interface EditViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *stateSegmentedControl;

@property Task *task;
@property int index;

@end
