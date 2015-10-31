-module(new).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("records.hrl").

main() ->
    case wf:user() of
        undefined -> wf:header(<<"Location">>, wf:to_binary("/login")), wf:state(status,302), [];
        _ -> #dtl{file="new", bindings=[{button, #button{id=send, class=["btn", "btn-primary"], body="Add post",postback=post,source=[title,text]} }]} end.

event(post) -> 
	Id = kvs:next_id("post",1),
	Post = #post{id=Id,author=wf:user(),feed_id=main, title=wf:q(title),text=wf:q(text)},
	kvs:add(Post),
	wf:redirect("/post?id=" ++ wf:to_list(Id)).

