-module(config).
-compile(export_all).

log_level() -> error.

log_modules() ->
  [
    login,
    n2o_nitrogen,
    n2o_session,
    doc,
    index
  ].