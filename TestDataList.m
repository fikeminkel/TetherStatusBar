#import "TestDataList.h"

@implementation TestDataList

-(TestDataList *) initWithObjects:(id) firstObj, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
    id eachObj;
    va_list arguments;

    if (firstObj) {
        [array addObject:firstObj];
        va_start(arguments, firstObj);
        while ((eachObj = va_arg(arguments, id))) {
            [array addObject:eachObj];
        }
        va_end(arguments);
    }
    return [self initWithArray:array];
}

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
