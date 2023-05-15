#import <UIKit/UIKit.h>

@interface TodoViewController : UITableViewController <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *todoTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
