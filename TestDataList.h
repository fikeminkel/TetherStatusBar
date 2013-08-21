#import <Foundation/Foundation.h>

@interface TestDataList : NSObject {
    NSArray *list;
    NSInteger currentPosition;
}

-(TestDataList *) initWithArray:(NSArray *) theList;
-(id) next;

@end
