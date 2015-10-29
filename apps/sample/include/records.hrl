-include_lib("kvs/include/kvs.hrl").

-record(post, {?CONTAINER, title, text, author}).
-record(comment, {?ITERATOR(post), text, author}).
