using CSV, DataFrames

df = DataFrame(CSV.File("./ECE pattern.csv"))


show(names(df))


# we are going to create a function that will put this in a workable format

function create_data() 
    df = DataFrame(CSV.File("./ECE pattern.csv"))  
    #the space in learning outcomes will make cleaning hard lets change it
    rename!(df, :"Learning Outcomes" => "LO")
    rename!(df, :"Learning Outcome Prerequisite" => "LOP")
    rename!(df, :"Course Prerequisite" => "CP")
    rename!(df, :"LO ID" => "ID" )
     #the is a blank row of missing values between courses so lets remove those
    dropmissing!(df, :LO)
    #temp value to hold names for later
    temp = ""
    # create a for loop to process each row    
    for row in eachrow(df)
        #lets fill in the missing class        
        if (row.Courses === missing)
            #add course name
            row.Courses = temp
        else
            # save the course name 
            temp = row.Courses            
        end
    end  
    # this may be the best place to replace the LOP with their ID rather than the first 4 digits of their LO
    # or do I change their ID's to be the first 4 of their LO?
    
    # save the cleaned frame to new CSV
    CSV.write("./Cleaned_ECE.csv", df)
end
    
create_data()     

# check it
new_df = DataFrame(CSV.File("./Cleaned_ECE.csv"))


