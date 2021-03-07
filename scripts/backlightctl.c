#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

#define MIN_BRIGHTNESS 100
#define BRIGHTNESS_FILE "/sys/class/backlight/intel_backlight/brightness"
#define MAX_BRIGHTNESS_FILE "/sys/class/backlight/intel_backlight/max_brightness"

#define MAX(a, b) ((a > b) ? a : b)
#define MIN(a, b) ((a < b) ? a : b)

void print_usage() {
    puts("backlightctl [+-]value[%]");
    puts("Examples:");
    puts("  backlightctl 500   # set the brightness to 500");
    puts("  backlightctl +100  # increase current brightness by 100");
    puts("  backlightctl -100  # decrease current brightness by 100");
    puts("  backlightctl 50%   # set the brightness to 50% of the maximum");
    puts("  backlightctl +10%  # increase current brightness by 10% of the maximum");
    puts("  backlightctl -10%  # decrease current brightness by 10% of the maximum");
}

FILE *open_file() {
    FILE *file;
    if (!(file = fopen(BRIGHTNESS_FILE, "r+"))) {
        perror("failed to open " BRIGHTNESS_FILE);
        exit(EXIT_FAILURE);
    }
    return file;
}

int get_max_brightness() {
    int ret;
    FILE *fp = NULL;
    if (!(fp = fopen(MAX_BRIGHTNESS_FILE, "r"))) {
        perror("failed to open " MAX_BRIGHTNESS_FILE);
        return -1;
    }

    fscanf(fp, "%d", &ret);
    fclose(fp);
    return ret;
}

int get_value(const char *p) {
    int value = 0;
    int len = strlen(p);

    for (int i = 0; i < len; ++i) {
        if (p[i] >= '0' && p[i] <= '9') {
            value *= 10;
            value += p[i] - '0';
        }
    }

    return value;
}

int main(int argc, char **argv) {
    int max, cur, len, value;
    FILE *fp;

    if (argc != 2) {
        print_usage();
        return EXIT_FAILURE;
    }

    max = get_max_brightness();
    if (max == -1) {
        return EXIT_FAILURE;
    }

    fp = open_file();
    fscanf(fp, "%d", &cur);

    value = get_value(argv[1]);
    len = strlen(argv[1]);
    if (argv[1][len - 1] == '%') {
        value = value * max / 100;
    }
    if (argv[1][0] == '+') {
        value = cur + value;
    }
    else if (argv[1][0] == '-') {
        value = cur - value;
    }

    value = MAX(MIN_BRIGHTNESS, value);
    value = MIN(max, value);
    fprintf(fp, "%d", value);

    fclose(fp);
    return EXIT_SUCCESS;
}
