using Romeo, GLFW, GLAbstraction, Reactive, ModernGL

immutable Screen2
    id::Symbol
    parent::Screen
    children::Vector{Screen}
    inputs::Dict{Symbol, Any}
    renderlist::Vector{RenderObject}
    area::Rectangle
    hidden::Bool
    hasfocus::Bool
    function Screen(id::Symbol,
                    children::Vector{Screen},
                    inputs::Dict{Symbol, Any},
                    renderList::Vector{Any})
        parent = new()
        new(id::Symbol, parent, children, inputs, renderList, GLFW.NullWindow)
    end
    function Screen(id::Symbol,
                    parent::Screen,
                    children::Vector{Screen},
                    inputs::Dict{Symbol, Any},
                    renderList::Vector{Any},
                    glfwWindow::Window)
        new(id::Symbol, parent, children, inputs, renderList, glfwWindow)
    end
end
splice!(collection, index[, replacement]) -> ite)
function GLAbstraction.render(x::Screen2)
    glViewport(x.area)
    render(x.renderlist)
    render(x.children)
end

N       = 128
volume  = Float32[sin(x / 12f0)+sin(y / 12f0)+sin(z / 12f0) for x=1:N, y=1:N, z=1:N]
max     = maximum(volume)
min     = minimum(volume)
volume  = (volume .- min) ./ (max .- min)

#push!(Romeo.RENDER_LIST, visualize(volume))
#push!(Romeo.RENDER_LIST, visualize(readall(open("../src/Romeo.jl"))))
#push!(Romeo.RENDER_LIST, visualize(Texture(joinpath(homedir(),"Desktop", "random imgs", "jannis.jpg"))))
inputs = copy(Romeo.window.inputs)
camera = PerspectiveCamera(inputs, Vec3(2), Vec3(0))

push!(Romeo.RENDER_LIST, visualize(Float32[0f0 for i=0:0.1:10, j=0:0.1:10], color = rgba(1,0,0,1), 
	projection       = camera.projection,
	view     		 = camera.view,
	normalmatrix     = camera.normalmatrix))


while Romeo.window.inputs[:open].value
    Romeo.renderloop(Romeo.window)
end 
GLFW.Terminate()