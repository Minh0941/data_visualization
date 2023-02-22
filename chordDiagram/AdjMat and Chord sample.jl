using CSV, DataFrames

# This function takes a DataFrame containing a curriculum associated with its learning outcomes as input argument.
# The output is the adjacency matrix for the learning outccome graph.
function lo_adjacency_generator(original_curric::AbstractDataFrame)
    raw_lo = original_curric."Learning Outcomes"
    pure_lo = collect(skipmissing(raw_lo))
    lo_prereq = original_curric."Learning Outcome Prerequisite"
    num_lo = length(pure_lo)
    len_file = length(raw_lo)
    lo_adj = zeros(Int, num_lo, num_lo)
    lo_dict = Dict()
    for i in 1:num_lo
        key = split.(pure_lo[i],":")[1]
        lo_dict[key] = i
    end
    
    for j in 1:len_file
        if typeof(lo_prereq[j]) != Missing
            prereqs = split.(lo_prereq[j],";")
            for prereq in prereqs
                source = lo_dict[prereq]
                dest = lo_dict[split.(raw_lo[j],":")[1]]
                lo_adj[source,dest] = 1
            end
        end
    end
    # specify the folder that you want to save the learning outccome adjacency matrix
    CSV.write("./lo_adjacency_$(num_lo).csv", DataFrame(lo_adj); header = false) 
    return lo_adj
end
original_curric = CSV.read("./ECE pattern curriculum version 3.csv", DataFrame)
lo_adj = lo_adjacency_generator(original_curric)

using GraphRecipes, Plots

graphplot(lo_adj,
              method=:chorddiagram, 
              names=[(string(i)) for i in 1:38],             
              linecolor=:black,
              fillcolor= :red)
