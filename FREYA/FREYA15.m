#import "offsets.h"
#import <time.h>
#import <unistd.h>
#include <sys/sysctl.h>
#include <sys/utsname.h>
#import "fun/krw.h"
#import "fun/fun.h"
#import <stdint.h>
#import "fun/common/KernelRwWrapper.h"
#import <Foundation/Foundation.h>
#include "FREYA15-Swift.h"
#import "fun/helpers.h"
#import <Foundation/Foundation.h>
#import <mach/mach.h>
#import <sys/sysctl.h>
#import "bootstrap.h"
#import "fun/boot_info.h"
#import "fun/sandbox.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


uint64_t puaf_pages = 0x760;
uint64_t puaf_method = 1;
uint64_t kread_method = 2;
uint64_t kwrite_method = 2;

/*bool isInternetAvailable(void) {
    NSURL *url = [NSURL URLWithString:@"http://www.apple.com"]; // You can replace this URL with any reliable URL
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:5.0]; // Adjust the timeout interval as needed
    
    NSHTTPURLResponse *response;
    NSError *error;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Check if there was an error or if the response code indicates success (e.g., 200 OK)
    if (error || (response.statusCode / 100) != 2) {
        return false; // Internet is not available
    } else {
        return true; // Internet is available
    }
}

void downloadFileFromURL() {
    NSString *boottarPathextract = [NSString stringWithFormat:@"%@%s", NSBundle.mainBundle.bundlePath, "/iosbinpack"];
    NSURL *url = [NSURL URLWithString:@"https://apt.procurs.us/bootstraps/1800/bootstrap-iphoneos-arm64.tar.zst"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request
                                                            completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error downloading file: %@", error.localizedDescription);
        } else {
            // Move the downloaded file to the destination path
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSError *moveError;
            
            if ([fileManager moveItemAtURL:location toURL:[NSURL fileURLWithPath:boottarPathextract] error:&moveError]) {
                NSLog(@"File downloaded successfully to %@", boottarPathextract);
            } else {
                NSLog(@"Error moving downloaded file: %@", moveError.localizedDescription);
            }
        }
    }];
    
    [downloadTask resume];
}
*/
void runOnMainQueueWithoutDeadlocking(void (^block)(void)) {
    if ([NSThread isMainThread]) {
       // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            block();
    }
    else { dispatch_sync(dispatch_get_main_queue(), block); }
}

int jailbreak(bool respring_in_end, bool restorefs, int bootstrap) {
    sync();
    util_info("safe jbip");
    sleep(2);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FINAL_KFD = do_kopen(puaf_pages, puaf_method, kread_method, kwrite_method);
        initKernRw(get_selftask(), kread64, kwrite64);
        isKernRwReady();
        
        do_fun(restorefs, bootstrap);
        
        if (respring_in_end == true) {
            util_info("kfd closed");
            do_kclose();
            restartBackboard();
        } else {
            util_info("kfd closed");
            do_kclose();
        }
    });
    return 0;
}

/*
int roothide(void) {
    _offsets_init();
    sleep(1);
    sync();
    sleep(2);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // sys_init();
        //print_os_details();
        FINAL_KFD = do_kopen(puaf_pages, puaf_method, kread_method, kwrite_method);
        initKernRw(get_selftask(), kread64, kwrite64);
        isKernRwReady();
        
        do_roothide();
        
        do_kclose();
        restartBackboard();
    });
    return 0;
}
*/
