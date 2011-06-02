/*
 *  Utility.h
 *  GourmetMap
 *
 *  Created by okano on 10/07/19.
 *  Copyright 2010,2011 Katsuhiko Okano All rights reserved.
 *
 */

#ifdef TARGET_IPHONE_SIMULATOR
#  define LOG_CURRENT_METHOD NSLog(@"%@/%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#  define LOG_CURRENT_LINE NSLog(@"%s line %d", __FILE__, __LINE__);
#else
#  define LOG_CURRENT_METHOD ;
#  define LOG_CURRENT_LINE ;
#endif
