#import "Task.h"

@implementation Task

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_taskName forKey:@"name"];
    [coder encodeObject:_taskDescription forKey:@"description"];
    [coder encodeObject:_taskDate forKey:@"date"];
    [coder encodeObject:_taskPriority forKey:@"priority"];
    [coder encodeObject:_taskImage forKey:@"image"];
    [coder encodeObject:_taskState forKey:@"state"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self.taskName = [coder decodeObjectForKey:@"name"];
    self.taskDescription = [coder decodeObjectForKey:@"description"];
    self.taskDate = [coder decodeObjectForKey:@"date"];
    self.taskPriority = [coder decodeObjectForKey:@"priority"];
    self.taskImage = [coder decodeObjectForKey:@"image"];
    self.taskState = [coder decodeObjectForKey:@"state"];
    
    return self;
}

@end
