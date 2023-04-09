// console.log('xoces is loaded:', xoces);

// ========
// data that we want to visualize
// =========

var data = d3.csv("./Cleaned_Optimized.csv")
  .row(function(d) {  
    var id = d.LO.split(':',1)                                               
    return {                
      Courses: d.Courses,
      LO: d.LO,
      CP: d.CP,
      LOP: d.LOP,
      ID: id[0]    
    };
  })
  .get(function(data) {
    console.log(data); 
     
    var outcomes = getOutcomes();

    function getOutcomes(){
      var outcomes = [];    
      for(var i = 0; i < data.length; i++){    
        var d = data[i];
        var outcome = {
          id: d.ID,  
          type: 'outcome',
          name: d.ID
        };
      outcomes.push(outcome);           
    } 
    console.log(outcomes)
    return outcomes;
    };
    
    var modules = getModules();

    function getModules(){   
      var modules = [];
      var temp = '';
      var course_int = 0;
      var course_pre = "m";
      var course_id = "";
      for(var i = 1; i < data.length; i++){
        var d = data[i];
        if(d.Courses != temp){
          temp = d.Courses
          course_int = course_int + 1;
          course_id = course_pre.concat(course_int);
          var module = {
            id: course_id,
            type: "module",
            name: d.Courses
          }
          modules.push(module);        
        }
      }
      console.log(modules);
      return modules;
    };
    
    var tracks = [
      {id: 't1', type: 'track', name: 'ECE'},    
    ];
    
    var institutions = [
      {id: 'UofA', type: 'institution', name: 'Curricular Mapping'},
    ];

    var relationships = getRelationships();

    function getRelationships(){
      var relationships = [];  
      var rel_int = 0;
      var rel_pre = "r";
      var rel_id = "";
      var temp = '';
      var course_int = 0;
      var course_pre = "m";
      var course_id = "";
      // start at second row
      for(var i = 0; i < data.length; i++){      
        var d = data[i];
        rel_id = rel_pre.concat(rel_int);
        if(d.LOP != ""){
          //check if there are multiple pre reqs for outcomes     
          var multiple_LOP = d.LOP.includes(";");
          // add the outcome pre-reqs     
          if(multiple_LOP === true){      
            var temp_str = d.LOP.split(";");
            console.log(temp_str);          
            for( var j = 0; j < temp_str.length; j++){
              rel_int = rel_int + 1;
              rel_id = rel_pre.concat(rel_int);
              var relation_1 = {
                id: rel_id,
                type: "has_prerequisite_of",
                sourceId: d.ID,
                targetId: temp_str[j]            
              }                                 
              relationships.push(relation_1)
            }       
          }
          else{ 
            rel_int = rel_int + 1;         
            rel_id = rel_pre.concat(rel_int);
            var relation_2 = {
              id: rel_id,
              type: "has_prerequisite_of",
              sourceId: d.ID,
              targetId: d.LOP            
            }                    
            relationships.push(relation_2)
          }
        }        
        // now add the course pre-reqs        
        if(d.Courses != temp){
          //set course id
          temp = d.Courses
          course_int = course_int + 1;
          course_id = course_pre.concat(course_int);
           // add course relationship to track
          rel_int = rel_int + 1;         
          rel_id = rel_pre.concat(rel_int);
          var relation_4 = {
            id: rel_id,
            type: "belongs_to",
            sourceId: course_id,
            targetId: "t1"
          }
          relationships.push(relation_4)
        }
        rel_int = rel_int + 1;         
        rel_id = rel_pre.concat(rel_int);
        var relation_3 = {
          id: rel_id,
          type: "belongs_to",
          sourceId: d.ID,
          targetId: course_id
        }        
        relationships.push(relation_3)                   
      }
      // add track to instituition
      rel_int = rel_int + 1;         
      rel_id = rel_pre.concat(rel_int);
      var relation_5 = {
        id: rel_id,
        type: "belongs_to",
        sourceId: "t1",
        targetId: "UofA"
      }
      relationships.push(relation_5)
      console.log(relationships)
      return relationships;
    };  
    // =====
    // instantiate a new Xoces widget
    // ========
    var cw = xoces.widgets.ChordWidget.new({
      hierarchy: ['institution', 'track', 'module', 'outcome'],
      data: {
        entities: institutions.concat(tracks, modules, outcomes),
        relationships: relationships
      },
      currentLevelEntity: 't1',
      view: 'TREE_VIEW',
      entityLabelKey: 'name',
      nodeLabelKey: 'name',
      relationship: {
        parentType: 'belongs_to',
        sourceRef: 'sourceId',
        targetRef: 'targetId',
      },
      width: '100%',
      height: 520,
      colorScheme: 'light'
    });  
    // render it into the specified container
    cw.render({
      container: 'xocesContainer1'
    });
});