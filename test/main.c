#include <stdio.h>
#include <time.h>

void do_main();

time_t my_time() {
    return time(NULL);
}

int main() {
    do_main();
}
