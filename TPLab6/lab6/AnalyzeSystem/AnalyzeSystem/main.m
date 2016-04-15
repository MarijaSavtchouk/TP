//
//  main.m
//  AnalyzeSystem
//
//  Created by Admin on 08.04.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Analyser.h"
int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        NSLog(@"Enter the string : ");
        NSFileHandle *input = [NSFileHandle fileHandleWithStandardInput];
        NSData *inputData = [NSData dataWithData:[input availableData]];
        NSString *inputString = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];
        inputString = [inputString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        Analyser *analyser = [[Analyser alloc] init];
        NSDictionary* fiveWords = [analyser getFiveMostCommomWords:inputString];
        
        NSArray *sortedWords;
        
        sortedWords = [fiveWords keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                
                return (NSComparisonResult)NSOrderedAscending;
            }
            if ([obj1 integerValue] < [obj2 integerValue]) {
                
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            return (NSComparisonResult)NSOrderedSame;
        }];

        [sortedWords enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL*stop)
         {
             NSLog(@"%@ %@", obj, fiveWords[obj]);

         }];
        
    }
    return 0;
}
