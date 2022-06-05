#include <foo.h>
#include <gtest/gtest.h>

using namespace project;

TEST(FooTest, GreetReturnsExpected)
{
    Foo foo;
    EXPECT_EQ(foo.greet(), "hello from Foo");
}

TEST(FooTest, OneReturnsOne)
{
    Foo foo;
    EXPECT_EQ(foo.one(), 1);
}
