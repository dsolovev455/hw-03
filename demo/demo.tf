variable "env_name" { 
  type = string
  default = "production" 
  }

variable "empty" { 
  type = string
  default = "" 
  }

locals{
  test_list = ["develop", "staging", "production"]
}


