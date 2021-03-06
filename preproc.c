#include "preproc.h"
#include "stdlib.h"
#include "stdio.h"
#include <string.h>
#include "errors.h"

#define LINESIZE 1024

int readFile(char name[], FILE *ofp, int* numline) {
  FILE  *fp;
  char   line[LINESIZE], word[LINESIZE], word2[LINESIZE];
  size_t len = strlen(name);
  if (name[len - 1] == '"')
    name[len - 1] = '\0';
  if (name[0] == '"') {
    name++;
  }
  if ((fp = fopen(name, "r")) == 0) {
    perror("open");
    return 1;
  }
  while (fgets(line, LINESIZE, fp)) {
    if (sscanf(line, "%s%s", word, word2) == 2 && strcmp(word, "import") == 0) {
      readFile(word2, ofp, numline);
      (*numline)++;
    } else
      fprintf(ofp, "%s", line);
  }
}

