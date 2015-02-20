#include "guitar.h"

/* R is not thread-safe, so it's fine to use a static buffer */
static char buf[1024];

static char *format_git_error(const char *task) {
    const git_error *ge = giterr_last();
    snprintf(buf, sizeof(buf), "%s failed: %s", task, (ge && ge->message) ? ge->message : "unknown GIT error");
    return buf;
}
 
class GitException : public Rcpp::exception {
 public:
    GitException(const char *task) : exception(format_git_error(task)) { }
};
