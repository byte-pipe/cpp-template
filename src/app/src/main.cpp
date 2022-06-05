#include <foo.h>
#include <iostream>
#include <version.h>

int main()
{
    std::cout << "version " << project::VERSION << "\n";

    // project::Foo foo;
    std::cout << project::Foo::greet() << "\n";
    std::cout << "one() = " << project::Foo::one() << "\n";

    return 0;
}
