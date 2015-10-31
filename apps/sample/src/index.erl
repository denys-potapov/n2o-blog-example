-module(index).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("records.hrl").
-include_lib("elements.hrl").
-define(POST_PER_PAGE, 3).

page() ->
	case wf:q(<<"page">>) of
		undefined -> 1;
		Page      -> wf:to_integer(Page)
	end.

pages() ->
	Pages = kvs:count(post) div ?POST_PER_PAGE,
	case kvs:count(post) rem ?POST_PER_PAGE of
		0 -> Pages;
		_ -> Pages + 1
	end.

posts() -> [
	#panel{body=[
        #h2{body = #link{body = wf:html_encode(P#post.title), url = "/post?id=" ++ wf:to_list(P#post.id)}},
        #p{body = wf:html_encode(P#post.author)}
      ]} || P <- lists:reverse(kvs:traversal(post, kvs:count(post) - (page() - 1) * ?POST_PER_PAGE, ?POST_PER_PAGE, #iterator.prev))].

buttons() ->
	case wf:user() of
		undefined -> #li{body=#link{body = "Login", url="/login"}};
		_ -> [
				#p{class=["navbar-text"], body="Hello, " ++ wf:user()},
				#li{body=#link{body = "New post", url="/new"}},
				#li{body=#link{body = "Logout", postback=logout}}
		] end.


header() -> 
	#ul{id=header, class=["nav", "navbar-nav", "navbar-right"], body = buttons()}.


main() -> #dtl{file="index", bindings=[
	{posts, posts()}, 
	{pagination, #pagination{active = page(), count = pages(), url="/?page="}},
	{header, header()}]}.

event(logout) ->
	wf:user(undefined),
	wf:update(header, header());

event(_) -> ok.