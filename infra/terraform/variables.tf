variable "microservice_name" {
  type        = string
  description = "Name for the microservice"
}

variable "python_version" {
  type        = string
  description = "Python runtime version"
  default     = "python3.9"
}
