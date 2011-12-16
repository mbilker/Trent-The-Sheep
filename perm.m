#import <Foundation/Foundation.h>
#import "perm.h"

@implementation NSArray (PermutationAdditions)

NSInteger *pc_next_permutation(NSInteger *p, const NSInteger size) {
    // slide down the array looking for where we're smaller than the next guy
    NSInteger i;
    for (i = size - 1; p[i] >= p[i + 1]; --i) { }

    // if this doesn't occur, we've finished our permutations
    // the array is reversed: (1, 2, 3, 4) => (4, 3, 2, 1)
    if (i == -1)
        return NULL;

    NSInteger j;
    // slide down the array looking for a bigger number than what we found before
    for (j = size; p[j] <= p[i]; --j) { }

    // swap them
    NSInteger tmp = p[i]; p[i] = p[j]; p[j] = tmp;

    // now reverse the elements in between by swapping the ends
    for (++i, j = size; i < j; ++i, --j) {
        tmp = p[i]; p[i] = p[j]; p[j] = tmp;
    }

    return p;
}

- (NSArray *)allPermutations {
    NSInteger size = [self count];
    NSInteger *perm = malloc(size * sizeof(NSInteger));

    for (NSInteger idx = 0; idx < size; ++idx)
        perm[idx] = idx;

    NSInteger j = 0;

    --size;

    NSMutableArray *perms = [NSMutableArray array];

    do {
        NSMutableArray *newPerm = [NSMutableArray array];

        for (NSInteger i = 0; i <= size; ++i)
            [newPerm addObject:[self objectAtIndex:perm[i]]];

        [perms addObject:newPerm];
    } while ((perm = pc_next_permutation(perm, size)) && ++j);

    return perms;
}

@end

int main(int argc, char *argv[]) {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	//NSLog(@"%u",arc4random() % 99);
	//NSArray *array = [NSArray arrayWithObjects:@"a",@"b",@"c", nil];
	//NSString *a = [NSString stringWithFormat:@"%u", (arc4random() + 1)];
	NSString *b = [NSString stringWithFormat:@"%u", (arc4random() + 1)];
	NSString *c = [NSString stringWithFormat:@"%u", (arc4random() + 1)];

	NSLog(@"The Numbers: %@ %@", b, c);
	NSArray *array = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%u", (arc4random() + 1)],b,c, nil];
	NSMutableArray *permutations = nil;

int i = 0;
for (i = 0; i < array.count ; i++){

    if (!permutations){
        permutations = [NSMutableArray array];
        for (NSString *character in array){
            [permutations addObject:[NSArray arrayWithObject:character]];
        }

    } else {

        //make copy of permutations array and clean og array
        NSMutableArray *aCopy = [[permutations copy] autorelease];
        [permutations removeAllObjects];

        for (NSString *character in array){

            //loop through the copy
            for (NSArray *oldArray in aCopy){

                //check if old string contains looping char.. 
                if ([oldArray containsObject:character] == NO){

                    //update array
                    NSMutableArray *newArray = [NSMutableArray arrayWithArray:oldArray];
                    [newArray addObject:character];

                    //add to permutations
                    [permutations addObject:newArray];

                }

            }
        }            
    }



}
NSLog(@"permutations = \n %@",permutations);
NSLog(@"amount = %d",permutations.count);
	[pool release];
	return 0;
}
