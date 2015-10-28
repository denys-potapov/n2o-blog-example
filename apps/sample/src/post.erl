-module(post).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("records.hrl").

post_id() -> wf:to_integer(wf:q(<<"id">>)).

main() -> 
	case kvs:get(post, post_id()) of
		{ok, Post} -> #dtl{file="post", bindings=[
			{title, wf:html_encode(Post#post.title)}, 
			{text, wf:html_encode(Post#post.text)},
			{author, wf:html_encode(Post#post.author)},
			{comments, comments()}]};
		_ -> wf:state(status,404), "Post not found" end.

comments() ->
	[#textarea{id=comment, class=["form-control"], rows=3},
      #button{id=send, class=["btn", "btn-default"], body="Post comment",postback=comment,source=[comment]} ].

event(init) ->
	wf:reg({post, post_id()});

event(comment) -> 
	wf:send({post, post_id()}, {client, wf:q(comment)});

event({client, Text}) ->
	wf:insert_bottom(comments, #blockquote{body = #p{body = wf:html_encode(wf:jse(Text))}}).