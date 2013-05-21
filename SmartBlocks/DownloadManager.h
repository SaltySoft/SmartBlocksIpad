//
//  DownloadManager.h
//  downloadManager
//
//  Created by Jack Lor on 26/07/12.
//
//

#import <Foundation/Foundation.h>
#import "DataTransferProtocolDelegate.h"

@interface DownloadManager : NSObject <DataTransferProtocolDelegate>
{    
    NSOperationQueue *downloadQueue;
    NSOperationQueue* m_pDownloadQueue3D;   //EMP To manage operation for 3D panel
    NSMutableDictionary *operationDictionary;
    bool connectivity;
}

- (void)addDownloadWithStringUrl:(NSString *)url
                      identifier:(id)identifier
                        delegate:(id <DataTransferProtocolDelegate>)del;

- (void)addUploadWithStringUrl:(NSString *)url
                    identifier:(id)identifier
                      delegate:(id <DataTransferProtocolDelegate>)del
                    dictionary:(NSMutableDictionary *)dico;

- (void)addUploadWithStringUrl:(NSString *)url
                    identifier:(id)identifier
                      delegate:(id <DataTransferProtocolDelegate>)del
                          data:(NSData *)data;

- (void)cancelAllDownload;
- (void)pauseDownloadQueue;
- (void)continueDownloadQueue;

+ (DownloadManager *)downloadManagerSingleton;

@end
