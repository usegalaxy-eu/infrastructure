# upload
output "upload-node_name" {
  value = openstack_compute_instance_v2.upload.name
}
output "upload-node_public-ip-v4" {
  value = openstack_compute_instance_v2.upload.network.0.fixed_ip_v4
}
