#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

int main() {
    // Ensure the program is running as root
    if (geteuid() != 0) {
        fprintf(stderr, "Error: This program must be run as root.\n");
        return 1;
    }

    // Open /proc/sys/kernel/core_pattern for writing
    int fd = open("/proc/sys/kernel/core_pattern", O_WRONLY);
    if (fd < 0) {
        perror("Error opening /proc/sys/kernel/core_pattern");
        return 1;
    }

    // Write "core" to the file
    if (write(fd, "core\n", 5) < 0) {
        perror("Error writing to /proc/sys/kernel/core_pattern");
        close(fd);
        return 1;
    }

    // Close the file
    close(fd);

    printf("Successfully set core_pattern to 'core'\n");
    return 0;
}
