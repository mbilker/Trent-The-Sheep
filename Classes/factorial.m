#import "factorial.h"

NSUInteger RRFactorial(NSUInteger n)
{
    // Use preprocessor macros to determine the maximum value of n computable
    // within the limits prescribed by NSUInteger, whose bit-width depends on
    // architecture: either 64 or 32 bits.
#if __LP64__ || NS_BUILD_32_LIKE_64
#define N 20 // 20! = 2,432,902,008,176,640,000
#else
#define N 12 // 12! = 479,001,600
#endif
    if (n > N) return NSUIntegerMax;
    static NSUInteger f[N + 1];
    static NSUInteger i = 0;
    if (i == 0)
    {
        f[0] = 1;
        i = 1;
    }
    while (i <= n)
    {
        f[i] = i * f[i - 1];
        i++;
    }
    return f[n];
}

//int main(int argc, char *argv[])
//{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    NSUInteger n;
//    for (n = 0; n < 20; n++)
//    {
//        NSLog(@"%lu %lu", (unsigned long)n, (unsigned long)RRFactorial(n));
//    }
//    [pool drain];
//    return 0;
//}
