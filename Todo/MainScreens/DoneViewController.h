#import <UIKit/UIKit.h>
#import "Task.h"

@interface DoneViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITableView *doneTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *stateSegmentedControl;

@property int index;

@end
