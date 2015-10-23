-module(post).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("records.hrl").

post_id() -> wf:q(<<"id">>).

main() -> 
	Post = posts:get(wf:to_integer(post_id())),
	#dtl{file="post", bindings=[{title, Post#post.title}, {text, Post#post.text}, {comments, comments()}]}.

comments() ->
	[#textarea{id=comment, class=["form-control"], rows=3},
      #button{id=send, class=["btn", "btn-default"], body="Post comment",postback=comment,source=[comment]} ].

event(init) ->
	wf:reg({post, post_id()});

event(comment) -> 
	wf:send({post, post_id()}, {client, wf:q(comment)});

event({client, Text}) ->
	wf:insert_bottom(comments, #blockquote{body = #p{body = wf:html_encode(wf:jse(Text))}}).