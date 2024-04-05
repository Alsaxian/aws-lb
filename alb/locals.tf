locals {
  listener_rule_priorities = { for idx, name in sort(module.network_module.backend_names) : name => idx + 100 }
}