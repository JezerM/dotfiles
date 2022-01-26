#include <asm-generic/errno-base.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/inotify.h>

void handle_event(int fd, char *file_name) {
  char buf[4096]
               __attribute__ ((aligned(__alignof__(struct inotify_event))));
  int watch = inotify_add_watch(fd, file_name, IN_CLOSE_WRITE);

  const struct inotify_event* event;
  int len;

  for (;;) {
    len = read(fd, buf, sizeof(buf));
    if (len == -1 && errno != EAGAIN) {
      perror("read");
      exit(1);
    }

    if (len <= 0) {
      break;
    }

    for (char *ptr = buf; ptr < buf + len; ptr += sizeof(struct inotify_event) + event->len) {
      event = (const struct inotify_event *) ptr;
      if (event->mask == IN_CLOSE_WRITE) {
        char *message = "Modified\n";
        write(STDOUT_FILENO, message, strlen(message));
      }
    }
  }
}

int main(int argc, char **argv) {
  if (argc <= 1) {
    errno = EINVAL;
    perror("No arguments");
    exit(1);
  }

  char *file_name = argv[1];
  int fd = inotify_init();

  while (1) {
    handle_event(fd, file_name);
  }

  return 0;
}
