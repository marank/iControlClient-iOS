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

		BOOL fixedHost;
		NSString *host;
		NSString *port = @"31313";
		int requiredArguments;

		// First of all, check preferences
		NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/de.marank.icontrolclientprefs.plist"]];
		fixedHost = [[prefs objectForKey:@"fixedhost"] boolValue];
		if (fixedHost) {
			host = [prefs objectForKey:@"hostaddress"];
			requiredArguments = 2;
		} else {
			requiredArguments = 3;
		}

		// Check argument count
		if (argc < requiredArguments) {
			if (fixedHost) {
				printf("Usage: %s [Command]\n", argv[0]);
			} else {
				printf("Usage: %s [Server IP] [Commands]\n", argv[0]);
			}
			exit(1);
		}

		// Compute commands: if argc > requiredArguments, assume that every following argument is part of the command
		NSString *message;
		if (argc > requiredArguments) {
			NSMutableArray * array = [[NSMutableArray alloc] init];

			int count = requiredArguments-1;
			while(count < argc) {
				[array addObject: [NSString stringWithCString:argv[count] encoding:NSASCIIStringEncoding]];
				count++;
			}
			message = [array componentsJoinedByString:@" "];
		} else {
			message = [NSString stringWithCString:argv[requiredArguments-1] encoding:NSASCIIStringEncoding];
		}

		// Host = first argument if no fixed host is used
		if (!fixedHost) {
			host = [NSString stringWithCString:argv[1] encoding:NSASCIIStringEncoding];
		}

		FastSocket *socket = [[FastSocket alloc] initWithHost:host andPort:port];

		[socket setTimeout:5];

		if ([socket connect:5] == NO) {
			printf("Could not connect to %s\n", argv[1]);
			exit(1);
		};

		// Send the message to the server
		NSData *data = [message dataUsingEncoding:NSASCIIStringEncoding];
		[socket sendBytes:[data bytes] count:[data length]];

		// Receive data from the server
		char bytes[1024];
		BOOL keep_recv = true;

		// Keep receiving until server sends "::ok" or no data is received anymore
		while (keep_recv) {
			long recv_count = [socket receiveBytes:bytes limit:1024];
			if (recv_count <= 0) {
				keep_recv = false;
			} else {
				NSString *received = [[NSString alloc] initWithBytes:bytes length:recv_count encoding:NSASCIIStringEncoding];
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
