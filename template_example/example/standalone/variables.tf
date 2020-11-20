variable "nomad_acl" {
  type        = bool
  description = "Nomad ACLs enabled/disabled"
}

variable "vault_master_token" {
  type        = string
  description = "Vault master token"
}