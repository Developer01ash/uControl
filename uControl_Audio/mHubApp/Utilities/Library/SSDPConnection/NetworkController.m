//
//  NetworkController.m
//
//  Copyright (c) 2012 Peter Bakhirev <peter@byteclub.com>
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//  
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.

#import "NetworkController.h"


#pragma mark - Private properties and methods

@interface NetworkController () {
  NSString* messageDelimiter;
}

- (BOOL)openConnection;
- (void)closeConnection;
- (BOOL)isConnected;
- (void)finishOpeningConnection;
- (void)readFromStreamToInputBuffer;
- (void)parseIncomingData;
- (void)writeOutputBufferToStream;
- (void)notifyConnectionBlock:(ConnectionBlock)block;

@end


@implementation NetworkController
@synthesize host, port;
@synthesize messageReceivedBlock;
@synthesize connectionOpenedBlock, connectionFailedBlock, connectionClosedBlock;


#pragma mark - Singleton

static id sharedInstance = nil;

+ (void)initialize {
  if (self == [NetworkController class]) {
    sharedInstance = [[self alloc] init];
  }
}

+ (NetworkController*)sharedInstance {
  return sharedInstance;
}


#pragma mark - Public methods

- (void)connect {
  if (![self isConnected]) {
    if (![self openConnection]) {
      [self notifyConnectionBlock:connectionFailedBlock];
    }
  } 
}

- (void)disconnect {
  [self closeConnection];
}

- (void)sendMessage:(NSString*)message {
  [outputBuffer appendBytes:[message cStringUsingEncoding:NSASCIIStringEncoding]
                           length:[message length]];
  [outputBuffer appendBytes:[messageDelimiter cStringUsingEncoding:NSASCIIStringEncoding]
                           length:[messageDelimiter length]];

  [self writeOutputBufferToStream];
}

#pragma mark - Private methods

- (id)init {
    // This might come from some configuration store or Bonjour.
    host = @"localhost";
    port = 80;
    messageDelimiter = @"\n";
    return self;
}

