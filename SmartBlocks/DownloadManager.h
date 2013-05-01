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

//EMP
- (void)addDownload3DWithStringUrl:(NSString*)_strURL identifier:(id)_pIdentifier delegate:(id <DataTransferProtocolDelegate>)_pDelegate;

- (void)cancelAllDownload;
- (void)pauseDownloadQueue;
- (void)continueDownloadQueue;

+ (DownloadManager *)downloadManagerSingleton;

@end
