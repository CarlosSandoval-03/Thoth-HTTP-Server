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

int main(void)
{
	UNITY_BEGIN();
	RUN_TEST(test_create_socket);
	return UNITY_END();
}