- (BOOL)openConnection {
  // Nothing is open at the moment.
  isInputStreamOpen = NO;
  isOutputStreamOpen = NO;
  
  // Setup socket connection
  CFReadStreamRef readStream;
  CFWriteStreamRef writeStream;

  CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                     (__bridge CFStringRef)host, port,
                                     &readStream, &writeStream);

  if (readStream == nil || writeStream == nil)
    return NO;

  // Indicate that we want socket to be closed whenever streams are closed.
  CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket,
                          kCFBooleanTrue);
  CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket,
                           kCFBooleanTrue);

  // Setup input stream.
  inputStream = (__bridge_transfer NSInputStream*)readStream;
  inputStream.delegate = self;
  [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
  [inputStream open];

  // Setup output stream.
  outputStream = (__bridge_transfer NSOutputStream*)writeStream;
  outputStream.delegate = self;
  [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
  [outputStream open];

  // Setup buffers.
  inputBuffer = [[NSMutableData alloc] init];
  outputBuffer = [[NSMutableData alloc] init];

  return YES;
}

- (void)closeConnection {
  // Notify world.
  if (![self isConnected])
    [self notifyConnectionBlock:connectionFailedBlock];
  else
    [self notifyConnectionBlock:connectionClosedBlock];
  
  // Clean up input stream.
  inputStream.delegate = nil;
  [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
  [inputStream close];
  inputStream = nil;
  isInputStreamOpen = NO;
  
  // Clean up output stream.
  outputStream.delegate = nil;
  [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
  [outputStream close];
  outputStream = nil;
  isOutputStreamOpen = NO;
  
  // Clean up buffers.
  inputBuffer = nil;
  outputBuffer = nil;
}

- (BOOL)isConnected {
  return (isInputStreamOpen && isOutputStreamOpen);
}

- (void)finishOpeningConnection {
    @try {
        if (isInputStreamOpen && isOutputStreamOpen) {
            [self notifyConnectionBlock:connectionOpenedBlock];
            [self writeOutputBufferToStream];
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)readFromStreamToInputBuffer {
    @try {
        // Temporary buffer to read data into.
        uint8_t buffer[1024];
        
        // Try reading while there is data.
        while ([inputStream hasBytesAvailable]) {
            NSInteger bytesRead = [inputStream read:buffer maxLength:sizeof(buffer)];
            if (bytesRead > -1) {
                [inputBuffer appendBytes:buffer length:bytesRead];
            }
        }
        
        // Do protocol-specific processing of data.
        [self parseIncomingData];
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

// Customization point: protocol-specific logic is here.
//
- (void)parseIncomingData {

  // Keep going until we are out of data.
  // Loop can also be terminated because there are no line breaks left.
  while ([inputBuffer length] > 0) {

    // This allocation can be avoided if we store buffer as a string at all times.
    // However, that optimization is not strictly necessary for this demo.
    // You should probably avoid this in production code.
    NSString* bufferString = [[NSString alloc] initWithBytesNoCopy:[inputBuffer mutableBytes]
                                                            length:[inputBuffer length]
                                                          encoding:NSASCIIStringEncoding
                                                      freeWhenDone:NO];
    // Look for the first line break.
    NSRange rangeDelim = [bufferString rangeOfString:messageDelimiter];
    
    // If we don't have any line breaks, packet was not complete and we should wait for more data.
    if (rangeDelim.location == NSNotFound)
      break;

    // Notify whoever that message was received.
    NSString* message = [bufferString substringWithRange:NSMakeRange(0, rangeDelim.location)];
    if (messageReceivedBlock != nil)
      messageReceivedBlock(self,message);
    
    // Remove it from the buffer.
    [inputBuffer replaceBytesInRange:NSMakeRange(0, rangeDelim.location + rangeDelim.length)
                           withBytes:NULL
                              length:0];
  }
}

// Write whatever data we have, as much of it as stream can handle.
//
- (void)writeOutputBufferToStream {
  // Is connection open?
  if (![self isConnected])
    return;

  // Do we have anything to write?
  if ([outputBuffer length] == 0)
    return;

  // Can stream take any data in?
  if (![outputStream hasSpaceAvailable])
    return;

  // Write as much data as we can.
  NSInteger bytesWritten = [outputStream write:[outputBuffer bytes]
                                     maxLength:[outputBuffer length]];

  // Check for errors.
  if (bytesWritten == -1)  {
    [self disconnect];
    return;
  }

  // Remove it from the buffer.
  [outputBuffer replaceBytesInRange:NSMakeRange(0, bytesWritten)
                          withBytes:NULL
                             length:0];
}

- (void)notifyConnectionBlock:(ConnectionBlock)block {
  if (block != nil)
    block(self);
}


#pragma mark - NSStreamDelegate methods
  
- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)streamEvent {
    @try {
        if (stream == inputStream) {
            switch (streamEvent) {
                    
                case NSStreamEventOpenCompleted:
                    isInputStreamOpen = YES;
                    [self finishOpeningConnection];
                    break;
                case NSStreamEventHasBytesAvailable:
                    [self readFromStreamToInputBuffer];
                    break;
                case NSStreamEventHasSpaceAvailable:
                    // Should not happen for input stream!
                    break;
                case NSStreamEventErrorOccurred:
                    // Treat as "connection should be closed"
                case NSStreamEventEndEncountered:
                    [self closeConnection];
                    break;
                    
                default: break;
            }
        }
        
        if (stream == outputStream) {
            switch (streamEvent) {
                case NSStreamEventOpenCompleted:
                    isOutputStreamOpen = YES;
                    [self finishOpeningConnection];
                    break;
                    
                case NSStreamEventHasBytesAvailable:
                    // Should not happen for output stream!
                    break;
                    
                case NSStreamEventHasSpaceAvailable:
                    [self writeOutputBufferToStream];
                    break;
                    
                case NSStreamEventErrorOccurred:
                    // Treat as "connection should be closed"
                case NSStreamEventEndEncountered:
                    [self closeConnection];
                    break;
                    
                default: break;
            }
        }
    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

@end
