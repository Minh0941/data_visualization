using CSV
using JSON

function generate_edge_bundling_json(csv_file::AbstractString, json_path::AbstractString)
    # read data from CSV file
    data = CSV.read(csv_file)

    # create dictionary to store source outcomes for each unique key
    source_outcomes = Dict{String, Vector{String}}()

    # iterate over rows in data
    for row in data
        # concatenate first three columns to create unique key
        if any(ismissing, row)
            # skip row if it contains empty data
            continue
    
        key = join(row[1:3])

        # concatenate fourth and fifth columns to create source outcome
        source_outcome = join(row[4:5])

        # add source outcome to values array for corresponding key
        if haskey(source_outcomes, key)
            push!(source_outcomes[key], source_outcome)
        else
            source_outcomes[key] = [source_outcome]
        end
    end

    # save source outcomes dictionary as JSON file
    json_file = json_path * ".json"
    open(json_file, "w") do io
        JSON.print(io, source_outcomes)
    end
end
