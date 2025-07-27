#pragma once
#ifndef THOTH_H_
#define THOTH_H_

// Types and constants for Thoth
#define TH_VERSION "1.0.0"
#define TH_MAX_CLIENTS 100
#define TH_DEFAULT_PORT 8080
#define TH_BUFFER_SIZE 1024

// Error codes
#define TH_ERROR_SOCKET (-1)
#define TH_ERROR_BIND (-2)
#define TH_ERROR_LISTEN (-3)
#define TH_ERROR_ACCEPT (-4)
#define TH_ERROR_CONNECT (-5)
#define TH_ERROR_SEND (-6)
#define TH_ERROR_RECEIVE (-7)
#define TH_ERROR_CLOSE (-8)
#define TH_ERROR_MEMORY (-9)
#define TH_ERROR_TIMEOUT (-10)

#endif // THOTH_H_
