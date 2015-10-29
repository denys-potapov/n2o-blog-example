-module(index).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("records.hrl").

posts() -> [
	#panel{body=[
        #h2{body = #link{body = wf:html_encode(P#post.title), url = "/post?id=" ++ wf:to_list(P#post.id)}},
        #p{body = wf:html_encode(P#post.text)}
      ]} || P <- kvs:all(post)].

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

main() -> #dtl{file="index", bindings=[{posts, posts()}, {header, header()}]}.

event(logout) ->
	wf:user(undefined),
	wf:update(header, header()).