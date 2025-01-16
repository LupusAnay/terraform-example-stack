variable "regions" {
  type = set(string)
}

variable "identity_token" {
  type = string
  ephemeral = true
}

variable "role_arn" {
  type = string
}

variable "default_tags" {
  description = "Tags"
  type = map(string)
  default = {}
}

