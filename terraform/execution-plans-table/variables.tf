variable "table_count" {
  description = "How many resources to create"
  default = 0
}

variable "tags" {
  type = map(string)
}
