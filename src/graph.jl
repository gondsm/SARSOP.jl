mutable struct PolicyGraphGenerator

    options::Dict{AbstractString,Any}

    function PolicyGraphGenerator(
        filename::AbstractString; # output name for the DOT file to be generated
        fast::Bool=false, # use fast (but very picky) alternate parser for .pomdp files
        graph_max_depth::Union{Int,Void}=nothing, # maximum horizon of the generated policy graph.
                                                     # There is no limit by default.
        graph_max_branch::Union{Int,Void}=nothing, # maximum number of branches
                                                      # of the generated policy graph.
                                                      # Shown will be top in probability.
                                                      # There is no limit by default.
        graph_min_prob::Union{Float64,Void}=nothing, # minimum probability threshold for a branch
                                                    # to be shown in the policy graph
                                                    # defaults to zero
        )

        options = Dict{AbstractString,Any}()
        options["policy-graph"] = filename
        if fast
            options["fast"] = ""
        end
        if isa(graph_max_depth, Int)
            options["graph-max-depth"] = graph_max_depth
        end
        if isa(graph_max_branch, Int)
            options["graph-max-branch"] = graph_max_branch
        end
        if isa(graph_min_prob, Float64)
            options["graph-min-prob"] = graph_min_prob
        end

        new(options)
    end
end

function polgraph(graphgen::PolicyGraphGenerator, pomdp::SARSOPFile, policy::SARSOPPolicy)
    options_list = _get_options_list(graphgen.options)
    run(`$EXEC_POLICY_GRAPH_GENERATOR $(pomdp.filename) --policy-file $(policy.filename) $options_list`)
end
