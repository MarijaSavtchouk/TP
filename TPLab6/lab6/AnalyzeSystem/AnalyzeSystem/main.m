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
        NSArray* fiveWords = [analyser getFiveMostCommomWords:inputString];
        for(NSString* word in fiveWords)
        {
            NSLog(@"%@",word);
        }
    }
    return 0;
}
