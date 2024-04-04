module "network_module" {
  source = "../network"  
  user_data_path = "../templates/userdata.tpl"
  get_public_ip_script_path = "../templates/get_public_ip.sh"
}
