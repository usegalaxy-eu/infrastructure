# datahub
output "datahub-node_name" {
  value = openstack_compute_instance_v2.datahub.name
}
output "datahub-node_public-ip-v4" {
  value = openstack_compute_instance_v2.datahub.network.0.fixed_ip_v4
}

# jump
output "jump-node_name" {
  value = openstack_compute_instance_v2.jump.name
}
output "jump-node_public-ip-v4" {
  value = openstack_compute_instance_v2.jump.network.0.fixed_ip_v4
}

# upload
output "upload-node_name" {
  value = openstack_compute_instance_v2.upload.name
}
output "upload-node_public-ip-v4" {
  value = openstack_compute_instance_v2.upload.network.0.fixed_ip_v4
}
