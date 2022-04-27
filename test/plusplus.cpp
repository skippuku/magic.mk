#include <stdio.h>

class Hello {
public:
    void runHello() {
        printf("Hello, C++\n");
    }
};

int
main(int argc, char ** argv) {
    Hello app;

    app.runHello();

    if (argc > 1) {
        printf("args: ");
        for (int i=1; i < argc; i++) {
            const char * arg = argv[i];
            if (i > 1) {
                printf(", ");
            }
            printf("\"%s\"", arg);
        }
        printf("\n");
    }

    return 0;
}
