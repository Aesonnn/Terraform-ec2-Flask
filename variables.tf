# db_password is specified in the environment variable
variable "db_password" {
  description = "The database password for MySQL"
  type        = string
  sensitive   = true
}