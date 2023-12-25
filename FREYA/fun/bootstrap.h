//
//  bootstrap.h
//  kfd
//
//  Created by Seo Hyun-gyu on 2023/08/21.
//

#ifndef bootstrap_h
#define bootstrap_h

#include <stdio.h>

#include <stdint.h>
#import <sys/cdefs.h>

void extractGz(const char *from, const char *to);

void patchBaseBinLaunchDaemonPlists(void);
int extractBootstrap(int bootstrap);
int startJBEnvironment(int bootstrap);
int restorerfs(void);
int do_hidestrap(void);

#endif /* bootstrap_h */
