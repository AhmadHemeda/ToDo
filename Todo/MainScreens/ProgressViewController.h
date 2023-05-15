#import <UIKit/UIKit.h>
#import "Task.h"

@interface ProgressViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UITableView *progressTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *stateSegmentedControl;

@end
