#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "BentoMap.h"

FOUNDATION_EXPORT double BentoMapVersionNumber;
FOUNDATION_EXPORT const unsigned char BentoMapVersionString[];

