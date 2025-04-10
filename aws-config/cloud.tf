terraform { 
  cloud { 
    
    organization = "new-workshop-data" 

    workspaces { 
      name = "aws-config" 
    } 
  } 
}