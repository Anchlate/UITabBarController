//
//  NSData+StanderData.m
//  WanMengHui
//
//  Created by hannchen on 16/8/22.
//  Copyright © 2016年 qing. All rights reserved.
//

#import "NSData+StanderData.h"

@implementation NSData (StanderData)

-(NSData *)standerData{
    NSString *originalStr = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\\n"];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\b" withString:@"\\b"];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    //    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\\" withString:@"、"];
    
    NSData *data =[originalStr dataUsingEncoding:NSUTF8StringEncoding];
    //    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //    NSLog(@"str==%@",str);
    return data;
}
- (NSData *)standerDataDiff{
    NSString *originalStr = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\\n"];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\b" withString:@"\\b"];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\\" withString:@"、"];
    NSData *data =[originalStr dataUsingEncoding:NSUTF8StringEncoding];
    return data;
    
}

-(NSData *)standerDataMessyCode{
    NSString *originalStr = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\\n"];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\b" withString:@"\\b"];
    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    //    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\0" withString:@""];
    //    originalStr = [originalStr stringByReplacingOccurrencesOfString:@"\\" withString:@"、"];
    NSData *data =[originalStr dataUsingEncoding:NSUTF8StringEncoding];
    //        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //        NSLog(@"str==%@",str);
    return data;
    
}

@end
