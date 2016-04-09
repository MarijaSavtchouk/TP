//
//  Analyser.m
//  AnalyzeSystem
//
//  Created by Admin on 08.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "Analyser.h"

@implementation Analyser

- (NSArray*)getFiveMostCommomWords:(NSString *)text
{
    NSArray *words = [text componentsSeparatedByString:@" "];
    NSMutableDictionary* statistics = [NSMutableDictionary dictionary];
    [words enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL*stop)
    {
        if([obj length]>0)
        {
            NSNumber *repetitions = [statistics valueForKey:obj];
            [statistics setObject:[[NSNumber alloc] initWithLong:([repetitions
                                                               integerValue] + 1)] forKey:obj];
        }
    }];
    
    NSArray *sortedWords;
    
    sortedWords = [statistics keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            
            return (NSComparisonResult)NSOrderedAscending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    NSInteger position = [sortedWords count]>5?5:[sortedWords count];
    NSMutableArray* mutableSortedWords = [NSMutableArray arrayWithArray:sortedWords];
    [mutableSortedWords removeObjectsInRange:NSMakeRange(position, [sortedWords count]-position)];
    return mutableSortedWords;
  
}
@end
