#pragma once
#include <netinet/in.h>

#define TH_SOCKET_ERROR -1
#define TH_SOCKET_SUCCESS 0

int create_socket(int domain, int type, int protocol);
int bind_socket(int sockfd, struct sockaddr_in *addr);
int listen_socket(int sockfd, int maxconn);
int accept_socket(int sockfd, struct sockaddr_in *addr);
int connect_socket(int sockfd, struct sockaddr_in *addr);
int close_socket(int sockfd);
