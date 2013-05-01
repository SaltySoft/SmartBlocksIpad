//
//  DataTransferProtocolDelegate.h
//  artMobile
//
//  Created by Jack Lor on 31/07/12.
//  Copyright (c) 2012 3IE-EPITA. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataTransferProtocolDelegate <NSObject>

@required
- (void)didFinishWithSender:(id)download WithData:(NSData *)data;

@optional
- (void)didFailWithSender:(id)download WithError:(NSError *)error;

@end
