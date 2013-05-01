//
//  Extension.h
//  artMobile
//
//  Created by Jack Lor on 31/07/12.
//  Copyright (c) 2012 3IE-EPITA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MyExtensions)
- (NSString *)md5;
- (NSString *)sha1;
@end

@interface NSString (URLEncoding)
- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
@end

@interface NSString (StringComparison)
- (BOOL)containsString:(NSString *)string;
- (BOOL)NSStringIsValidEmail;
@end

@interface NSData (MyExtensions)
- (NSString*)md5;
@end

