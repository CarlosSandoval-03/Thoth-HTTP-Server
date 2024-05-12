#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include "socket.h"

int create_socket(int domain, int type, int protocol)
{
	int sockfd = socket(domain, type, protocol);
	if (sockfd < 0) {
		perror("CORE - SOCKET: FAILED TO CREATE SOCKET");
		return TH_SOCKET_ERROR;
	}

	return sockfd;
}

int bind_socket(int sockfd, struct sockaddr_in *addr)
{
	// Enable address reuse
	int enable = 1;
	if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &enable, sizeof(int)) < 0) {
		perror("CORE - SOCKET: FAILED TO SET SOCKET OPTIONS");
		return TH_SOCKET_ERROR;
	}

	if (bind(sockfd, (struct sockaddr *)addr, sizeof(*addr)) < 0) {
		perror("CORE - SOCKET: FAILED TO BIND SOCKET");
		return TH_SOCKET_ERROR;
	}

	return TH_SOCKET_SUCCESS;
}

int listen_socket(int sockfd, int maxconn)
{
	if (listen(sockfd, maxconn) < 0) {
		perror("CORE - SOCKET: FAILED TO LISTEN SOCKET");
		return TH_SOCKET_ERROR;
	}

	return TH_SOCKET_SUCCESS;
}

int accept_socket(int sockfd, struct sockaddr_in *addr)
{
	socklen_t addr_len = sizeof(*addr);
	int new_sockfd = accept(sockfd, (struct sockaddr *)addr, &addr_len);
	if (new_sockfd < 0) {
		perror("CORE - SOCKET: FAILED TO ACCEPT SOCKET");
		return TH_SOCKET_ERROR;
	}

	return new_sockfd;
}

int connect_socket(int sockfd, struct sockaddr_in *addr)
{
	if (connect(sockfd, (struct sockaddr *)addr, sizeof(*addr)) < 0) {
		perror("CORE - SOCKET: FAILED TO CONNECT SOCKET");
		return TH_SOCKET_ERROR;
	}

	return TH_SOCKET_SUCCESS;
}

int close_socket(int sockfd)
{
	if (close(sockfd) < 0) {
		perror("CORE - SOCKET: FAILED TO CLOSE SOCKET");
		return TH_SOCKET_ERROR;
	}

	return TH_SOCKET_SUCCESS;
}
