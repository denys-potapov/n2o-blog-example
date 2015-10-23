-module(post).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("records.hrl").

post_id() -> wf:q(<<"id">>).

main() -> 
	Post = posts:get(wf:to_integer(post_id())),
	#dtl{file="post", bindings=[{title, Post#post.title}, {text, Post#post.text}]}.