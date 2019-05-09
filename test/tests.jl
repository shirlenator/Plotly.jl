using Plotly
using JSON
using Base.Test

# just check that http://plot.ly/clientresp behaves as expected -- nothing to see here

Plotly.signin("unittest","tfzz811f5n", Dict("plotly_domain"=>"https://plot.ly","plotly_api_domain"=>"https://api.plot.ly"))

(x0,y0) = [1,2,3], [4,5,6]
(x1,y1) = [1,2,3], [2,10,12]

response = Plotly.plot([[x0 y0] [x1 y1]], Dict("filename" => "basic_test_plot"))
@test response["error"] == ""

datastyle = Dict("line"=>Dict("color"=> "rgb(84, 39, 143)", "width"=> 4))
style_res = Plotly.style(datastyle, Dict("filename" => "basic_test_plot"))
@test style_res["error"] == ""

layout_res = Plotly.layout(Dict("title"=>"Hello World"), Dict("filename" => "basic_test_plot"))
@test layout_res["error"] == ""

# just check that these won't raise an error
trace1 = Plotly.line(sin, Dict("left"=>0, "right"=>10, "step"=>1))
trace2 = Plotly.histogram(cos, Dict("left"=>0, "right"=>10, "step"=>1))
trace3 = Plotly.box(abs, Dict("left"=>0, "right"=>10, "step"=>1))
trace4 = Plotly.scatter(log, Dict("left"=>0, "right"=>10, "step"=>1))
response = Plotly.plot([trace1, trace2, trace3, trace4], Dict("filename" => "test_plot"))
@test response["error"] == ""

# and one last check
response = Plotly.plot([sin, cos, abs, log], Dict("left"=>eps(), "right"=>10, "step"=>1, "filename" => "test_plot"))
@test response["error"] == ""

#= getFile is broken because the /content endpoint isn't supported anymore?
figure = Plotly.getFile("5", "chris")
@test length(figure["data"][1]["x"]) == 501
@test haskey(figure["layout"], "xaxis")

response = Plotly.plot(figure["data"], Dict("layout"=> figure["layout"], "filename" => "test_get_figure_plot"))
@test response["error"] == ""
=#

#test get_plot_endpoint
endpoints = Dict("plotly_domain"=>"my_plotly_domain", "plotly_api_domain"=>"my_plotly_api_domain")
Plotly.signin("test_username", "test_api_key", endpoints)
plot_endpoint = Plotly.get_plot_endpoint()
@test plot_endpoint == "my_plotly_domain/clientresp"

#test get_content_endpoint
endpoints = Dict("plotly_domain"=>"my_plotly_domain", "plotly_api_domain"=>"my_plotly_api_domain")
Plotly.signin("test_username", "test_api_key", endpoints)
fid = "123_fake"
owner = "test_owner"
content_endpoint = Plotly.get_content_endpoint(fid, owner)
@test content_endpoint == "my_plotly_api_domain/v2/files/test_owner:123_fake/content"
