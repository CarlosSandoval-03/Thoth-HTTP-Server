#include "unity.h"
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include "core/socket.h"

void setUp(void)
{
}

void tearDown(void)
{
}

void test_create_socket(void)
{
	int sockfd = create_socket(AF_INET, SOCK_STREAM, 0);
	TEST_ASSERT_TRUE(sockfd > 0);

	close_socket(sockfd);
	TEST_ASSERT_EQUAL_INT(TH_SOCKET_SUCCESS, 0);
}

void test_bind_socket(void)
{
	int sockfd = create_socket(AF_INET, SOCK_STREAM, 0);
	TEST_ASSERT_TRUE(sockfd > 0);

	struct sockaddr_in addr;
	addr.sin_family = AF_INET;
	addr.sin_port = htons(8080);
	addr.sin_addr.s_addr = INADDR_ANY;

	TEST_ASSERT_EQUAL_INT(TH_SOCKET_SUCCESS, bind_socket(sockfd, &addr));

	close_socket(sockfd);
	TEST_ASSERT_EQUAL_INT(TH_SOCKET_SUCCESS, 0);
}

void test_listen_socket(void)
{
	int sockfd = create_socket(AF_INET, SOCK_STREAM, 0);
	TEST_ASSERT_TRUE(sockfd > 0);

	struct sockaddr_in addr;
	addr.sin_family = AF_INET;
	addr.sin_port = htons(8080);
	addr.sin_addr.s_addr = INADDR_ANY;

	TEST_ASSERT_EQUAL_INT(TH_SOCKET_SUCCESS, bind_socket(sockfd, &addr));
	TEST_ASSERT_EQUAL_INT(TH_SOCKET_SUCCESS, listen_socket(sockfd, 5));

	close_socket(sockfd);
	TEST_ASSERT_EQUAL_INT(TH_SOCKET_SUCCESS, 0);
}

void test_accept_socket(void)
{
	int sockfd = create_socket(AF_INET, SOCK_STREAM, 0);
	TEST_ASSERT_TRUE(sockfd > 0);

	struct sockaddr_in addr;
	addr.sin_family = AF_INET;
	addr.sin_port = htons(8080);
	addr.sin_addr.s_addr = INADDR_ANY;

	TEST_ASSERT_EQUAL_INT(TH_SOCKET_SUCCESS, bind_socket(sockfd, &addr));
	TEST_ASSERT_EQUAL_INT(TH_SOCKET_SUCCESS, listen_socket(sockfd, 5));

	int new_sockfd = accept_socket(sockfd, &addr);
	TEST_ASSERT_TRUE(new_sockfd > 0);

	close_socket(sockfd);
	close_socket(new_sockfd);
	TEST_ASSERT_EQUAL_INT(TH_SOCKET_SUCCESS, 0);
}

void test_connect_socket(void)
{
	int sockfd = create_socket(AF_INET, SOCK_STREAM, 0);
	TEST_ASSERT_TRUE(sockfd > 0);

	struct sockaddr_in addr;
	addr.sin_family = AF_INET;
	addr.sin_port = htons(8080);
	addr.sin_addr.s_addr = inet_addr("127.0.0.1");

	TEST_ASSERT_EQUAL_INT(TH_SOCKET_SUCCESS, connect_socket(sockfd, &addr));
}

int main(void)
{
	UNITY_BEGIN();
	RUN_TEST(test_create_socket);
	RUN_TEST(test_bind_socket);
	RUN_TEST(test_listen_socket);
	// RUN_TEST(test_accept_socket);
	RUN_TEST(test_connect_socket);

	return UNITY_END();
}