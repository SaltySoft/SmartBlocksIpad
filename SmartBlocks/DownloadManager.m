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

//EMP
- (void)addDownload3DWithStringUrl:(NSString*)_strURL identifier:(id)_pIdentifier delegate:(id <DataTransferProtocolDelegate>)_pDelegate
{
    NSURLRequest* pRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_strURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    DataTransferOperation* pDataTransferOperation = [[DataTransferOperation alloc] initWithRequest:pRequest identifier:_pIdentifier delegate:self];
    
    connectivity = YES;
    [operationDictionary setObject:_pDelegate forKey:pDataTransferOperation];
    [m_pDownloadQueue3D addOperation:pDataTransferOperation];
}
//END EMP

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

@end
