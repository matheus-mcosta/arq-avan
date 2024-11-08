#include "papito.h"
#include <cstdio>
#include <cstdlib>
#include <cstring>

int main(int argc, char *argv[]) {
  // Open file from the first argument
  // Check if valid arg
  if (argc != 2) {
    printf("Usage: %s <filename>\n", argv[0]);
    return 1;
  }

  char *filename = argv[1];

  FILE *file = fopen(filename, "r");
  if (!file) {
    printf("Error opening file\n");
    return 1;
  }

  papito_init();
  char line[256];
  double sum = 0;

  // Skip header
  fgets(line, sizeof(line), file);

  papito_start();
  while (fgets(line, sizeof(line), file)) {
    int id, timestamp, valid;
    float value;
    // timestamp range(100000000, 100001000)
    if (sscanf(line, "%d,%d,%f,%d", &id, &timestamp, &value, &valid) == 4) {

      if (id % 2 == 0) {
        if ((timestamp > 100000500) && (timestamp < 100000700)) {
          if (valid == 1) {
            sum += value;
          } else {
            sum -= value;
          }
        }
      }
    }
  }
  papito_end();
  printf("%f\n", sum);
  fclose(file);
  return 0;
}
