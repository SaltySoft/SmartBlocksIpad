//
//  DataTransferOperation.m
//  artMobile
//
//  Created by Jack Lor on 30/07/12.
//  Copyright (c) 2012 3IE-EPITA. All rights reserved.
//

#import "DataTransferOperation.h"

@implementation DataTransferOperation

@synthesize identifier, delegate, request, taskIsFinished, taskIsExecuting;
@synthesize connectionInProgress, fileData, fileLength;

- (id)initWithRequest:(NSURLRequest *)req
           identifier:(id)ident
             delegate:(id <DataTransferProtocolDelegate>)del
{
    self = [super init];
    
    [self setIdentifier:ident];
    [self setDelegate:del];
    
    fileData = [[NSMutableData alloc] init];
    request = req;
    connectionInProgress = [[NSURLConnection alloc] initWithRequest:req delegate:self startImmediately:NO];
    //[self traceOperation:self];
    return self;
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - call functions

- (void)cancel
{
    [connectionInProgress cancel];
    [self willChangeValueForKey:@"isFinished"]; //EMP
    taskIsFinished = YES;
    [self didChangeValueForKey:@"isFinished"]; //EMP
    
    [self willChangeValueForKey:@"isExecuting"]; //EMP
    taskIsExecuting = NO;
    [self didChangeValueForKey:@"isExecuting"]; //EMP
    
    [super cancel];
}

-(void)main
{
    [connectionInProgress scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [connectionInProgress start];
    
    while(!(taskIsFinished))
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

- (void)start
{
    if ([self isCancelled] || self->request == nil)
    {
        /* If this operation *is* cancelled */
        /* KVO compliance */
        [self willChangeValueForKey:@"isFinished"]; //EMP
        taskIsFinished = YES;
        [self didChangeValueForKey:@"isFinished"];
    }
    else
    {
        /* If this operation is *not* cancelled */
        /* KVO compliance */
        [self willChangeValueForKey:@"isExecuting"];
        taskIsExecuting = YES;
        /* Call the main method from inside the start method */
        [self main];
        [self didChangeValueForKey:@"isExecuting"];
    }
}

- (BOOL)isFinished
{
    return taskIsFinished;
}

- (BOOL)isConcurrent
{
    //EMP return [super isConcurrent];
    return YES;
}

- (BOOL)isExecuting
{
    return taskIsExecuting;
}

#pragma mark - KVO
/* EMP
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    //EMP NSLog(@"Value is changed: %@",keyPath);
}

-(void)traceOperation:(NSOperation*)obj
{
	[obj addObserver:self
          forKeyPath:@"isExecuting"
             options:0
             context:NULL];
	[obj addObserver:self
          forKeyPath:@"isFinished"
             options:0
             context:NULL];
	[obj addObserver:self
		  forKeyPath:@"isCancelled"
			 options:0
			 context:NULL];
}
*/

#pragma mark - NSURLConnection Delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    fileLength = [response expectedContentLength];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [fileData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.delegate didFinishWithSender:self WithData:fileData];
    
    [self willChangeValueForKey:@"isExecuting"];    //EMP
    taskIsExecuting = NO;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self willChangeValueForKey:@"isFinished"]; //EMP
    taskIsFinished = YES;
    [self didChangeValueForKey:@"isFinished"];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.delegate didFailWithSender:self WithError:error];

    [self willChangeValueForKey:@"isExecuting"];
    taskIsExecuting = NO;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self willChangeValueForKey:@"isFinished"];
    taskIsFinished = YES;
    [self didChangeValueForKey:@"isFinished"];
}

@end

