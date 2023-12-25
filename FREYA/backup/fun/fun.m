//
//  fun.m
//  kfd
//
//  Created by Seo Hyun-gyu on 2023/08/10.
//

#import <Foundation/Foundation.h>
#import <spawn.h>
#import <unistd.h>
#import <sys/stat.h>
#import <stdio.h>
#import <pthread.h>
#import "krw.h"
#import "offsets.h"
#import "sandbox.h"
#import "trustcache.h"
#import "escalate.h"
#import "utils.h"
#import "fun.h"
//#import "proc.h"
//#import "vnode.h"
#import "dropbear.h"
#import "./common/KernelRwWrapper.h"
#import "bootstrap.h"
//#import "boot_info.h"
#import "jailbreakd_test.h"
#import "helpers.h"
#include "FREYA15-Swift.h"
#import "bootstrap.h"
#import "utils.h"
#import "escalate.h"
#import "proc.h"
#import "vnode.h"
#import "boot_info.h"
#import "offsets.h"
#import "krw.h"
#import "jailbreakd.h"

#import <stdbool.h>
#import <Foundation/Foundation.h>
#import <sys/stat.h>

#import "../libs/NSData/NSData+GZip.h"//"NSData+GZip.h"
#include "../libs/NSString/NSString+SHA256.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
 
int do_fun(bool restore, int bootstrap) {
  //  dispatch_sync( dispatch_get_main_queue(), ^{
       // printf("Patchaway\n");
        uint64_t kslide = get_kslide();
        uint64_t kbase = 0xfffffff007004000 + kslide;
       util_info("kernel exploited");
       util_debug("Kernel base: 0x%llx", kbase);
        util_debug("Kernel slide: 0x%llx", kslide);
        util_debug("Kernel base kread64 ret: 0x%llx", kread64(kbase));
        //_offsets_init();
        //initKernRw(get_selftask(), kread64, kwrite64);
        
        //printf("isKernRwReady: %d\n", );
    /*
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"15.2")) {
            dothestage2();
            newplatformize(getpid());
            util_info("uid: %d, gid: %d", getuid(), getgid());
            prepare_kcall();
            platformize(getpid());
            uint64_t sb = unsandbox(getpid());
            loadTrustCacheBinpack();
            loadTrustCacheBinaries();
            term_kcall();
            cleanDropbearBootstrap();
            startJBEnvironment();   //oobPCI.swift -> case "startEnvironment":
            sandbox(getpid(), sb);
            /*
        } else {
     */
            //printf("[i] rootify ret: %d\n",
            rootify(getpid());
            util_info("rootified");
            util_info("uid: %d, gid: %d", getuid(), getgid());
            prepare_kcall(); //must be used?? or else dies trying to unsandbox anything
            util_info("kcall prepared");
            platformize(getpid());
            util_info("platformized");
            uint64_t sb = unsandbox(getpid());
            util_info("unsandboxed");
            loadTrustCacheBinpack();
            loadTrustCacheBinaries();
            term_kcall();
            util_info("kcall terminated");
            cleanDropbearBootstrap();
            util_info("dropbear bootstrap cleaned");
            if (restore == true) {
                restorerfs();
                util_info("restored rootfs");
            }
            startJBEnvironment(bootstrap);   //oobPCI.swift -> case "startEnvironment":
            sandbox(getpid(), sb);
            util_info("resandboxed");
            sync();
            util_info("synced bytes to disk");
       
    
    return 0;
        
}
/*
int do_restore(void) {
    //  dispatch_sync( dispatch_get_main_queue(), ^{
         // printf("Patchaway\n");
          uint64_t kslide = get_kslide();
          uint64_t kbase = 0xfffffff007004000 + kslide;
         util_info("kernel exploited");
         util_debug("Kernel base: 0x%llx", kbase);
          util_debug("Kernel slide: 0x%llx", kslide);
          util_debug("Kernel base kread64 ret: 0x%llx", kread64(kbase));
          //_offsets_init();
          //initKernRw(get_selftask(), kread64, kwrite64);
          
          //printf("isKernRwReady: %d\n", );
          if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"15.2")) {
              dothestage2();
              newplatformize(getpid());
              util_info("uid: %d, gid: %d", getuid(), getgid());
              prepare_kcall();
              platformize(getpid());
              uint64_t sb = unsandbox(getpid());
              loadTrustCacheBinpack();
              loadTrustCacheBinaries();
              term_kcall();
              cleanDropbearBootstrap();
              startJBEnvironment();   //oobPCI.swift -> case "startEnvironment":
              sandbox(getpid(), sb);
              /*
          } else {
              //printf("[i] rootify ret: %d\n",
              rootify(getpid());
              util_info("uid: %d, gid: %d", getuid(), getgid());
              prepare_kcall(); //must be used?? or else dies trying to unsandbox anything
              util_info("kcall prepared");
              platformize(getpid());
              util_info("cherimoya platformized");
              uint64_t sb = unsandbox(getpid());
              util_info("cherimoya unsandboxed");
              loadTrustCacheBinpack();
              loadTrustCacheBinaries();
              term_kcall();
              util_info("kcall terminated");
              cleanDropbearBootstrap();
              restorerfs();
              startJBEnvironment();
              sandbox(getpid(), sb);
          }
         
      
      return 0;
}
 */
/*
int do_roothide(void) {
    //  dispatch_sync( dispatch_get_main_queue(), ^{
         // printf("Patchaway\n");
          uint64_t kslide = get_kslide();
          uint64_t kbase = 0xfffffff007004000 + kslide;
         util_info("kernel exploited");
         util_debug("Kernel base: 0x%llx", kbase);
          util_debug("Kernel slide: 0x%llx", kslide);
          util_debug("Kernel base kread64 ret: 0x%llx", kread64(kbase));
          //_offsets_init();
          //initKernRw(get_selftask(), kread64, kwrite64);
          
          //printf("isKernRwReady: %d\n", );
          if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"15.2")) {
              dothestage2();
              newplatformize(getpid());
              util_info("uid: %d, gid: %d", getuid(), getgid());
              prepare_kcall();
              platformize(getpid());
              uint64_t sb = unsandbox(getpid());
              loadTrustCacheBinpack();
              loadTrustCacheBinaries();
              term_kcall();
              cleanDropbearBootstrap();
              startJBEnvironment();   //oobPCI.swift -> case "startEnvironment":
              sandbox(getpid(), sb);
              /* 
          } else {
              //printf("[i] rootify ret: %d\n",
              rootify(getpid());
              util_info("uid: %d, gid: %d", getuid(), getgid());
              prepare_kcall(); //must be used?? or else dies trying to unsandbox anything
              util_info("kcall prepared");
              platformize(getpid());
              util_info("cherimoya platformized");
              uint64_t sb = unsandbox(getpid());
              util_info("cherimoya unsandboxed");
              loadTrustCacheBinpack();
              loadTrustCacheBinaries();
              term_kcall();
              util_info("kcall terminated");
              cleanDropbearBootstrap();
              do_hidestrap();
              startJBEnvironment();
              sandbox(getpid(), sb);
          }
         
      
      return 0;
}
*/
