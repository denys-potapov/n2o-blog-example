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
	case wf:user() of
		undefined -> #link{body = "Login to add comment", url="/login"};
		_ -> [
				#textarea{id=comment, class=["form-control"], rows=3},
      			#button{id=send, class=["btn", "btn-default"], body="Post comment",postback=comment,source=[comment]} 
		] end.
	
event(init) ->
	[event({client,Comment}) || Comment <- kvs:entries(kvs:get(post, post_id()),comment,undefined) ],
	wf:reg({post, post_id()});

event(comment) ->
	Comment = #comment{id=kvs:next_id("comment",1),author=wf:user(),feed_id=post_id(),text=wf:q(comment)},
	kvs:add(Comment),
	wf:send({post, post_id()}, {client, Comment});

event({client, Comment}) ->
	wf:insert_bottom(comments,
		#blockquote{body = [
			#p{body = wf:html_encode(Comment#comment.text)},
			#footer{body = wf:html_encode(Comment#comment.author)}
		]}).