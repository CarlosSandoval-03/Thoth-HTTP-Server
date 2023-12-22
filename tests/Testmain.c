#include "unity.h"
#include "src/main.h"

void setUp(void) {
    // set stuff up here
}

void tearDown(void) {
    // clean stuff up here
}

void test_function_should_doBlahAndBlah(void) {
    TEST_ASSERT_EQUAL(7, suma(3, 4));
}

void test_function_should_doAlsoDoBlah(void) {
    TEST_ASSERT_EQUAL(12, suma(12, 1));
}

// not needed when using generate_test_runner.rb
int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_function_should_doBlahAndBlah);
    RUN_TEST(test_function_should_doAlsoDoBlah);
    return UNITY_END();
}