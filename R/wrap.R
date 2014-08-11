commit_HEAD_changes <- function(repository, changes, author, message) {
  if (is.character(repository)) repository <- Repository$new(repository)
  index = repository$index()
  index$read_tree(repository$head()$peel(GIT_OBJ_TREE))
  for (i in seq.int(length(changes))) {
    o = changes[[i]]
    fn = names(changes)[i]
    if (is.null(o)) {
      index$remove_by_path(fn)
    } else {
      if (is.character(o)) o = charToRaw(o) else if (!is.raw(o)) o = serialize(o, NULL)
      oid = repository$hash_buffer(o)
      index$add(list(path=fn, oid=oid))
    }
  }
  tref = index$write_tree()
  t = repository$object_lookup(tref, GIT_OBJ_TREE)
  sig <- if (is.character(author))
    make_signature(author, author)
  else
    make_signature(author$name, author$email)
  parents <- (if (repository$is_empty()) list()
              else list(repository$head()$peel(GIT_OBJ_COMMIT)))
  repository$create_commit("HEAD", sig, sig, "", message, t, parents)
}
