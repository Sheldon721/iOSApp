//
//  APiRequest.m
//  zhihuDaily
//
//  Created by 李晓东 on 16/3/16.
//  Copyright © 2016年 李晓东.zhihuDaily. All rights reserved.
//

#import "APIRequest.h"
#import "GCDUtil.h"
#import "MD5Util.h"

@implementation APIRequest
+ (void)requestWithUrl:(NSString*)url
{
  [self requestWithUrl:url completion:nil];
}
+ (void)requestWithUrl:(NSString*)url
            completion:(void (^)(id data, NSString* md5))completion
{
  NSURLSession* session = [NSURLSession sharedSession];
  NSURL* requestURL = [NSURL URLWithString:url];

  [[session
      dataTaskWithURL:requestURL
    completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
      [[GCDUtil globalQueueWithLevel:DEFAULT] async:^{
        NSHTTPURLResponse* responseFromServer = (NSHTTPURLResponse*)response;
        if (data != nil && error == nil &&
            responseFromServer.statusCode == 200) {
          NSError* parseError = nil;
          id result = [NSJSONSerialization JSONObjectWithData:data
                                                      options:0
                                                        error:&parseError];
          NSString* json =
            [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          NSString* md5 = [MD5Util MD5ByAStr:json];
          if (parseError)
            return;
          if (completion != nil) {
            [[GCDUtil mainQueue] async:^{
              completion(result, md5);
            }];
          }
        }
      }];
    }] resume];
}
+ (NSDictionary*)objToDic:(id)object
{
  if ([object isKindOfClass:[NSDictionary class]]) {
    return (NSDictionary*)object;
  }
  return nil;
}
@end
