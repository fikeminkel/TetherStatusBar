#import "TestDataList.h"

@implementation TestDataList

-(TestDataList *) initWithArray:(NSArray *)theList
{
    self = [self init];
    if (self) {
        list = [theList retain];
        currentPosition = 0;
    }
    return self;
}
-(id) next
{
    id nextItem = [list objectAtIndex:currentPosition];
    currentPosition = (currentPosition >= list.count - 1) ? 0 : (currentPosition + 1);
    return nextItem;
}

-(void) dealloc
{
    [list release];
    list = nil;
    [super dealloc];
}
@end
