#import <Foundation/Foundation.h>

@interface Task : NSObject <NSCoding>

@property NSString *taskName;
@property NSString *taskDescription;
@property NSString *taskDate;
@property NSString *taskPriority;
@property NSString *taskState;
@property NSString *taskImage;

@end
