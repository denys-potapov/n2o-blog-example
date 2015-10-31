-include_lib("kvs/include/kvs.hrl").

-record(feed, {?CONTAINER}).
-record(post, {?ITERATOR(feed), title, text, author}).
-record(comment, {?ITERATOR(feed), text, author}).
