#include <stdio.h>
#include "hello.h"
#include "hello2/hello2.h"

int main(void)
{
    printf("%s", STR_HELLO);
    hello2();

    return 0;
}
