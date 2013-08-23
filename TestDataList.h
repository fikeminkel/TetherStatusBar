#import <Foundation/Foundation.h>

@interface TestDataList : NSObject {
    NSArray *list;
    NSInteger currentPosition;
}

-(TestDataList *) initWithObjects:(id) firstObj, ... NS_REQUIRES_NIL_TERMINATION;
-(TestDataList *) initWithArray:(NSArray *) theList;
-(id) next;

@end
