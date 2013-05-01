//
//  DataTransferOperation.h
//  artMobile
//
//  Created by Jack Lor on 30/07/12.
//  Copyright (c) 2012 3IE-EPITA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataTransferProtocolDelegate.h"

@interface DataTransferOperation : NSOperation<NSCopying, NSURLConnectionDataDelegate>

@property (nonatomic, strong)	NSURLConnection		*connectionInProgress;
@property (nonatomic, strong)	NSMutableData		*fileData;
@property float										fileLength;
@property (nonatomic, strong)	NSURLRequest		*request;
@property (nonatomic, strong)	id					identifier;
@property (nonatomic, strong)	id <DataTransferProtocolDelegate> delegate;
@property (nonatomic)			BOOL				taskIsFinished;
@property (nonatomic)			BOOL				taskIsExecuting;


- (id)initWithRequest:(NSURLRequest *)req
           identifier:(id)ident
             delegate:(id <DataTransferProtocolDelegate>)del;

@end
