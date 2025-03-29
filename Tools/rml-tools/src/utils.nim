# {{{ alias*()
template alias*(newName: untyped, call: untyped) =
  template newName(): untyped {.redefine.} = call

# }}}
#
# vim: et:ts=2:sw=2:fdm=marker
