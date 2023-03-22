using CSV
using JSON

function csv_to_edge_bundling_json(csv_file_path::String, output_dir::String)
    
    # Load the CSV file into a DataFrame
    df = CSV.read(csv_file_path)
    
    # Create a dictionary to hold the edges
    edges_dict = Dict{String, Vector{String}}()
    
    # Concatenate columns to create unique keys and store source outcomes in the values
    for row in eachrow(df)
        key = string(row[1], "_", row[2], "_", row[3])
        if !haskey(edges_dict, key)
            if any(ismissing, row)
                # skip row if it contains empty data
                continue
            end
            edges_dict[key] = Vector{String}()
        end
        push!(edges_dict[key], row[4])
    end
    
    # Write each dictionary key-value pair to a separate JSON file
    for (key, value) in edges_dict
        json_file_path = joinpath(output_dir, "$key.json")
        JSON.open(json_file_path, "w") do io
            JSON.print(io, Dict("imports" => value))
        end
    end
    
end


/// To use this function, you can call it like this:

csv_to_edge_bundling_json("input.csv", "output_dir")
This will read the CSV file "input.csv", concatenate columns to create unique keys, and store source outcomes in a dictionary. Then it will create a separate JSON file for each dictionary key-value pair in the specified output directory, with the JSON file name being the dictionary key and the "imports" field containing the vector of source outcomes.

Note that the function assumes that the CSV file has four columns, with the first three columns concatenated to form the unique key, and the fourth column containing the source outcomes. You may need to adjust the code if your CSV file has a different format.