#ifndef SOCKET_H_
#define SOCKET_H_

#include <stdint.h>
#include <stddef.h>
#include <sys/types.h>
#include <sys/socket.h>

/**
 * @file socket.h
 * @brief Interface for creating and managing TCP/IPv4 sockets.
 */

/**
 * @brief Supported address families.
 */
typedef enum {
	TH_DOMAIN_IPV4 = AF_INET, /**< IPv4 sockets */
	// TH_DOMAIN_IPV6 = AF_INET6,/**< IPv6 sockets (to be implemented) */
} th_domain_t;

/**
 * @brief Supported socket types.
 */
typedef enum {
	TH_TYPE_STREAM = SOCK_STREAM, /**< Connection-oriented (TCP) */
	// TH_TYPE_DGRAM  = SOCK_DGRAM, /**< Connectionless (UDP) */
} th_type_t;

/**
 * @brief Supported transport protocols.
 */
typedef enum {
	TH_PROTO_TCP = IPPROTO_TCP, /**< TCP protocol */
	// TH_PROTO_UDP = IPPROTO_UDP, /**< UDP protocol */
} th_protocol_t;

/**
 * @brief Complete socket configuration.
 *
 * Example:
 * @code
 * th_socket_config_t cfg = {
 *     .domain   = TH_DOMAIN_IPV4,
 *     .type     = TH_TYPE_STREAM,
 *     .protocol = TH_PROTO_TCP
 * };
 * @endcode
 */
typedef struct {
	th_domain_t domain; /**< Address family */
	th_type_t type; /**< Socket type */
	th_protocol_t protocol; /**< Transport protocol */
} th_socket_config_t;

/**
 * @brief Create a socket with the given configuration.
 *
 * @param config Pointer to a th_socket_config_t structure.
 * @return Socket file descriptor (>=0) on success, or -1 on error.
 */
int th_create_socket(const th_socket_config_t *config);

/**
 * @brief Bind a socket to a local address.
 *
 * @param sockfd  Socket file descriptor.
 * @param addr    Pointer to sockaddr structure.
 * @param addrlen Size of the addr structure.
 * @return 0 on success, or -1 on error.
 */
int th_bind_socket(int sockfd, const struct sockaddr *addr, socklen_t addrlen);

/**
 * @brief Place the socket in listening mode (stream only).
 *
 * @param sockfd  Socket file descriptor.
 * @param backlog Maximum length of the pending connection queue.
 * @return 0 on success, or -1 on error.
 */
int th_listen_socket(int sockfd, int backlog);

/**
 * @brief Accept an incoming connection (stream only).
 *
 * @param sockfd   Listening socket file descriptor.
 * @param addr     Output: client address.
 * @param addrlen  Input/output: size of addr buffer.
 * @return New socket file descriptor on success, or -1 on error.
 */
int th_accept_socket(int sockfd, struct sockaddr *addr, socklen_t *addrlen);

/**
 * @brief Connect a socket to a remote address.
 *
 * @param sockfd  Socket file descriptor.
 * @param addr    Pointer to the remote sockaddr structure.
 * @param addrlen Size of the addr structure.
 * @return 0 on success, or -1 on error.
 */
int th_connect_socket(int sockfd, const struct sockaddr *addr, socklen_t addrlen);

/**
 * @brief Send data through the socket.
 *
 * @param sockfd Socket file descriptor.
 * @param buf    Pointer to the data buffer.
 * @param len    Number of bytes to send.
 * @param flags  Flags as in send().
 * @return Number of bytes sent, or -1 on error.
 */
ssize_t th_send_socket(int sockfd, const void *buf, size_t len, int flags);

/**
 * @brief Receive data from the socket.
 *
 * @param sockfd Socket file descriptor.
 * @param buf    Buffer to store received data.
 * @param len    Maximum number of bytes to read.
 * @param flags  Flags as in recv().
 * @return Number of bytes received, 0 if connection closed, or -1 on error.
 */
ssize_t th_receive_socket(int sockfd, void *buf, size_t len, int flags);

/**
 * @brief Close the socket.
 *
 * @param sockfd Socket file descriptor to close.
 * @return 0 on success, or -1 on error.
 */
int th_close_socket(int sockfd);

#endif /* SOCKET_H_ */
