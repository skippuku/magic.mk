#include <stdio.h>

class Hello {
public:
    void runHello() {
        printf("hello, world\n;");
    }
};

int
main() {
    Hello app;

    app.runHello();

    return 0;
}
