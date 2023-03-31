using CSV
using JSON

function generate_edge_bundling_json(csv_file::AbstractString, json_path::AbstractString)
    # read data from CSV file
    data = DataFrame(CSV.File(csv_file))

    # create dictionary to store source outcomes for each unique key
    source_outcomes = Dict{String, Vector{String}}()
     
    # iterate over rows in data
    for row in data
        code = row.Courses * row.LO
        if(isempty(source_outcomes)) #if dict is empty
            temp= source_outcome(row.["Course Prerequisite"],row.LOP,row.["LO ID"])
            source_outcomes[code]=[temp]
        else # the dict has at least one entry
            if !haskey(transcript_courses,code) # current course and LO is not in dict

                if ';' in row.LOP      
                    strings = split(row.LOP,";")
                    temp_array=[strings[1],strings[2]]
                    temp= source_outcome(row.["Course Prerequisite"],temp_array,row.["LO ID"]) 
                else
                temp= source_outcome(row.["Course Prerequisite"],row.LOP,row.["LO ID"]) 
                end
                source_outcomes[code]=[temp]
            else
                if ';' in row.LOP      
                    strings = split(row.LOP,";")
                    temp_array=[strings[1],strings[2]]
                    temp= source_outcome(row.["Course Prerequisite"],temp_array,row.["LO ID"]) 
                else
                temp= source_outcome(row.["Course Prerequisite"],row.LOP,row.["LO ID"]) 
                end
                push!(source_outcomes[code],temp)
                
            end
        end
    end



    # save source outcomes dictionary as JSON file
    json_file = json_path * ".json"
    open(json_file, "w") do io
        JSON.print(io, source_outcomes)
    end
end
