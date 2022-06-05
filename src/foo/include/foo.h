#pragma once
#include <string>

namespace project
{

class Foo
{
  public:
    [[nodiscard]] static std::string greet();
    [[nodiscard]] static int         one();
};

} // namespace project
