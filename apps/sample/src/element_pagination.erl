-module(element_pagination).
-compile(export_all).
-include_lib("nitro/include/nitro.hrl").
-include_lib("elements.hrl").


link(Class, Body, Url) -> #li{class=[Class], body=#link{body=Body, url=Url}}.
disabled(Body) -> link("disabled", Body, "#").

left_arrow(#pagination{active = 1}) -> disabled("&laquo;");
left_arrow(#pagination{active = Active, url = Url}) ->
    link("", "&laquo;", Url ++ wf:to_list(Active - 1)).

right_arrow(#pagination{active = Count, count = Count}) -> disabled("&raquo;");
right_arrow(#pagination{active = Active, url = Url}) ->
    link("", "&raquo;",  Url ++ wf:to_list(Active + 1)).

left(0, P) -> [left_arrow(P)];
left(I, P) ->
    S = wf:to_list(I),
    left(I - 1, P) ++ [link("", S, P#pagination.url ++ S)].

right(I, P = #pagination{count = Count}) when I > Count -> [right_arrow(P)];
right(I, P) ->
    S = wf:to_list(I),
    [link("", S, P#pagination.url ++ S) | right(I + 1, P)].

render_element(P = #pagination{}) ->
    wf:render(#nav{body=#ul{class=["pagination"], body=[
        left(P#pagination.active - 1, P),
        link("active", wf:to_list(P#pagination.active), "#"),
        right(P#pagination.active + 1, P)
    ]}}).
    