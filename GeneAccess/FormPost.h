//
//  FormPost.h
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 6/3/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FormPost : NSObject<NSURLConnectionDelegate>
{
    NSMutableData *_responseData;
}
@property(strong, nonatomic) NSString *url;
@property(strong, nonatomic) NSString *post;
@property(strong, nonatomic) NSString *response;
-(void)postForm;
@end
