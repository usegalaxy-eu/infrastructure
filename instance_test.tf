resource "openstack_blockstorage_volume_v2" "jwolff-test-data" {
  name        = "jwolff-test"
  description = "Data volume for test"
  size        = 20
}
