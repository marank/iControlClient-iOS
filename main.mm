//
//  main.m
//  iControlClient
//
//  Created by Matthias Rank on 24.05.15.
//  Copyright (c) 2015 Matthias Rank. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FastSocket.h"

int main(int argc, const char * argv[]) {
	@autoreleasepool {

		if (argc != 3) {
			printf("Usage: %s <Server IP> <Message>\n", argv[0]);
			exit(1);
		}

		NSString *port = @"31313";

		FastSocket *socket = [[FastSocket alloc] initWithHost:[NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding]
													  andPort:port];

		[socket setTimeout:5];

		if ([socket connect:5] == NO) {
			printf("Could not connect to %s\n", argv[1]);
			exit(1);
		};

		NSString *message = [NSString stringWithCString:argv[2] encoding:NSASCIIStringEncoding];
		NSData *data = [message dataUsingEncoding:NSASCIIStringEncoding];
		[socket sendBytes:[data bytes] count:[data length]];

		char bytes[1024];
		BOOL keep_recv = true;

		while (keep_recv) {
			long recv_count = [socket receiveBytes:bytes limit:1024];
			if (recv_count <= 0) {
				keep_recv = false;
			} else {
				NSString *received = [[NSString alloc] initWithBytes:bytes length:recv_count encoding:NSUTF8StringEncoding];
				if ([received isEqualToString:@"::ok"]) {
					keep_recv = false;
				} else {
					printf("%s\n", [received cStringUsingEncoding:NSASCIIStringEncoding]);
				}
			}
		}

		[socket close];
		exit (0);
	}
    return 0;
}
