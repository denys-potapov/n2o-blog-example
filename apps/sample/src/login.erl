-module(login).
-compile(export_all).
-include_lib("n2o/include/wf.hrl").
-include_lib("nitro/include/nitro.hrl").
-include_lib("records.hrl").

main() -> 
	wf:wire(#api{name=login}),
	#dtl{file="login", bindings=[{app_id, application:get_env(sample, facebook_app_id, "")}]}.

api_event(login, Response, Term) ->
	n2o_session:ensure_sid([],?CTX,[]),
	{Props} = jsone:decode(list_to_binary(Response)),
	User = binary_to_list(proplists:get_value(<<"name">>, Props)),
	wf:user(User),
	wf:redirect("/").

event(_) -> ok.
