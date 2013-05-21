//
//  DownloadManager.m
//  downloadManager
//
//  Created by Jack Lor on 26/07/12.
//
//

#import "DownloadManager.h"
#import "DataTransferOperation.h"
#import "SVProgressHUD.h"

@implementation DownloadManager

- (id)init
{
    self = [super init];
    
    downloadQueue = [[NSOperationQueue alloc] init];
    //EMP
    [downloadQueue setMaxConcurrentOperationCount:16];
    
    m_pDownloadQueue3D = [[NSOperationQueue alloc] init];
//    [m_pDownloadQueue3D setMaxConcurrentOperationCount:2];
    //END EMP
    
    operationDictionary = [[NSMutableDictionary alloc] init];
    connectivity = YES;
    return self;
}

+ (DownloadManager *)downloadManagerSingleton
{
    static DownloadManager *object = nil;
    
    if (!object)
        object = [[DownloadManager alloc] init];
    return object;
}

- (void)addDownloadWithStringUrl:(NSString *)url
                      identifier:(id)identifier
                        delegate:(id <DataTransferProtocolDelegate>)del
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    DataTransferOperation *download = [[DataTransferOperation alloc] initWithRequest:request identifier:identifier delegate:self];

    connectivity = YES;
    [operationDictionary setObject:del forKey:download];
    [downloadQueue addOperation:download];
}

- (void)addUploadWithStringUrl:(NSString *)url
                    identifier:(id)identifier
                      delegate:(id <DataTransferProtocolDelegate>)del
                    dictionary:(NSMutableDictionary *)dico
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *stringBoundary = @"0xKhTmLbOuNdArY";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[DownloadManager createPostBodyWithDictionary:dico]];
    
    DataTransferOperation *upload = [[DataTransferOperation alloc] initWithRequest:request identifier:identifier delegate:self];
    
    [operationDictionary setObject:del forKey:upload];
    [downloadQueue addOperation:upload];
}

- (void)addUploadWithStringUrl:(NSString *)url
                    identifier:(id)identifier
                      delegate:(id <DataTransferProtocolDelegate>)del
                    data:(NSData *)data
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *contentType = @"text/html";
    
    [request setHTTPMethod:@"POST"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    [request setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
    
    DataTransferOperation *upload = [[DataTransferOperation alloc] initWithRequest:request identifier:identifier delegate:self];
    
    [operationDictionary setObject:del forKey:upload];
    [downloadQueue addOperation:upload];
}

#pragma mark - call functions

- (void)cancelAllDownload
{
    [downloadQueue cancelAllOperations];
    [operationDictionary removeAllObjects];
}

- (void)pauseDownloadQueue
{
    [downloadQueue setSuspended:YES];
}

- (void)continueDownloadQueue
{
    [downloadQueue setSuspended:NO];
}

#pragma mark - DownloadProtocolDelegate

- (void)didFinishWithSender:(id)download WithData:(NSData *)data
{
    id <DataTransferProtocolDelegate> del = [operationDictionary objectForKey:download];
    [del didFinishWithSender:download WithData:data];
    [operationDictionary removeObjectForKey:download];
    connectivity = YES;
}

- (void)didFailWithSender:(id)download WithError:(NSError *)error
{
    if ([SVProgressHUD isVisible])
        [SVProgressHUD dismiss];
    
    //id <DataTransferProtocolDelegate> del = [operationDictionary objectForKey:download];
    
#ifdef DEBUG_MODE
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Download error!" message:error.description delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
#else
    [self performSelectorOnMainThread:@selector(displayError:) withObject:error waitUntilDone:YES];
#endif
    
    //[del didFailWithSender:download WithError:error];
    [operationDictionary removeObjectForKey:download];
}


- (void)displayError:(NSError *)error
{
    NSString *errmsg = @"Une erreur est survenue";
    
    if (error.code == -1009)
        errmsg = error.localizedDescription;
    
    if (connectivity == YES)
    {
        connectivity = NO;
        UIAlertView *alerts = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Problème de connectivité",) message:errmsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alerts show];
    }
}

+ (NSData *)createPostBodyWithDictionary:(NSMutableDictionary *)dico
{
    const NSString *stringBoundary = @"0xKhTmLbOuNdArY";
    NSMutableData *postBody = [NSMutableData data];
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    for(NSString *aKey in dico)
    {
        //NSLog(@"Key: %@", aKey);
        [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        if ([[dico valueForKey:aKey] isKindOfClass:[NSString class]])
        {
            //NSLog(@"this is a string");
            [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", aKey] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[[dico valueForKey:aKey] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        else
        {
            //NSLog(@"this is a data");
            [postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n\r\n", aKey, aKey] dataUsingEncoding:NSUTF8StringEncoding]];
            [postBody appendData:[NSData dataWithData:[dico valueForKey:aKey]]];
        }
        [postBody appendData:[[NSString stringWithFormat:@"\r\n--%@", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [postBody appendData:[@"--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //NSLog(@"%@", postBody);
    
    return postBody;
}

@end
