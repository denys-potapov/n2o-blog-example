-module(index).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("records.hrl").

posts() -> [
	#panel{body=[
        #h2{body = #link{body = P#post.title, url = "/post?id=" ++ wf:to_list(P#post.id)}},
        #p{body = P#post.text}
      ]} || P <- posts:get()].

main() -> #dtl{file="index", bindings=[{posts, posts()}]}.